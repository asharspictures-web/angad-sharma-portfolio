import Foundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import AppKit

let args = CommandLine.arguments
let inputPath = args[1]
let outputPath = args[2]

let url = URL(fileURLWithPath: inputPath)
guard let ciImage = CIImage(contentsOf: url) else { exit(1) }

let context = CIContext(options: nil)

// 1. Person Segmentation for Background Blur
let request = VNGeneratePersonSegmentationRequest()
request.qualityLevel = .accurate

let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
try? handler.perform([request])

guard let maskPixelBuffer = request.results?.first?.pixelBuffer else { exit(1) }
let maskImage = CIImage(cvPixelBuffer: maskPixelBuffer).resize(to: ciImage.extent.size)

// Blur the original image
let blurFilter = CIFilter.gaussianBlur()
blurFilter.inputImage = ciImage
blurFilter.radius = 20.0
let blurredImage = blurFilter.outputImage!.cropped(to: ciImage.extent)

// Blend original over blurred using mask
let blendFilter = CIFilter.blendWithMask()
blendFilter.inputImage = ciImage
blendFilter.backgroundImage = blurredImage
blendFilter.maskImage = maskImage
guard let blendedImage = blendFilter.outputImage else { exit(1) }

// 2. Face Detection for Cropping
let faceRequest = VNDetectFaceRectanglesRequest()
let faceHandler = VNImageRequestHandler(ciImage: blendedImage, options: [:])
try? faceHandler.perform([faceRequest])

guard let face = faceRequest.results?.first else { exit(1) }

let imageSize = blendedImage.extent.size
let bbox = face.boundingBox

let faceRect = CGRect(
    x: bbox.origin.x * imageSize.width,
    y: bbox.origin.y * imageSize.height,
    width: bbox.size.width * imageSize.width,
    height: bbox.size.height * imageSize.height
)

let cropWidth = faceRect.width * 4.0
let cropHeight = cropWidth * 1.25

let cropX = faceRect.midX - (cropWidth / 2.0)
let cropMaxY = faceRect.maxY + (faceRect.height * 0.7)
let cropY = cropMaxY - cropHeight

var cropRect = CGRect(x: cropX, y: cropY, width: cropWidth, height: cropHeight)
cropRect = cropRect.intersection(blendedImage.extent)

let croppedImage = blendedImage.cropped(to: cropRect)

guard let cgImage = context.createCGImage(croppedImage, from: croppedImage.extent) else { exit(1) }

let nsImage = NSImage(cgImage: cgImage, size: NSZeroSize)
guard let tiffData = nsImage.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 1.0]) else {
    exit(1)
}

try? jpegData.write(to: URL(fileURLWithPath: outputPath))
print("Saved without downscaling and at 100% quality")

extension CIImage {
    func resize(to size: CGSize) -> CIImage {
        let scaleX = size.width / self.extent.width
        let scaleY = size.height / self.extent.height
        return self.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}
