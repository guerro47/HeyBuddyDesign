# HeyBuddyDesign n8n Workflows - UK Pricing Setup Guide

Complete guide for implementing automated workflows with UK pricing, affordable positioning, and payment plan options.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Workflow Files](#workflow-files)
4. [Installation Steps](#installation-steps)
5. [Configuration](#configuration)
6. [Testing](#testing)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

These workflows automate your entire customer journey from lead capture to project kickoff, specifically optimized for UK pricing (£150-£5,000+) with affordable payment plans.

### What's Included:

- **Workflow 1**: Lead Capture to CRM (UK Pricing) - Automatic lead scoring based on UK budget ranges
- **Workflow 2**: Contract to Kickoff (UK Pricing) - Automated invoicing with payment plan support
- **Contact Form**: UK-optimized form with budget ranges
- **Pricing Calculator**: Interactive calculator with 10% discount

### Key Features:

✅ UK pricing ranges (£150-£5,000+)
✅ Intelligent lead scoring
✅ Payment plan calculations (4-6 months interest-free)
✅ Automated email responses
✅ Slack notifications for hot leads
✅ HubSpot/CRM integration
✅ 10% new client discount

---

## 🔧 Prerequisites

### Required Services:

1. **n8n Instance**
   - Self-hosted or n8n Cloud
   - Version 1.0.0 or higher
   - Public URL for webhooks

2. **Email Service** (choose one):
   - SMTP (Gmail, Outlook, etc.)
   - SendGrid
   - Mailgun
   - AWS SES

3. **CRM** (optional but recommended):
   - HubSpot (free tier works)
   - Pipedrive
   - Airtable
   - Google Sheets

4. **Slack** (optional):
   - For hot lead notifications
   - Free workspace works

5. **DocuSign** (for contract workflow):
   - Free trial available
   - Or alternative: PandaDoc, HelloSign

---

## 📁 Workflow Files

```
n8n-workflows/
├── 01-lead-capture-to-crm-uk.json      # Main lead capture workflow
├── 03-contract-to-kickoff-uk.json      # Contract signed workflow
└── README.md                            # This file

forms/
├── contact-form-uk.html                 # UK pricing contact form
└── pricing-calculator.html              # Interactive pricing calculator
```

---

## 🚀 Installation Steps

### Step 1: Set Up n8n

#### Option A: n8n Cloud (Easiest)
```bash
# Sign up at https://n8n.io/cloud
# No installation needed!
```

#### Option B: Self-Hosted (Docker)
```bash
# Install n8n with Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

#### Option C: npm
```bash
npm install n8n -g
n8n start
```

### Step 2: Import Workflows

1. Open n8n (usually at `http://localhost:5678` or your cloud URL)
2. Click **"Workflows"** in the left sidebar
3. Click **"Import from File"**
4. Select `01-lead-capture-to-crm-uk.json`
5. Repeat for `03-contract-to-kickoff-uk.json`

### Step 3: Configure Credentials

#### Email Credentials (SMTP)
1. Go to **Credentials** → **Create New**
2. Select **SMTP**
3. Fill in your email details:
   ```
   Host: smtp.gmail.com (for Gmail)
   Port: 587
   User: your-email@gmail.com
   Password: your-app-password
   ```
4. Save as "SMTP"

#### HubSpot Credentials (Optional)
1. Go to **Credentials** → **Create New**
2. Select **HubSpot API**
3. Click **"Connect my account"**
4. Authorize n8n to access HubSpot
5. Save as "HubSpot API"

#### Slack Credentials (Optional)
1. Go to **Credentials** → **Create New**
2. Select **Slack OAuth2**
3. Follow the OAuth flow
4. Save as "Slack OAuth2"

### Step 4: Configure Webhooks

#### Workflow 1: Lead Capture

1. Open the workflow
2. Click the **"Webhook - Contact Form"** node
3. Click **"Execute Node"** to get the webhook URL
4. Copy the URL (looks like: `https://your-n8n.com/webhook/contact-form`)
5. Update `contact-form-uk.html` line 239:
   ```javascript
   const response = await fetch('YOUR_WEBHOOK_URL_HERE', {
   ```

#### Workflow 2: Contract Signed

1. Open the workflow
2. Click the **"Webhook - DocuSign Contract Signed"** node
3. Copy the webhook URL
4. Add this URL to DocuSign webhook settings

---

## ⚙️ Configuration

### Customize Lead Scoring

Edit the **"Calculate Lead Score (UK)"** function node:

```javascript
// Adjust budget scoring
if (budget.includes('5000') || budget.includes('£5k+')) {
  score += 30; // Change this value
}

// Adjust hot lead threshold
if (score >= 70) { // Change from 70 to your preferred threshold
  priority = 'High';
  category = 'Hot Lead - £1,000+';
}
```

### Customize Email Templates

Edit email nodes to match your branding:

1. Open the **"Email - Confirmation to Lead (UK)"** node
2. Modify the HTML template
3. Update:
   - Company colors
   - Logo URLs
   - Contact information
   - Pricing ranges

### Customize Pricing Calculator

Edit `forms/pricing-calculator.html`:

```javascript
// Update base prices
const prices = {
  starter: 225,      // Change to your price
  business: 450,     // Change to your price
  professional: 750, // Change to your price
  premium: 1050,     // Change to your price
};

// Update discount percentage
const discount = total * 0.10; // Change 0.10 to your discount
```

### Add Payment Plan Logic

In contract workflow, customize payment plans:

```javascript
if (total <= 900) {
  numberOfPayments = 4; // 4 months for projects under £900
} else if (total <= 1200) {
  numberOfPayments = 5; // 5 months for £900-£1,200
} else {
  numberOfPayments = 6; // 6 months for £1,200+
}
```

---

## 🧪 Testing

### Test Lead Capture Workflow

1. **Activate the workflow** in n8n
2. Open `forms/contact-form-uk.html` in a browser
3. Fill out the form with test data:
   ```
   Name: Test User
   Email: test@example.com
   Budget: £1,000-£2,000
   Timeline: ASAP - Urgent
   Service: Professional Website
   Message: This is a test message with over 150 characters...
   ```
4. Submit the form
5. Check:
   - ✅ Lead appears in HubSpot/CRM
   - ✅ Confirmation email received
   - ✅ Team notification email received
   - ✅ Slack notification (if score >= 70)

### Test Scoring System

Test different scenarios:

| Budget | Timeline | Service | Expected Score | Priority |
|--------|----------|---------|----------------|----------|
| £5,000+ | ASAP | AI Chatbot | 75+ | High |
| £1,000-£2,000 | 1 month | Professional | 55+ | Medium-High |
| £200-£500 | 3-6 months | Starter | 30+ | Medium |
| Under £200 | Flexible | Basic | <30 | Low |

### Test Contract Workflow

1. Create a test DocuSign envelope
2. Add custom fields:
   - ProjectName: "Test Website"
   - ProjectType: "Professional Website"
   - TotalAmount: "750"
   - PaymentPlan: "Monthly"
3. Sign the contract
4. Check:
   - ✅ Invoice email received
   - ✅ Correct payment plan calculated
   - ✅ Stripe payment link works

---

## 🐛 Troubleshooting

### Webhook Not Working

**Problem**: Form submission doesn't trigger workflow

**Solutions**:
1. Check webhook URL is correct in HTML form
2. Ensure workflow is **activated** (toggle in top right)
3. Check n8n logs: Settings → Log Streaming
4. Test webhook directly:
   ```bash
   curl -X POST https://your-n8n.com/webhook/contact-form \
     -H "Content-Type: application/json" \
     -d '{"name":"Test","email":"test@example.com"}'
   ```

### Emails Not Sending

**Problem**: Confirmation emails not being delivered

**Solutions**:
1. Verify SMTP credentials
2. Check spam folder
3. Test SMTP connection:
   - Go to Credentials
   - Click "Test" on SMTP credential
4. Enable "Less secure apps" (Gmail)
5. Use App Passwords (Gmail 2FA)

### Lead Score Not Calculating

**Problem**: All leads showing score of 0

**Solutions**:
1. Check function node for errors
2. Verify budget/timeline field names match form
3. Test function node manually
4. Check console logs in n8n

### HubSpot Not Updating

**Problem**: Contacts not appearing in HubSpot

**Solutions**:
1. Re-authorize HubSpot credentials
2. Check HubSpot API limits
3. Verify email field is not empty
4. Check HubSpot field mappings

### Payment Plan Not Calculating

**Problem**: Monthly payment showing £0

**Solutions**:
1. Verify `TotalAmount` custom field in DocuSign
2. Check `parseFloat()` conversion
3. Ensure PaymentPlan = "Monthly"
4. Verify threshold (£600 minimum)

---

## 📊 Lead Scoring Reference

### UK Pricing Tiers

| Budget Range | Score | Priority | Action |
|--------------|-------|----------|--------|
| £5,000+ | +30 | High | Call within 2 hours |
| £2,000-£5,000 | +25 | High | Call within 4 hours |
| £1,000-£2,000 | +20 | Medium-High | Call within 24 hours |
| £500-£1,000 | +15 | Medium | Email + book call |
| £200-£500 | +10 | Medium | Send pricing |
| Under £200 | +5 | Low | Nurture sequence |

### Timeline Urgency

| Timeline | Score | Notes |
|----------|-------|-------|
| ASAP/Urgent | +25 | Highest priority |
| Within 1 month | +20 | Hot lead |
| 1-2 months | +15 | Warm lead |
| 2-3 months | +15 | Warm lead |
| 3-6 months | +10 | Cold lead |
| Flexible | +5 | Low priority |

### Service Type

| Service | Score | Notes |
|---------|-------|-------|
| AI/Chatbot/Automation | +20 | High value |
| Premium/Professional | +15 | Medium-high value |
| Business/Web Design | +10 | Standard value |
| Starter/Basic | +5 | Entry level |

### Additional Factors

| Factor | Score | Why? |
|--------|-------|------|
| Company name provided | +10 | Business client |
| Message > 150 chars | +10 | Serious inquiry |
| Message > 75 chars | +5 | Some interest |
| Phone provided | +5 | Easier to close |

---

## 💡 Best Practices

### 1. Response Times

- **Hot Leads (70+)**: Call within 2 hours
- **Warm Leads (50-69)**: Call within 24 hours
- **Medium Leads (30-49)**: Email within 24 hours
- **Cold Leads (<30)**: Add to nurture sequence

### 2. Email Templates

- Keep emails conversational and friendly
- Always mention payment plans
- Include clear call-to-action
- Add social proof (testimonials)
- Highlight UK-based support

### 3. Payment Plans

- Offer interest-free plans for £600+
- 50/50 split for projects under £600
- 4-6 month plans for larger projects
- Always mention "no interest" and "no credit check"

### 4. Discount Strategy

- 10% new client discount (standard)
- 15% for students/charities
- Bundle discounts for multiple services
- Seasonal promotions

### 5. Follow-Up Sequence

Day 0: Instant confirmation email
Day 1: Follow-up call (hot leads)
Day 2: Portfolio email (warm leads)
Day 7: Check-in email
Day 14: Last chance offer
Day 30: Add to newsletter

---

## 🔐 Security Considerations

### Webhook Security

Add authentication to webhooks:

```javascript
// In Validate & Clean Data node
const secret = $input.item.json.headers['x-webhook-secret'];
if (secret !== 'your-secret-key') {
  throw new Error('Unauthorized');
}
```

### Data Privacy

- Never log sensitive data
- Comply with UK GDPR
- Use HTTPS for all webhooks
- Encrypt stored credentials
- Regular security audits

### Rate Limiting

Add rate limiting to prevent abuse:

```javascript
// Store submission IPs
const submissionsToday = $workflow.getStaticData('submissions') || {};
const ip = $input.item.json.headers['x-forwarded-for'];
const today = new Date().toISOString().split('T')[0];

if (submissionsToday[ip] >= 5) {
  throw new Error('Rate limit exceeded');
}
```

---

## 🚀 Deployment Checklist

Before going live:

- [ ] Test all workflows end-to-end
- [ ] Verify webhook URLs are correct
- [ ] Test email delivery (inbox + spam)
- [ ] Check Slack notifications work
- [ ] Verify HubSpot integration
- [ ] Test lead scoring calculation
- [ ] Test payment plan calculation
- [ ] Update contact information in emails
- [ ] Add your logo to email templates
- [ ] Set up proper error handling
- [ ] Enable workflow monitoring
- [ ] Test on mobile devices
- [ ] Verify GDPR compliance
- [ ] Set up backup/export
- [ ] Document custom changes

---

## 📞 Support

### n8n Documentation
- https://docs.n8n.io/

### HubSpot API
- https://developers.hubspot.com/

### Need Help?
- Email: hello@heybuddydesign.com
- Discord: n8n Community Server

---

## 📝 License

MIT License - Feel free to customize for your business!

---

## 🎉 Next Steps

1. ✅ Import workflows
2. ✅ Configure credentials
3. ✅ Test thoroughly
4. ✅ Deploy contact form
5. ✅ Monitor and optimize

**Good luck with your automated lead generation! 🚀**
