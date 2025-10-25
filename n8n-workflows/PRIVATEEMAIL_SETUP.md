# n8n Setup with PrivateEmail for HeyBuddyDesign

Your exact configuration for info@heybuddydesign.com using PrivateEmail.

---

## 📧 Your Email Settings

**Email:** info@heybuddydesign.com
**Provider:** PrivateEmail (mail.privateemail.com)

---

## 🚀 Step 1: Create SMTP Credential in n8n

1. In n8n, click **"Credentials"** in the left sidebar
2. Click **"Add Credential"**
3. Search for **"SMTP"**
4. Select **"SMTP"**
5. Fill in **EXACTLY** as follows:

### PrivateEmail SMTP Configuration:

```
Credential Name: HeyBuddy PrivateEmail

Host: mail.privateemail.com
Port: 465
Security: SSL/TLS
User: info@heybuddydesign.com
Password: [Your PrivateEmail account password]
```

**Important Settings:**
- ✅ Enable "SSL/TLS"
- ✅ Port must be **465** (not 587)
- ✅ Username is your full email: info@heybuddydesign.com

6. Click **"Test"** to verify connection
7. If test succeeds, click **"Save"**

---

## ⚠️ Common Issues with PrivateEmail

### If "Test" Fails:

**Error: "Connection timeout"**
- Make sure port is **465**
- Make sure SSL/TLS is enabled
- Check password is correct (no extra spaces)

**Error: "Authentication failed"**
- Verify password is correct
- Username must be: info@heybuddydesign.com (not just "info")
- Try logging into webmail to confirm password works

**Error: "Connection refused"**
- Port 465 might be blocked by firewall
- Try port **587** with STARTTLS instead

---

## 🔧 Alternative Configuration (If Port 465 Doesn't Work)

Some servers prefer port 587:

```
Host: mail.privateemail.com
Port: 587
Security: STARTTLS
User: info@heybuddydesign.com
Password: [Your password]
```

---

## ✅ Step 2: Create Your First Workflow

Now that email credential is set up, let's create a simple workflow:

### Create New Workflow:

1. Click **"Workflows"** → **"Add Workflow"**
2. Name it: **"HeyBuddy Contact Form"**
3. Click **"Save"**

### Add Node 1: Webhook (Trigger)

1. Click the **"+"** button
2. Search for **"Webhook"**
3. Select **"Webhook"**
4. Configure:
   - **HTTP Method:** POST
   - **Path:** contact-form
   - **Respond:** Immediately
   - Leave other settings as default

5. Click **"Execute Node"**
6. You'll see the webhook URL appear - **COPY THIS!**

**Your webhook URL will look like:**
```
https://your-n8n-instance.com/webhook/contact-form
```

**Save this URL - we'll use it in your website!**

---

### Add Node 2: Function (Process Data)

1. Click the **"+"** after the Webhook node
2. Search for **"Code"** or **"Function"**
3. Select **"Code"**
4. Paste this JavaScript code:

```javascript
// Extract and clean form data
const body = $input.item.json.body || $input.item.json;

return {
  json: {
    name: body.name || 'No name provided',
    email: body.email || 'No email provided',
    phone: body.phone || 'No phone provided',
    service: body.service || 'Not specified',
    budget: body.budget || 'Not specified',
    timeline: body.timeline || 'Not specified',
    message: body.message || 'No message',
    submittedAt: new Date().toLocaleString('en-GB', { timeZone: 'Europe/London' }),
    country: 'UK'
  }
};
```

5. Click **"Execute Node"** to test (it should process dummy data)

---

### Add Node 3: Email to You (Team Notification)

1. Click the **"+"** after the Function node
2. Search for **"Send Email"**
3. Select **"Send Email"**
4. Configure:

**Email Settings:**
```
Credential to connect with: HeyBuddy PrivateEmail (select the one you created)
From Email: info@heybuddydesign.com
To Email: info@heybuddydesign.com
Subject: 🔔 New Website Inquiry - {{ $json.name }}
Email Type: HTML
```

