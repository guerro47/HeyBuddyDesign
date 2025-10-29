# Complete n8n Workflow Setup with Email Confirmations

## 📋 Overview

This guide will help you build the complete workflow step-by-step in your Render n8n instance.

**Workflow Flow:**
```
1. Webhook (Receives form data)
   ↓
2. Code - Validate & Clean Data
   ↓
3. IF - Check Valid Data
   ↓ (True)
4. Code - Calculate Lead Score
   ↓
5. Send Email - Team Notification
   ↓
6. Send Email - Customer Confirmation
   ↓
7. Respond to Webhook - Success Message
```

---

## 🔐 Step 1: Set Up SMTP Email Credentials

Before building the workflow, you need email credentials.

### Go to n8n: https://n8n-9zlt.onrender.com

1. Click **"Credentials"** (left sidebar)
2. Click **"Add Credential"**
3. Search for **"SMTP"**
4. Fill in your email details:

### Option A: Gmail (Most Common)

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [Your Gmail App Password]
Host: smtp.gmail.com
Port: 587
SSL/TLS: Use TLS
```

**Important for Gmail:**
- You need to create an "App Password"
- Go to: https://myaccount.google.com/apppasswords
- Generate a new app password
- Use that password (not your regular Gmail password)

### Option B: PrivateEmail / Custom SMTP

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [Your email password]
Host: smtp.privateemail.com (or mail.privateemail.com)
Port: 587
SSL/TLS: Use TLS
```

### Option C: Other Providers

**Outlook/Office365:**
- Host: smtp.office365.com
- Port: 587

**Yahoo:**
- Host: smtp.mail.yahoo.com
- Port: 587

5. Click **"Save"**

---

## 🔨 Step 2: Build the Workflow

### Node 1: Webhook (Already Created)

Your webhook should already exist with path: `0f6bd949-4e9a-4f4c-b9b1-b3cff418804d`

---

### Node 2: Code - Validate & Clean Data

1. Click **+** after Webhook
2. Search for **"Code"**
3. Name: `Validate & Clean Data`
4. Paste this code:

```javascript
// Extract form data from webhook
const formData = $input.item.json.body || $input.item.json;

// Validate email
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const isValidEmail = formData.email ? emailRegex.test(formData.email) : false;

// Validate phone (UK format)
const phoneRegex = /^(\+44\s?7\d{3}|\(?07\d{3}\)?)\s?\d{3}\s?\d{3}$|^[\d\s\-\+\(\)]+$/;
const isValidPhone = formData.phone ? phoneRegex.test(formData.phone) : true;

// Clean and structure data
return {
  name: formData.name?.trim() || 'Not provided',
  email: formData.email?.toLowerCase().trim() || '',
  phone: formData.phone?.trim() || 'Not provided',
  company: formData.company?.trim() || 'Not provided',
  message: formData.message?.trim() || '',
  service: formData.service || 'Not specified',
  budget: formData.budget || 'Not specified',
  timeline: formData.timeline || 'Not specified',
  source: formData.source || 'Website Contact Form',
  isValidEmail: isValidEmail,
  isValidPhone: isValidPhone,
  submittedAt: new Date().toISOString(),
  submittedDate: new Date().toLocaleDateString('en-GB'),
  submittedTime: new Date().toLocaleTimeString('en-GB'),
  leadScore: 0,
  country: 'UK'
};
```

5. Click **"Test step"** to verify
6. Save

---

### Node 3: IF - Check Valid Data

1. Click **+** after Validate node
2. Search for **"IF"**
3. Name: `IF Valid Data`
4. Click **"Add Condition"** → **"Boolean"**
5. Configure:
   - Value 1: `{{ $json.isValidEmail }}`
   - Operation: `equals`
   - Value 2: `true`
6. Click **"Add Condition"** → **"Boolean"**
7. Configure:
   - Value 1: `{{ $json.isValidPhone }}`
   - Operation: `equals`
   - Value 2: `true`
8. Set mode to: **"ALL conditions must match"**
9. Save

---

### Node 4: Code - Calculate Lead Score

1. Click **+** on the **TRUE** branch of IF node
2. Search for **"Code"**
3. Name: `Calculate Lead Score (UK)`
4. Paste this code:

