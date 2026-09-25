import sys

with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()

html_old = '''            <ul class="career-highlights">
              <li><strong>Vessels:</strong> Commanded VLCCs & Chemical Carriers up to 319,471 GRT.</li>
              <li><strong>Safety Governance:</strong> Flawless execution of high-risk cargo transfers.</li>
              <li><strong>Compliance:</strong> Maintained impeccable SIRE, CDI, and PSC inspection records.</li>
              <li><strong>Global Logistics:</strong> 20 years navigating major international deep-sea corridors.</li>
            </ul>'''

html_new = '''            <div class="career-metrics-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 24px; padding-top: 24px; border-top: 1px solid rgba(255, 255, 255, 0.1);">
              <ul class="career-highlights" style="margin-top: 0; padding-top: 0; border-top: none;">
                <li style="margin-bottom: 16px;"><strong>Command Scope:</strong> Chief Officer on VLCCs & Chemical Carriers up to 319,471 GRT.</li>
                <li style="margin-bottom: 16px;"><strong>Cargo Operations:</strong> Expert oversight of million-barrel crude transfers, STS (Ship-to-Ship) operations, and hazardous liquid bulk management.</li>
                <li style="margin-bottom: 16px;"><strong>Ship Stability:</strong> Advanced load planning, hull stress monitoring, and dynamic ballast water management.</li>
              </ul>
              <ul class="career-highlights" style="margin-top: 0; padding-top: 0; border-top: none;">
                <li style="margin-bottom: 16px;"><strong>Safety & Compliance:</strong> Impeccable SIRE, CDI, MARPOL, and Port State Control (PSC) vetting records.</li>
                <li style="margin-bottom: 16px;"><strong>Deck Administration:</strong> Comprehensive leadership of deck department, planned maintenance systems (PMS), and crew training.</li>
                <li style="margin-bottom: 16px;"><strong>Global Navigation:</strong> 20+ years of deep-sea route planning and heavy weather navigation across all major international shipping lanes.</li>
              </ul>
            </div>'''

if html_old in content:
    content = content.replace(html_old, html_new)
    with open('index.html', 'w', encoding='utf-8') as f:
        f.write(content)
    print("Success")
else:
    print("Failed to replace HTML")