**HTML Message (copy and paste this):**

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: #00ff88; padding: 20px; text-align: center; }
    .content { background: #f9f9f9; padding: 20px; border: 1px solid #ddd; }
    .field { margin: 15px 0; padding: 10px; background: white; border-left: 3px solid #00ff88; }
    .label { font-weight: bold; color: #667eea; }
    .priority { background: #fff3cd; padding: 10px; border-left: 3px solid #ffc107; margin: 20px 0; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2 style="margin: 0; color: #1a1a1a;">🎉 New Lead from Website!</h2>
    </div>

    <div class="content">
      <h3>Contact Information</h3>

      <div class="field">
        <span class="label">Name:</span> {{ $json.name }}
      </div>

      <div class="field">
        <span class="label">Email:</span> <a href="mailto:{{ $json.email }}">{{ $json.email }}</a>
      </div>

      <div class="field">
        <span class="label">Phone:</span> <a href="tel:{{ $json.phone }}">{{ $json.phone }}</a>
      </div>

      <h3>Project Details</h3>

      <div class="field">
        <span class="label">Service:</span> {{ $json.service }}
      </div>

      <div class="field">
        <span class="label">Budget:</span> {{ $json.budget }}
      </div>

      <div class="field">
        <span class="label">Timeline:</span> {{ $json.timeline }}
      </div>

      <h3>Message</h3>

      <div class="field">
        {{ $json.message }}
      </div>

      <div class="priority">
        <strong>⏰ Action Required:</strong><br>
        Respond within 24 hours for best conversion rate!
      </div>

      <p style="font-size: 12px; color: #666; margin-top: 20px;">
        <strong>Submitted:</strong> {{ $json.submittedAt }}<br>
        <strong>Country:</strong> {{ $json.country }}
      </p>
    </div>
  </div>
</body>
</html>
```

---

### Add Node 4: Email to Customer (Confirmation)

1. Click the **"+"** after the first email node
2. Add another **"Send Email"** node
3. Configure:

**Email Settings:**
```
Credential to connect with: HeyBuddy PrivateEmail
From Email: info@heybuddydesign.com
To Email: {{ $json.email }}
Subject: Thanks for contacting HeyBuddy Design! 🚀
Email Type: HTML
```

**HTML Message (copy and paste this):**

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
    .content { background: #f9f9f9; padding: 30px; border: 1px solid #ddd; }
    .highlight { background: #d4edda; padding: 15px; border-radius: 5px; border-left: 4px solid #28a745; margin: 20px 0; }
    .button { display: inline-block; background: #00ff88; color: #1a1a1a; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
    .summary { background: white; padding: 15px; border-left: 3px solid #667eea; margin: 20px 0; }
    .footer { text-align: center; padding: 20px; font-size: 12px; color: #666; background: #f9f9f9; border-radius: 0 0 8px 8px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 style="margin: 0;">Thanks for Your Enquiry!</h1>
      <p style="margin: 10px 0; font-size: 18px;">We'll get back to you within 24 hours</p>
    </div>

    <div class="content">
      <p>Hi {{ $json.name }},</p>

      <p>Thanks for getting in touch with <strong>HeyBuddy Design</strong>! 🎉</p>

      <p>We've received your enquiry and our team will review it shortly. We typically respond within 24 hours on working days.</p>

      <div class="summary">
        <h3 style="margin-top: 0;">Your Enquiry Summary:</h3>
        <p style="margin: 5px 0;"><strong>Service:</strong> {{ $json.service }}</p>
        <p style="margin: 5px 0;"><strong>Budget:</strong> {{ $json.budget }}</p>
        <p style="margin: 5px 0;"><strong>Timeline:</strong> {{ $json.timeline }}</p>
      </div>

      <div class="highlight">
        <strong>💷 Special Offer:</strong><br>
        New clients get <strong>10% OFF</strong> their first project! Plus, flexible payment plans available on all packages over £600.
      </div>

      <p><strong>What happens next?</strong></p>
      <ol style="line-height: 1.8;">
        <li>We'll review your requirements</li>
        <li>Prepare a detailed quote</li>
        <li>Schedule a free consultation call</li>
        <li>Discuss your project in detail</li>
      </ol>

      <div style="text-align: center;">
        <a href="https://heybuddydesign.com/#pricing" class="button">View Our Pricing</a>
      </div>

      <p><strong>In the meantime:</strong></p>
      <ul style="line-height: 1.8;">
        <li>Check out our <a href="https://heybuddydesign.com/#services">services</a></li>
        <li>View our <a href="https://heybuddydesign.com/#pricing">pricing packages</a></li>
        <li>Read about our <a href="https://heybuddydesign.com/#features">payment plans</a></li>
      </ul>

      <p>Have a question? Just reply to this email!</p>

      <p>Looking forward to working with you! 🚀</p>

      <p>Best regards,<br>
      <strong>The HeyBuddy Design Team</strong></p>
    </div>

    <div class="footer">
      <p><strong>HeyBuddy Design</strong></p>
      <p>Professional Web Design from £150 | Payment Plans Available</p>
      <p>📧 info@heybuddydesign.com | 🌐 https://heybuddydesign.com</p>
      <p style="margin-top: 15px;">🇬🇧 UK-Based Company | No interest • No credit checks</p>
    </div>
  </div>
</body>
</html>
```

---

## 💾 Step 3: Save and Activate

1. Click **"Save"** (top right corner)
2. Toggle the **"Active"** switch (should turn green)
3. Your workflow is now live! ✅

---

## 🧪 Step 4: Test Your Workflow

### Quick Test with Browser Console:

1. Open any website
2. Press F12 to open developer console
3. Paste this code (replace YOUR_WEBHOOK_URL with your actual URL):

```javascript
fetch('YOUR_WEBHOOK_URL_HERE', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    name: 'Test User',
    email: 'your-personal-email@gmail.com',
    phone: '07123 456789',
    service: 'Business Website (£300-£600)',
    budget: '£500-£1,000',
    timeline: 'Within 1 month',
    message: 'This is a test submission from n8n. If you receive this, everything is working perfectly!'
  })
})
.then(response => response.json())
.then(data => console.log('✅ Success:', data))
.catch(error => console.error('❌ Error:', error));
```

4. Press Enter
5. Check both email inboxes:
   - ✅ info@heybuddydesign.com (team notification)
   - ✅ your-personal-email@gmail.com (confirmation)

---

## ✅ If Test Works - Next Steps

**Congratulations! Your n8n is working!** 🎉

Now send me your webhook URL and I'll:
1. Integrate it into your website contact form
2. Deploy the updated website to production
3. Run final tests to ensure everything works

**Your webhook URL format:**
```
https://your-n8n-instance.com/webhook/contact-form
```

---

## ❌ Troubleshooting PrivateEmail Issues

### Email Test Fails:

**Error: "Authentication failed"**
- Double-check password (copy-paste to avoid typos)
- Make sure username is full email: info@heybuddydesign.com
- Try logging into webmail to confirm password

**Error: "Connection timeout"**
- Port 465 with SSL/TLS should work
- If not, try port 587 with STARTTLS
- Check if firewall is blocking SMTP

**Error: "Could not send email"**
- Verify the credential is selected in the email node
- Make sure "From Email" is info@heybuddydesign.com
- Check PrivateEmail sending limits (usually 300/hour)

### Workflow Issues:

**Webhook returns 404:**
- Make sure workflow is **activated** (green toggle)
- Use the **Production URL**, not Test URL
- Workflow must be saved before activation

**Emails not arriving:**
- Check spam folders
- Verify both email nodes have credential selected
- Check n8n execution logs for errors

**Data not populating in email:**
- Make sure Function node is connected
- Check that `{{ $json.name }}` expressions are correct
- Test the workflow with the "Execute Workflow" button

---

## 📊 Your Complete Configuration

**Email Provider:** PrivateEmail
**SMTP Server:** mail.privateemail.com
**SMTP Port:** 465
**Security:** SSL/TLS
**Username:** info@heybuddydesign.com

**Workflow:**
- Node 1: Webhook (contact-form)
- Node 2: Function (data processing)
- Node 3: Email to team (info@heybuddydesign.com)
- Node 4: Email to customer (confirmation)

**Status:** Ready to connect to website! ✅

---

## 🎯 What You'll Get:

✅ Instant email notifications when someone submits the form
✅ Beautiful HTML emails (not plain text)
✅ Automatic customer confirmation emails
✅ All lead data captured and formatted
✅ UK timezone timestamps
✅ Works 24/7 automatically

---

## 🚀 Ready to Connect?

Once you've:
1. ✅ Created the PrivateEmail SMTP credential
2. ✅ Built the 4-node workflow
3. ✅ Tested it successfully
4. ✅ Activated the workflow

**Send me your webhook URL and I'll integrate it into your website!**

The URL format is:
```
https://your-n8n-instance.com/webhook/contact-form
```

Let me know if you get stuck on any step! 🤝