```javascript
// Calculate lead score - UK Pricing
const data = $input.item.json;
let score = 0;

// Budget scoring - UK Prices
if (data.budget) {
  const budget = data.budget.toLowerCase();

  if (budget.includes('5000') || budget.includes('5,000') || budget.includes('£5k+') || budget.includes('5k+')) {
    score += 30;
  } else if (budget.includes('2000-5000') || budget.includes('2,000-5,000') || budget.includes('2k-5k')) {
    score += 25;
  } else if (budget.includes('1000-2000') || budget.includes('1,000-2,000') || budget.includes('1k-2k')) {
    score += 20;
  } else if (budget.includes('500-1000') || budget.includes('500-1,000') || budget.includes('500')) {
    score += 15;
  } else if (budget.includes('200-500') || budget.includes('200')) {
    score += 10;
  } else if (budget.includes('under 200') || budget.includes('<200') || budget.includes('150')) {
    score += 5;
  }
}

// Timeline scoring (urgency)
if (data.timeline) {
  const timeline = data.timeline.toLowerCase();
  if (timeline.includes('asap') || timeline.includes('urgent') || timeline.includes('immediately')) {
    score += 25;
  } else if (timeline.includes('1 month') || timeline.includes('30 days')) {
    score += 20;
  } else if (timeline.includes('1-2 months')) {
    score += 18;
  } else if (timeline.includes('2-3 months')) {
    score += 15;
  } else if (timeline.includes('3-6 months')) {
    score += 10;
  } else if (timeline.includes('flexible') || timeline.includes('no rush')) {
    score += 5;
  }
}

// Service type scoring
if (data.service) {
  const service = data.service.toLowerCase();
  if (service.includes('ai') || service.includes('chatbot') || service.includes('automation')) {
    score += 20;
  } else if (service.includes('premium') || service.includes('professional') || service.includes('e-commerce')) {
    score += 15;
  } else if (service.includes('business') || service.includes('web design')) {
    score += 10;
  } else if (service.includes('starter') || service.includes('basic')) {
    score += 5;
  }
}

// Company field present (serious inquiry)
if (data.company && data.company !== 'Not provided' && data.company.length > 0) {
  score += 10;
}

// Message length (detailed inquiry shows serious interest)
if (data.message && data.message.length > 150) {
  score += 10;
} else if (data.message && data.message.length > 75) {
  score += 5;
}

// Phone provided (easier to close)
if (data.phone && data.phone !== 'Not provided' && data.phone.length > 0) {
  score += 5;
}

// Determine priority based on UK pricing
let priority = 'Low';
let category = 'Cold Lead';
let recommendedAction = 'Send brochure and add to nurture sequence';
let urgency = '⚪';

if (score >= 70) {
  priority = 'High';
  category = 'Hot Lead - £1,000+';
  recommendedAction = 'URGENT: Call within 2 hours + Send calendar link';
  urgency = '🔴';
} else if (score >= 50) {
  priority = 'Medium-High';
  category = 'Warm Lead - £500-£1,000';
  recommendedAction = 'Call within 24 hours + Send portfolio';
  urgency = '🟠';
} else if (score >= 30) {
  priority = 'Medium';
  category = 'Warm Lead - £200-£500';
  recommendedAction = 'Send email with pricing + Book call';
  urgency = '🟡';
} else {
  priority = 'Low';
  category = 'Cold Lead - Under £200';
  recommendedAction = 'Add to email nurture sequence';
  urgency = '⚪';
}

return {
  ...data,
  leadScore: score,
  priority: priority,
  category: category,
  recommendedAction: recommendedAction,
  urgency: urgency
};
```

5. Save

---

### Node 5: Send Email - Team Notification

1. Click **+** after Lead Score node
2. Search for **"Send Email"**
3. Name: `Email - Team Notification`
4. Configure:

**Credentials:**
- Select: `HeyBuddy Email` (the one you created)

**From Email:**
```
info@heybuddydesign.com
```

**To Email:**
```
info@heybuddydesign.com
```

**Subject:**
```
{{ $json.urgency }} New Lead: {{ $json.name }} - {{ $json.category }}
```

**Email Type:** HTML

