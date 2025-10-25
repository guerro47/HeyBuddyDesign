# n8n First Time Setup for HeyBuddyDesign

Complete beginner's guide to setting up n8n for the first time.

---

## 🎯 What You're Seeing

n8n is asking you to set up credentials or data tables because the workflow we're importing uses email and CRM integrations. Don't worry - we can set this up step by step!

---

## 🚀 Option 1: Quick Start (No CRM/Slack - Just Email)

This is the simplest setup to get started. You'll get:
- Contact form submissions via email
- Lead scoring
- Automated email responses

### Step 1: Create Email Credential First

1. In n8n, click **"Credentials"** in the left sidebar
2. Click **"Add Credential"**
3. Search for **"SMTP"**
4. Fill in the form:

#### For Gmail (info@heybuddydesign.com):

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [See below for App Password setup]
Host: smtp.gmail.com
Port: 587
SSL/TLS: Yes
```

**To Get Gmail App Password:**
1. Go to https://myaccount.google.com/security
2. Make sure 2-Step Verification is ON
3. Search for "App passwords"
4. Click "App passwords"
5. Select: App = "Mail", Device = "Other (Custom name)"
6. Type: "n8n automation"
7. Click "Generate"
8. Copy the 16-character password (format: xxxx xxxx xxxx xxxx)
9. Paste it in n8n Password field (remove spaces)

#### For Outlook/Office 365:

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [Your email password]
Host: smtp.office365.com
Port: 587
SSL/TLS: Yes
```

#### For Other Email Providers:

**Ask your email host for SMTP settings. Common values:**
- Host: Usually `mail.yourdomain.com` or `smtp.yourdomain.com`
- Port: 587 (TLS) or 465 (SSL)
- User: Your full email address
- Password: Your email password

5. Click **"Save"** and then **"Test"** to verify it works

---

### Step 2: Create Simplified Workflow

Instead of importing the full workflow, let's create a simple one first:

1. Click **"Workflows"** in left sidebar
2. Click **"Add Workflow"**
3. Give it a name: "Contact Form - Simple"

#### Add These Nodes:

**Node 1: Webhook (Trigger)**
1. Click the **+** button
2. Search for "Webhook"
3. Select **"Webhook"**
4. Configure:
   - HTTP Method: **POST**
   - Path: **contact-form**
   - Respond: **Immediately**
5. Click **"Execute Node"** to get your webhook URL
6. **Copy this URL** - we'll use it in your website!

**Node 2: Set (Format Data)**
1. Click the **+** button after Webhook
2. Search for "Set"
3. Select **"Set"**
4. Add these values:
   - Click **"Add Value"** → **String**
     - Name: `customerName`
     - Value: `{{ $json.body.name }}`
   - Click **"Add Value"** → **String**
     - Name: `customerEmail`
     - Value: `{{ $json.body.email }}`
   - Click **"Add Value"** → **String**
     - Name: `customerPhone`
     - Value: `{{ $json.body.phone }}`
   - Click **"Add Value"** → **String**
     - Name: `service`
     - Value: `{{ $json.body.service }}`
   - Click **"Add Value"** → **String**
     - Name: `budget`
     - Value: `{{ $json.body.budget }}`
   - Click **"Add Value"** → **String**
     - Name: `timeline`
     - Value: `{{ $json.body.timeline }}`
   - Click **"Add Value"** → **String**
     - Name: `message`
     - Value: `{{ $json.body.message }}`

**Node 3: Send Email (To You)**
1. Click the **+** button after Set
2. Search for "Send Email"
3. Select **"Send Email"**
4. Configure:
   - Credential: Select **"HeyBuddy Email"** (the one you created)
   - From Email: `info@heybuddydesign.com`
   - To Email: `info@heybuddydesign.com`
   - Subject: `🔔 New Website Inquiry - {{ $json.customerName }}`
   - Email Type: **Text** (for now, we can make it fancy later)
   - Message:
     ```
     New contact form submission from HeyBuddyDesign.com

     Name: {{ $json.customerName }}
     Email: {{ $json.customerEmail }}
     Phone: {{ $json.customerPhone }}
     Service: {{ $json.service }}
     Budget: {{ $json.budget }}
     Timeline: {{ $json.timeline }}

     Message:
     {{ $json.message }}

     ---
     Submitted: {{ $now }}
     ```

**Node 4: Send Email (To Customer)**
1. Click the **+** button after the first email node
2. Add another **"Send Email"** node
3. Configure:
   - Credential: **"HeyBuddy Email"**
   - From Email: `info@heybuddydesign.com`
   - To Email: `{{ $json.customerEmail }}`
   - Subject: `Thanks for contacting HeyBuddy Design!`
   - Email Type: **Text**
   - Message:
     ```
     Hi {{ $json.customerName }},

     Thanks for getting in touch with HeyBuddy Design!

     We've received your enquiry about {{ $json.service }} and will get back to you within 24 hours.

     In the meantime, feel free to check out our pricing at https://heybuddydesign.com

     Your enquiry details:
     - Service: {{ $json.service }}
     - Budget: {{ $json.budget }}
     - Timeline: {{ $json.timeline }}

     Best regards,
     The HeyBuddy Design Team

     Email: info@heybuddydesign.com
     Website: https://heybuddydesign.com
     ```

