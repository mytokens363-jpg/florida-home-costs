# STRIPE API INTEGRATION SCRIPT

## Python Stripe Integration for $29 Complete Bundle

### Requirements
```bash
pip install stripe
```

### Configuration
```python
import os
import stripe

# Set your Stripe secret key
stripe.api_key = os.environ.get("STRIPE_SECRET_KEY")

# Your Stripe public key (for frontend)
STRIPE_PUBLIC_KEY = "pk_live_..."
```

### Create Payment Session
```python
def create_payment_session(customer_email, customer_name):
    """Create a Stripe checkout session for the $29 Complete Bundle."""
    
    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'usd',
                    'product_data': {
                        'name': 'Real Estate Agent Prompt Pack - Complete Bundle',
                        'description': '50+ battle-tested prompts for real estate agents to save 10+ hours/week',
                    },
                    'unit_amount': 2900,  # $29.00 in cents
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url='https://example.com/success?session_id={CHECKOUT_SESSION_ID}',
            cancel_url='https://example.com/cancel',
            customer_email=customer_email,
            client_reference_id=customer_email,
            metadata={
                'customer_name': customer_name,
                'product': 'complete_bundle',
                'price': '29.00'
            }
        )
        return session.url
    except Exception as e:
        return str(e)
```

### Webhook Handler
```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def stripe_webhook():
    """Handle Stripe webhook events."""
    
    payload = request.get_data(as_text=True)
    sig_header = request.headers.get('Stripe-Signature')
    
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, os.environ.get("STRIPE_WEBHOOK_SECRET")
        )
    except ValueError as e:
        return jsonify({'error': 'Invalid payload'}), 400
    except stripe.error.SignatureVerificationError as e:
        return jsonify({'error': 'Invalid signature'}), 400
    
    # Handle payment successful event
    if event['type'] == 'checkout.session.completed':
        session = event['data']['object']
        handle_successful_payment(session)
    
    return jsonify({'status': 'success'}), 200

def handle_successful_payment(session):
    """Process a successful payment."""
    customer_email = session['customer_email']
    customer_name = session['metadata'].get('customer_name', 'Customer')
    
    # Deliver product via email
    send_product_delivery_email(
        to_email=customer_email,
        customer_name=customer_name,
        download_link='https://example.com/download'
    )
    
    # Log the sale
    log_sale(customer_email, customer_name, 29.00)
```

### Email Delivery Template
```python
def send_product_delivery_email(to_email, customer_name, download_link):
    """Send product delivery email after successful payment."""
    
    subject = "Your Real Estate Prompt Pack - Complete Bundle"
    body = f"""
Hi {customer_name},

Thanks for your purchase! Here's your Complete Bundle:

Download Link: {download_link}
Password: (none - public download)

What's included:
- 20 Email Templates
- 15 Social Media Posts
- 15 Listing Descriptions
- Bonus: Advanced AI Prompts

If you have any questions, just reply to this email.

Best regards,
The Rivet Team
"""
    
    # Use Resend API or SendGrid
    send_email(to_email, subject, body)
```

### Complete Flow Integration
```python
def process_payment(customer_email, customer_name):
    """Full payment processing flow."""
    
    # Step 1: Create checkout session
    payment_url = create_payment_session(customer_email, customer_name)
    
    if not payment_url.startswith('https://'):
        return {'error': payment_url}
    
    # Step 2: Return payment URL to frontend
    return {'payment_url': payment_url}
```

### Environment Variables
```bash
# .env file
STRIPE_SECRET_KEY=sk_live_xxxxxxxxxxxxxx
STRIPE_PUBLIC_KEY=pk_live_xxxxxxxxxxxxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxxxxxxxxxxxx
RESEND_API_KEY=re_xxxxxxxxxxxxxx
```

### Deployment Checklist
- [ ] Install stripe package: `pip install stripe`
- [ ] Set environment variables
- [ ] Create webhook endpoint
- [ ] Verify webhook signature
- [ ] Test with Stripe test mode
- [ ] Deploy to production
- [ ] Configure webhook in Stripe dashboard