import Foundation
import Vision
import CoreImage

let args = CommandLine.arguments
let imagePath = args[1]
let url = URL(fileURLWithPath: imagePath)

guard let ciImage = CIImage(contentsOf: url) else {
    print("Failed to load image")
    exit(1)
}

// First try face detection
let faceRequest = VNDetectFaceRectanglesRequest { (request, error) in
    if let results = request.results as? [VNFaceObservation], !results.isEmpty {
        for face in results {
            let bbox = face.boundingBox
            print("FACE DETECTED at x=\(bbox.origin.x), y=\(bbox.origin.y), w=\(bbox.size.width), h=\(bbox.size.height)")
        }
    } else {
        print("NO FACES DETECTED")
    }
}

// Then try saliency (attention based)
let saliencyRequest = VNGenerateAttentionBasedSaliencyImageRequest { (request, error) in
    if let results = request.results as? [VNSaliencyImageObservation], let observation = results.first {
        if let salientObjects = observation.salientObjects {
            for obj in salientObjects {
                let bbox = obj.boundingBox
                print("SALIENT OBJECT at x=\(bbox.origin.x), y=\(bbox.origin.y), w=\(bbox.size.width), h=\(bbox.size.height)")
            }
        }
    }
}

let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
try? handler.perform([faceRequest, saliencyRequest])