**Message (HTML):**
```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
    .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
    .lead-info { background: white; padding: 20px; margin: 20px 0; border-left: 4px solid #667eea; }
    .priority-high { border-left-color: #e53e3e; background: #fff5f5; }
    .priority-medium { border-left-color: #ed8936; background: #fffaf0; }
    .priority-low { border-left-color: #48bb78; background: #f0fff4; }
    .score { font-size: 48px; font-weight: bold; color: #667eea; text-align: center; margin: 20px 0; }
    .field { margin: 10px 0; }
    .label { font-weight: bold; color: #667eea; }
    .action { background: #667eea; color: white; padding: 15px; border-radius: 5px; margin: 20px 0; text-align: center; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 30px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>{{ $json.urgency }} New Lead Received!</h1>
      <p>{{ $json.category }}</p>
    </div>

    <div class="content">
      <div class="score">
        Score: {{ $json.leadScore }}/100
      </div>

      <div class="lead-info priority-{{ $json.priority.toLowerCase().replace(' ', '-') }}">
        <h2>Contact Information</h2>
        <div class="field"><span class="label">Name:</span> {{ $json.name }}</div>
        <div class="field"><span class="label">Email:</span> <a href="mailto:{{ $json.email }}">{{ $json.email }}</a></div>
        <div class="field"><span class="label">Phone:</span> <a href="tel:{{ $json.phone }}">{{ $json.phone }}</a></div>
        <div class="field"><span class="label">Company:</span> {{ $json.company }}</div>
      </div>

      <div class="lead-info">
        <h2>Project Details</h2>
        <div class="field"><span class="label">Service:</span> {{ $json.service }}</div>
        <div class="field"><span class="label">Budget:</span> {{ $json.budget }}</div>
        <div class="field"><span class="label">Timeline:</span> {{ $json.timeline }}</div>
        <div class="field"><span class="label">Message:</span><br>{{ $json.message }}</div>
      </div>

      <div class="action">
        <h3>⚡ Recommended Action</h3>
        <p>{{ $json.recommendedAction }}</p>
      </div>

      <div class="lead-info">
        <div class="field"><span class="label">Priority:</span> {{ $json.priority }}</div>
        <div class="field"><span class="label">Source:</span> {{ $json.source }}</div>
        <div class="field"><span class="label">Submitted:</span> {{ $json.submittedDate }} at {{ $json.submittedTime }}</div>
      </div>

      <div class="footer">
        <p>HeyBuddy Design - Automated Lead Notification</p>
        <p>View all leads: <a href="https://n8n-9zlt.onrender.com/executions">n8n Dashboard</a></p>
      </div>
    </div>
  </div>
</body>
</html>
```

5. Save

---

### Node 6: Send Email - Customer Confirmation

1. Click **+** after Team Email node
2. Search for **"Send Email"**
3. Name: `Email - Customer Confirmation`
4. Configure:

**Credentials:**
- Select: `HeyBuddy Email`

**From Email:**
```
info@heybuddydesign.com
```

**To Email:**
```
{{ $json.email }}
```

**Subject:**
```
Thanks for contacting HeyBuddy Design, {{ $json.name }}! 🎉
```

**Email Type:** HTML

**Message (HTML):**
```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 20px; text-align: center; }
    .logo { font-size: 32px; font-weight: bold; margin-bottom: 10px; }
    .content { padding: 40px 20px; background: #f9f9f9; }
    .card { background: white; padding: 30px; border-radius: 10px; margin: 20px 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    h2 { color: #667eea; margin-top: 0; }
    .highlight { background: #f0f4ff; padding: 20px; border-left: 4px solid #667eea; margin: 20px 0; }
    .cta { text-align: center; margin: 30px 0; }
    .button { display: inline-block; background: #667eea; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; }
    .footer { text-align: center; padding: 30px; color: #666; font-size: 14px; background: #333; color: white; }
    .footer a { color: #667eea; text-decoration: none; }
    .checklist { margin: 20px 0; }
    .checklist li { margin: 10px 0; }
    .pricing-note { background: #fff9e6; border: 2px solid #ffd700; padding: 15px; border-radius: 5px; text-align: center; font-weight: bold; color: #d97706; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <div class="logo">HeyBuddy Design</div>
      <p style="font-size: 18px; margin: 0;">Your Digital Buddy in the Cloud</p>
    </div>

    <div class="content">
      <div class="card">
        <h2>Hi {{ $json.name }}! 👋</h2>
        <p>Thank you for reaching out to HeyBuddy Design! We're excited to learn about your project.</p>

        <p>We've received your enquiry and one of our team members will get back to you soon.</p>

        <div class="highlight">
          <strong>Your enquiry details:</strong><br>
          <strong>Service:</strong> {{ $json.service }}<br>
          <strong>Budget:</strong> {{ $json.budget }}<br>
          <strong>Timeline:</strong> {{ $json.timeline }}
        </div>
      </div>

      <div class="card">
        <h2>What Happens Next?</h2>
        <div class="checklist">
          <ul>
            <li>✅ <strong>We review your requirements</strong> - Our team will carefully review your project needs</li>
            <li>📞 <strong>We'll contact you within 24 hours</strong> - Usually much sooner for urgent projects!</li>
            <li>💡 <strong>Free consultation</strong> - We'll discuss your vision and provide expert advice</li>
            <li>📋 <strong>Custom proposal</strong> - You'll receive a tailored quote for your project</li>
          </ul>
        </div>
      </div>

      <div class="card">
        <h2>Why Choose HeyBuddy Design?</h2>
        <ul>
          <li>💰 <strong>Affordable UK Pricing</strong> - From £150 to £5,000+</li>
          <li>📅 <strong>Flexible Payment Plans</strong> - 4-6 months interest-free options available</li>
          <li>🎨 <strong>Modern, Professional Design</strong> - Beautiful websites that convert</li>
          <li>🤖 <strong>AI & Automation</strong> - Cutting-edge technology for your business</li>
          <li>🇬🇧 <strong>UK-Based Support</strong> - Local, friendly, and reliable</li>
        </ul>

        <div class="pricing-note">
          🎁 Special Offer: 10% discount for new clients!
        </div>
      </div>

      <div class="cta">
        <p>In the meantime, check out our portfolio:</p>
        <a href="https://heybuddydesign.com" class="button">Visit Our Website</a>
      </div>

      <div class="card">
        <h2>Questions?</h2>
        <p>Feel free to reply to this email or call us anytime.</p>
        <p>
          📧 Email: <a href="mailto:info@heybuddydesign.com">info@heybuddydesign.com</a><br>
          🌐 Web: <a href="https://heybuddydesign.com">heybuddydesign.com</a>
        </p>
      </div>
    </div>

    <div class="footer">
      <p><strong>HeyBuddy Design</strong></p>
      <p>Your Digital Buddy in the Cloud ☁️</p>
      <p style="font-size: 12px; margin-top: 20px;">
        You're receiving this email because you submitted a contact form at heybuddydesign.com
      </p>
    </div>
  </div>
</body>
</html>
```

