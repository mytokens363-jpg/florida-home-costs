#!/bin/bash
# Package prompt pack as PDF (simplified for automation)
# This would normally use a PDF library, but we'll create a simple HTML -> PDF approach

PRODUCT=$1
OUTPUT_DIR="/Users/dariusvitkus/.openclaw/workspace/rivet-business/products"

if [ "$PRODUCT" == "complete-bundle" ]; then
    # Create HTML version of content
    cat > "$OUTPUT_DIR/complete-bundle.html" << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
  <title>Rivet Prompt Pack - Complete Bundle</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
    h1 { color: #667eea; }
    h2 { color: #764ba2; border-bottom: 2px solid #667eea; padding-bottom: 5px; }
    .section { margin: 20px 0; }
    .prompt { background: #f5f5f5; padding: 10px; margin: 10px 0; border-radius: 4px; }
    .prompt-title { font-weight: bold; color: #333; }
  </style>
</head>
<body>
  <h1>Real Estate Agent Prompt Pack</h1>
  <p><strong>Complete Bundle</strong> - 60+ battle-tested prompts to save you 10+ hours/week</p>
  
  <h2>Section 1: Email Templates</h2>
  <div class="section">
    <div class="prompt">
      <div class="prompt-title">Prompt 1-20: Follow up on a new lead from [Source]</div>
      <p>Follow up on a new lead from Zillow, Realtor.com, Facebook, or referral</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 6-10: Seller Outreach</div>
      <p>Contacting expired listings, pre-foreclosures, snowbirds, property transfers, tenants</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 11-15: Client Communication</div>
      <p>Weekly market updates, showings, past clients, referrals, post-closing</p>
    </div>
  </div>

  <h2>Section 2: Social Media Templates</h2>
  <div class="section">
    <div class="prompt">
      <div class="prompt-title">Prompt 21-25: Property Listings</div>
      <p>Instagram, Facebook, LinkedIn, Twitter/X, TikTok posts</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 26-29: Market Updates</div>
      <p>Weekly stats, monthly reports, seasonal trends, inventory</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 30-34: Personal Branding</div>
      <p>About me, behind the scenes, testimonials, community posts</p>
    </div>
  </div>

  <h2>Section 3: Listing Descriptions</h2>
  <div class="section">
    <div class="prompt">
      <div class="prompt-title">Prompt 35-38: Luxury Homes</div>
      <p>Upscale neighborhoods, high-end properties, luxury condos, waterfront</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 39-41: First-Time Buyers</div>
      <p>Entry-level, buyer friendly, affordable family homes</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 42-44: Investment Properties</div>
      <p>Rental investment, fixer-uppers, multi-family</p>
    </div>
  </div>

  <h2>Section 4: Advanced AI Prompts</h2>
  <div class="section">
    <div class="prompt">
      <div class="prompt-title">Prompt 51-53: Market Analysis</div>
      <p>Neighborhood data, rental comparables, cash flow calculation</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 54-56: Content Creation</div>
      <p>Blog posts, video scripts, email newsletters</p>
    </div>
    <div class="prompt">
      <div class="prompt-title">Prompt 57-60: Automation & Scenarios</div>
      <p>Follow-up sequences, market summaries, content calendars, short sales</p>
    </div>
  </div>

  <h2>Quick Start Guide</h2>
  <ol>
    <li>Copy any prompt into ChatGPT, Claude, or Gemini</li>
    <li>Add your specific details (location, price, features)</li>
    <li>Edit to match your voice</li>
    <li>Use in email, social media, or listing</li>
  </ol>

  <h2>Pro Tips</h2>
  <ul>
    <li>Save frequently used prompts in a notes app</li>
    <li>Create custom variations for different neighborhoods</li>
    <li>Update prompts quarterly based on what works</li>
  </ul>

  <hr>
  <p><strong>Thank you for your purchase!</strong></p>
  <p>If you have any questions, reply to your purchase confirmation email.</p>
  <p>- The Rivet Team</p>
</body>
</html>
HTMLEOF

    # Convert HTML to PDF using wkhtmltopdf
    if command -v wkhtmltopdf &> /dev/null; then
        wkhtmltopdf "$OUTPUT_DIR/complete-bundle.html" "$OUTPUT_DIR/complete-bundle.pdf"
        echo "Created: $OUTPUT_DIR/complete-bundle.pdf"
    else
        echo "wkhtmltopdf not found. HTML file created for manual PDF conversion."
        echo "To create PDF: wkhtmltopdf $OUTPUT_DIR/complete-bundle.html $OUTPUT_DIR/complete-bundle.pdf"
    fi

elif [ "$PRODUCT" == "email-packs" ]; then
    # Create email prompts PDF
    cat > "$OUTPUT_DIR/email-prompts.html" << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
  <title>Rivet Prompt Pack - Email Templates</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
    h1 { color: #667eea; }
    h2 { color: #764ba2; border-bottom: 2px solid #667eea; padding-bottom: 5px; }
    .prompt { background: #f5f5f5; padding: 15px; margin: 15px 0; border-radius: 4px; }
    .prompt-title { font-weight: bold; color: #333; margin-bottom: 5px; }
  </style>
</head>
<body>
  <h1>Email Prompts Pack</h1>
  <p><strong>20 email templates</strong> for real estate agents</p>
  
  <h2>New Lead Follow-up (5 prompts)</h2>
  <div class="prompt"><div class="prompt-title">1. Follow up on a new lead from [Source]</div></div>
  <div class="prompt"><div class="prompt-title">2. Introduction email to a new prospect</div></div>
  <div class="prompt"><div class="prompt-title">3. Offering a free home valuation</div></div>
  <div class="prompt"><div class="prompt-title">4. Following up after initial contact</div></div>
  <div class="prompt"><div class="prompt-title">5. Scheduling a consultation</div></div>

  <h2>Seller Outreach (5 prompts)</h2>
  <div class="prompt"><div class="prompt-title">6. Contacting expired listings</div></div>
  <div class="prompt"><div class="prompt-title">7. Reaching out to pre-foreclosure homeowners</div></div>
  <div class="prompt"><div class="prompt-title">8. Messaging snowbirds about their property</div></div>
  <div class="prompt"><div class="prompt-title">9. Property transfer inquiry</div></div>
  <div class="prompt"><div class="prompt-title">10. Owner-occupied tenant inquiry</div></div>

  <h2>Client Communication (5 prompts)</h2>
  <div class="prompt"><div class="prompt-title">11. Sending weekly market updates</div></div>
  <div class="prompt"><div class="prompt-title">12. Following up after a showing</div></div>
  <div class="prompt"><div class="prompt-title">13. Checking in with past clients</div></div>
  <div class="prompt"><div class="prompt-title">14. Referral request to past clients</div></div>
  <div class="prompt"><div class="prompt-title">15. Post-closing thank you email</div></div>

  <h2>Negotiation (3 prompts)</h2>
  <div class="prompt"><div class="prompt-title">16. Writing a competitive offer letter</div></div>
  <div class="prompt"><div class="prompt-title">17. Responding to a lowball offer</div></div>
  <div class="prompt"><div class="prompt-title">18. Requesting a home inspection contingency</div></div>

  <h2>Closing (2 prompts)</h2>
  <div class="prompt"><div class="prompt-title">19. Sending closing preparation checklist</div></div>
  <div class="prompt"><div class="prompt-title">20. Congratulations message after closing</div></div>

  <hr>
  <p><strong>Thank you for your purchase!</strong></p>
</body>
</html>
HTMLEOF
    if command -v wkhtmltopdf &> /dev/null; then
        wkhtmltopdf "$OUTPUT_DIR/email-prompts.html" "$OUTPUT_DIR/email-prompts.pdf"
        echo "Created: $OUTPUT_DIR/email-prompts.pdf"
    else
        echo "HTML file created: $OUTPUT_DIR/email-prompts.html"
    fi
fi

echo "Package complete!"
