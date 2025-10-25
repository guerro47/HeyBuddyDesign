# n8n Webhook Setup Guide for HeyBuddyDesign

Quick guide to connect your website contact form to n8n automation workflows.

---

## 📋 What You Need

1. **n8n Instance** (cloud or self-hosted)
2. **Your n8n Webhook URL** (we'll get this after setup)
3. **Email Configuration** (info@heybuddydesign.com)

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Import the Workflow

1. Go to your n8n instance
2. Click **"Workflows"** → **"Import from File"**
3. Select: `01-lead-capture-to-crm-uk.json`
4. Click **"Import"**

### Step 2: Get Your Webhook URL

1. Open the imported workflow
2. Click the **"Webhook - Contact Form"** node (first node)
3. Click **"Execute Node"** button
4. Copy the **Production URL** (looks like this):
   ```
   https://your-n8n-instance.com/webhook/contact-form
   ```

### Step 3: Update Website Contact Form

Replace the webhook URL in your website's `index.html` file.

**Find this section (around line 1520):**
```javascript
// Here you would typically send the data to your backend:
// fetch('/api/contact', {
```

**Replace with:**
```javascript
// Send to n8n webhook
try {
    const response = await fetch('YOUR_N8N_WEBHOOK_URL_HERE', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
    });

    const result = await response.json();

    if (response.ok && result.success) {
        // Show success message
        successMessage.classList.add('show');
        this.reset();
    } else {
        alert('Something went wrong. Please try again or email us at info@heybuddydesign.com');
    }
} catch (error) {
    console.error('Error:', error);
    alert('Something went wrong. Please email us at info@heybuddydesign.com');
}
```

### Step 4: Configure Email Settings

The workflow needs your email credentials to send notifications.

#### Option A: Using Gmail

1. Go to **Credentials** in n8n
2. Create **New Credential** → Select **"SMTP"**
3. Fill in:
   ```
   Name: HeyBuddy Email
   Host: smtp.gmail.com
   Port: 587
   User: info@heybuddydesign.com
   Password: [Your App Password]
   ```

**To get Gmail App Password:**
1. Go to Google Account → Security
2. Enable 2-Factor Authentication
3. Go to "App passwords"
4. Generate a new app password for "Mail"
5. Use this 16-character password in n8n

#### Option B: Using Other Email Providers

**Outlook/Office 365:**
```
Host: smtp.office365.com
Port: 587
User: info@heybuddydesign.com
Password: [Your password]
```

**Custom Domain Email (via cPanel/Plesk):**
```
Host: mail.yourdomain.com
Port: 587
User: info@heybuddydesign.com
Password: [Your email password]
```

### Step 5: Test the Integration

1. **Activate the workflow** (toggle in top-right corner)
2. Go to your website's contact form
3. Fill in test data:
   ```
   Name: Test User
   Email: your-personal-email@example.com
   Phone: 07XXX XXXXXX
   Service: Business Website (£300-£600)
   Budget: £500-£1,000
   Timeline: Within 1 month
   Message: This is a test message from my website contact form
   ```
4. Submit the form
5. Check your email inbox for:
   - ✅ Team notification at info@heybuddydesign.com
   - ✅ Confirmation email at your-personal-email@example.com

---

## 📧 Email Template Customization

### Update Email "From" Address

In the workflow, find these email nodes and update:

1. **"Email - Confirmation to Lead (UK)"** node
   - Set `fromEmail`: `info@heybuddydesign.com`

2. **"Email - Notify Team"** node
   - Set `fromEmail`: `info@heybuddydesign.com`
   - Set `toEmail`: `info@heybuddydesign.com`

### Customize Email Content

Edit the HTML email templates in the workflow:
- Add your logo URL
- Update company address
- Change phone number from "020 XXXX XXXX" to your real number
- Adjust colors to match your brand

---

## 🔗 Optional Integrations

### Add Slack Notifications (Hot Leads)

1. Create Slack credential in n8n
2. Get your Slack channel ID
3. Update the **"Slack - Hot Lead Alert"** node
4. Set channel ID: `C1234567890` (your channel)

### Add HubSpot CRM Integration

1. Create HubSpot credential in n8n
2. OAuth authorize your account
3. The **"HubSpot - Create/Update Contact"** node will auto-sync leads

---

## 🧪 Testing Checklist

After setup, test these scenarios:

- [ ] **Low Priority Lead** (Budget: Under £200, Timeline: Flexible)
  - Should receive: Team notification only
  - No Slack alert

- [ ] **Medium Priority Lead** (Budget: £500-£1,000, Timeline: 1-2 months)
  - Should receive: Team notification + Confirmation email
  - No Slack alert

- [ ] **High Priority Lead** (Budget: £2,000+, Timeline: ASAP)
  - Should receive: Slack alert + Team notification + Confirmation email
  - Lead score should be 70+

- [ ] **Form Validation**
  - Try invalid email → Should show error
  - Try missing required fields → Should prevent submission

---

## 🐛 Troubleshooting

### Webhook Not Working

**Problem:** Form submits but nothing happens

**Solutions:**
1. Check workflow is **activated** (green toggle)
2. Verify webhook URL is correct in `index.html`
3. Check browser console for errors (F12)
4. Test webhook directly:
   ```bash
   curl -X POST https://your-n8n-url/webhook/contact-form \
     -H "Content-Type: application/json" \
     -d '{
       "name": "Test",
       "email": "test@example.com",
       "budget": "£500-£1,000",
       "timeline": "Within 1 month",
       "service": "Business Website",
       "message": "Test message"
     }'
   ```

### Emails Not Sending

**Problem:** Workflow runs but emails don't arrive

**Solutions:**
1. Check spam folder
2. Verify SMTP credentials in n8n
3. Test SMTP connection (click "Test" in credentials)
4. Check email quota/limits
5. For Gmail: Enable "Less secure app access"

### Lead Score Always 0

**Problem:** All leads showing score of 0

**Solutions:**
1. Check budget field is being sent from form
2. Verify field names match exactly:
   - `budget` (not `Budget`)
   - `timeline` (not `Timeline`)
3. Check browser console for form data
4. Test the "Calculate Lead Score" function node manually

---

## 📊 Your n8n Webhook URL

Once you have your n8n instance set up, paste your webhook URL here for reference:

```
Your Production Webhook URL:
https://your-n8n-instance.com/webhook/contact-form

(Replace this in index.html around line 1520)
```

---

## 🔐 Security Best Practices

### Add Webhook Secret

Protect your webhook from spam:

1. In the webhook node, add a secret header
2. Update form to include secret:
   ```javascript
   fetch('YOUR_WEBHOOK_URL', {
       method: 'POST',
       headers: {
           'Content-Type': 'application/json',
           'X-Webhook-Secret': 'your-secret-key-here'
       },
       body: JSON.stringify(formData)
   });
   ```

3. In n8n workflow, validate the secret:
   ```javascript
   // In "Validate & Clean Data" node
   const secret = $input.item.json.headers['x-webhook-secret'];
   if (secret !== 'your-secret-key-here') {
       throw new Error('Unauthorized');
   }
   ```

### Rate Limiting

Prevent form spam:

```javascript
// Add to workflow "Validate & Clean Data" node
const submissions = $workflow.getStaticData('submissions') || {};
const email = $json.email;
const now = Date.now();

// Allow 1 submission per email every 5 minutes
if (submissions[email] && (now - submissions[email]) < 300000) {
    throw new Error('Please wait before submitting again');
}

submissions[email] = now;
$workflow.setStaticData('submissions', submissions);
```

---

## ✅ Deployment Checklist

Before going live:

- [ ] n8n workflow imported and activated
- [ ] Webhook URL copied to `index.html`
- [ ] Email credentials configured and tested
- [ ] All email addresses updated to `info@heybuddydesign.com`
- [ ] Test submission successful
- [ ] Confirmation email received
- [ ] Team notification received
- [ ] Lead appears in HubSpot (if using)
- [ ] High-priority lead triggers Slack (if using)
- [ ] Website deployed with updated webhook URL

---

## 📞 Need Help?

If you get stuck:

1. **Check n8n Execution Logs:**
   - Go to Executions tab
   - Click on failed execution
   - See which node failed and why

2. **n8n Community:**
   - Forum: https://community.n8n.io/
   - Discord: https://discord.gg/n8n

3. **Email Support:**
   - Your team: info@heybuddydesign.com
   - n8n docs: https://docs.n8n.io/

---

## 🎉 You're All Set!

Once configured, your workflow will:
- ✅ Automatically capture leads 24/7
- ✅ Score leads based on UK pricing tiers
- ✅ Send instant confirmation emails
- ✅ Notify your team of new inquiries
- ✅ Alert you to high-value leads immediately
- ✅ Sync to your CRM automatically

Happy automating! 🚀
