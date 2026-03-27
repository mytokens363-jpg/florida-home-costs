# STRIPE CHECKOUT CONFIGURATION

## $29 Complete Bundle - Stripe Integration

### Product Details
- **Product Name:** Real Estate Agent Prompt Pack - Complete Bundle
- **Price:** $29.00 (one-time payment)
- **Description:** 50+ battle-tested prompts for real estate agents to save 10+ hours/week

### Payment Flow
```
1. Customer clicks "Buy Now" on landing page
2. Redirected to Stripe Checkout page
3. Customer enters payment info
4. Payment processed via Stripe
5. Auto-delivery: PDF download link emailed
6. Customer redirected to "Thank You" page
```

### Stripe Setup Steps

1. **Create Stripe Account**
   - Go to stripe.com
   - Sign up for Stripe account
   - Verify business email

2. **Configure Products**
   - Navigate to Products in Stripe dashboard
   - Create new product: "Real Estate Prompt Pack"
   - Set price: $29.00
   - Add description: "50+ prompts for real estate agents"

3. **Setup Payment Links**
   - Go to Payment Links in Stripe
   - Create new payment link
   - Select product: Real Estate Prompt Pack
   - Set price: $29.00
   - Configure auto-delivery email template
   - Copy payment link URL

4. **Integrate with Landing Page**
   - Add "Buy Complete Bundle for $29" button
   - Link to Stripe payment link
   - Use Stripe-hosted checkout (no coding needed)

### Stripe API (Optional - Future)
If you want automation beyond payment links:

```python
# Stripe API for custom checkout
import stripe
stripe.api_key = "sk_live_..."

# Create checkout session
checkout_session = stripe.checkout.Session.create(
    line_items=[{
        'price': 'price_...',
        'quantity': 1,
    }],
    mode='payment',
    success_url='https://example.com/success',
    cancel_url='https://example.com/cancel',
)
```

### Payment Links
**Payment Link URL Format:**
```
https://buy.stripe.com/[STRIPE_CODE]
```

**Example Payment Link for $29 Bundle:**
```
https://buy.stripe.com/00g5kR6FgdH1234567
```

### Stripe Dashboard Setup Checklist
- [ ] Create Stripe account
- [ ] Verify email address
- [ ] Complete business verification
- [ ] Create product in Stripe dashboard
- [ ] Set up payment links
- [ ] Configure email receipt template
- [ ] Test payment flow with test card
- [ ] Integrate payment link into landing page

### Test Card Numbers
```
4242 4242 4242 4242 (Success)
4000 0566 5566 5556 (Decline)
```

### Live vs Test Mode
- **Test Mode:** Use test card numbers, no real charges
- **Live Mode:** Real payments, requires business verification

### Next Steps
1. Sign up for Stripe account
2. Complete business verification
3. Create product with $29 price
4. Generate payment link
5. Add to landing page
6. Test with Stripe test card