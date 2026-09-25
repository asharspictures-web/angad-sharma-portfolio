import sys

with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Add CSS for career highlights
css_old = '''    .career-action-img {'''
css_new = '''    .career-highlights {
      list-style: none;
      padding: 0;
      margin: 24px 0 0 0;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      padding-top: 24px;
    }
    
    .career-highlights li {
      position: relative;
      padding-left: 24px;
      margin-bottom: 12px;
      color: var(--text-muted);
      font-size: 1.05rem;
      line-height: 1.5;
    }
    
    .career-highlights li::before {
      content: "";
      position: absolute;
      left: 0;
      top: 10px;
      width: 6px;
      height: 6px;
      background: var(--brass);
      border-radius: 50%;
    }
    
    .career-highlights li strong {
      color: var(--text-pure);
      font-weight: 600;
    }

    .career-action-img {'''

if 'career-highlights' not in content:
    content = content.replace(css_old, css_new)

html_old = '''            <p class="lead-paragraph">
              Proven leadership on world-class tanker fleets. Zero-incident record across complex cargo operations, dry-docking overhauls, and strict oil major vetting regimes.
            </p>
          </div>
          <div class="career-action-shot">'''

html_new = '''            <p class="lead-paragraph">
              Proven leadership on world-class tanker fleets. Zero-incident record across complex cargo operations, dry-docking overhauls, and strict oil major vetting regimes.
            </p>
            <ul class="career-highlights">
              <li><strong>Vessels:</strong> Commanded VLCCs & Chemical Carriers up to 319,471 GRT.</li>
              <li><strong>Safety Governance:</strong> Flawless execution of high-risk cargo transfers.</li>
              <li><strong>Compliance:</strong> Maintained impeccable SIRE, CDI, and PSC inspection records.</li>
              <li><strong>Global Logistics:</strong> 20 years navigating major international deep-sea corridors.</li>
            </ul>
          </div>
          <div class="career-action-shot">'''

if html_old in content:
    content = content.replace(html_old, html_new)
    with open('index.html', 'w', encoding='utf-8') as f:
        f.write(content)
    print("Success")
else:
    print("Failed to replace HTML")