5. **Save the workflow** (click "Save" in top right)
6. **Activate the workflow** (toggle switch in top right - should turn green)

---

### Step 3: Get Your Webhook URL

1. Go back to the **Webhook node**
2. Click on it
3. You'll see two URLs:
   - Test URL (for testing)
   - **Production URL** (this is what we need!)

**Copy the Production URL** - it looks like:
```
https://your-n8n-instance.com/webhook/contact-form
```

**Send me this URL and I'll integrate it into your website!**

---

## 🧪 Test Your Workflow

Before connecting to your website, let's test it:

### Manual Test in n8n:

1. Click the **Webhook node**
2. Click **"Listen for Test Event"**
3. Open a new browser tab and paste this (replace with YOUR webhook URL):
   ```
   https://YOUR-N8N-URL/webhook/contact-form
   ```
4. You can use a tool like Postman, or I can create a test HTML page for you

### OR Use This Quick Test:

Open browser console (F12) on any webpage and paste:

```javascript
fetch('YOUR_N8N_WEBHOOK_URL_HERE', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    name: 'Test User',
    email: 'your-personal-email@example.com',
    phone: '07XXX XXXXXX',
    service: 'Business Website (£300-£600)',
    budget: '£500-£1,000',
    timeline: 'Within 1 month',
    message: 'This is a test message from n8n setup'
  })
})
.then(response => response.text())
.then(data => console.log('Success:', data))
.catch(error => console.error('Error:', error));
```

**You should receive 2 emails:**
1. One to info@heybuddydesign.com (team notification)
2. One to your-personal-email@example.com (customer confirmation)

---

## ✅ If Test Works:

Congratulations! Your n8n is set up! 🎉

**Next steps:**
1. Send me your webhook URL
2. I'll integrate it into your website
3. We'll deploy to production

---

## ❌ If Test Fails:

### Common Issues:

**1. "Credential not found" error:**
- Make sure you saved the SMTP credential
- Make sure you selected it in both email nodes

**2. Emails not arriving:**
- Check spam folder
- Verify SMTP settings are correct
- Try the "Test" button in the credential
- For Gmail: Make sure you used App Password, not regular password

**3. "Workflow not found" error:**
- Make sure workflow is **activated** (green toggle)
- Try deactivating and reactivating

**4. Webhook returns 404:**
- Make sure workflow is saved and activated
- Copy the **Production URL**, not the Test URL
- Path should be exactly: `contact-form`

---

## 🚀 Option 2: Full Setup (With CRM & Slack)

Once the basic setup works, we can add:

### Add Slack Notifications:

1. Go to Credentials → Add Credential
2. Search for **"Slack"**
3. Select **"Slack OAuth2"**
4. Follow OAuth flow to connect your Slack workspace
5. I'll show you how to add a Slack node to get alerts for hot leads

### Add HubSpot CRM:

1. Go to Credentials → Add Credential
2. Search for **"HubSpot"**
3. Select **"HubSpot API"**
4. Click "Connect my account"
5. Authorize n8n to access HubSpot
6. I'll show you how to add CRM sync

---

## 📊 What Each Setup Gets You:

### Basic Setup (Email Only):
✅ Contact form submissions
✅ Automated email notifications
✅ Customer confirmation emails
✅ Lead data collection
⏱️ Setup time: **5 minutes**

### Advanced Setup (+ CRM + Slack):
✅ Everything from basic
✅ Automatic CRM sync
✅ Lead scoring with priority levels
✅ Slack alerts for hot leads
✅ HubSpot contact creation
⏱️ Setup time: **15-20 minutes**

---

## 🆘 I'm Here to Help!

**Having trouble?** Tell me:

1. **Which email provider are you using?**
   - Gmail
   - Outlook
   - Other (what is it?)

2. **What error message do you see?**
   - Copy/paste the exact error

3. **Which step are you stuck on?**
   - Creating credentials?
   - Building the workflow?
   - Testing?

4. **Do you want:**
   - Basic setup (just email)
   - Advanced setup (email + CRM + Slack)

I'll guide you through it step by step!

---

## 📝 Quick Reference

**Your Email:**
- info@heybuddydesign.com

**SMTP Settings (Gmail):**
- Host: smtp.gmail.com
- Port: 587
- User: info@heybuddydesign.com
- Password: [App Password - 16 characters]

**Webhook Path:**
- contact-form

**Expected Webhook URL:**
- https://your-n8n-instance.com/webhook/contact-form

---

**Let me know which setup you want (basic or advanced) and any issues you're seeing! 🚀**