5. Save

---

### Node 7: Respond to Webhook

1. Click **+** after Customer Email node
2. Search for **"Respond to Webhook"**
3. Name: `Respond - Success`
4. Configure:

**Respond With:** JSON

**Response Code:** 200

**Response Body:**
```json
{
  "success": true,
  "message": "Thank you! We've received your enquiry and will be in touch within 24 hours.",
  "leadScore": "={{ $json.leadScore }}",
  "priority": "={{ $json.priority }}"
}
```

5. Save

---

### Node 8: Handle Invalid Data (Optional)

Go back to the **FALSE** branch of the IF node:

1. Click **+** on the **FALSE** branch
2. Search for **"Respond to Webhook"**
3. Name: `Respond - Error`
4. Configure:

**Response Code:** 400

**Response Body:**
```json
{
  "success": false,
  "message": "Please provide a valid email address and check your details."
}
```

5. Save

---

## ✅ Final Steps

1. **Save the entire workflow**
2. **Make sure it's ACTIVATED** (green toggle)
3. **Test it!**

---

## 🧪 Testing

Test with curl:

```bash
curl -X POST https://n8n-9zlt.onrender.com/webhook/0f6bd949-4e9a-4f4c-b9b1-b3cff418804d \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "phone": "07123456789",
    "company": "Test Company Ltd",
    "service": "Professional Website (£600-£900)",
    "budget": "£1,000-£2,000",
    "timeline": "ASAP - Urgent",
    "message": "This is a comprehensive test of the complete workflow including validation, scoring, and email notifications."
  }'
```

You should receive:
- ✅ Team notification email at info@heybuddydesign.com
- ✅ Customer confirmation email at test@example.com
- ✅ Success response from webhook

---

## 📥 Backup Your Workflow

After building:

1. Click "..." menu → "Download"
2. Save to: `n8n-workflows/backups/complete-workflow-$(date +%Y%m%d).json`
3. Commit to git

---

## 🎯 Troubleshooting

**Emails not sending:**
- Verify SMTP credentials are correct
- Check spam/junk folders
- Test SMTP connection in credentials page

**Workflow not triggering:**
- Make sure it's activated (green toggle)
- Check webhook URL is correct
- View execution logs for errors

**Invalid data errors:**
- Check that form field names match exactly
- Verify JSON structure is correct

---

## 🚀 You're Done!

Your complete workflow is now set up with:
- ✅ Data validation
- ✅ Lead scoring (0-100 points)
- ✅ Team notifications
- ✅ Customer confirmations
- ✅ Professional email templates
- ✅ Error handling

Enjoy your automated lead capture system! 🎉
