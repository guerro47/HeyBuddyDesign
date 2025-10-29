# SMTP Email Credentials Setup for n8n

## 🎯 Quick Start Guide

Follow these steps to set up email sending in your n8n workflow.

---

## Step 1: Choose Your Email Provider

**Which email do you use for info@heybuddydesign.com?**

- [ ] Gmail
- [ ] PrivateEmail
- [ ] Outlook/Office365
- [ ] Custom hosting (cPanel, Plesk, etc.)
- [ ] Other

---

## Option A: Gmail Setup (Most Common)

### Prerequisites:
- Gmail account with 2-Factor Authentication enabled
- Need to generate an "App Password"

### Step-by-Step:

#### 1. Generate Gmail App Password

1. **Go to Google Account Security:**
   - Visit: https://myaccount.google.com/security

2. **Enable 2-Step Verification** (if not already enabled)
   - Click "2-Step Verification"
   - Follow the setup process

3. **Create App Password:**
   - Visit: https://myaccount.google.com/apppasswords
   - OR: Search for "App passwords" in Google Account settings
   - Select app: "Mail"
   - Select device: "Other (Custom name)"
   - Enter name: "n8n HeyBuddy"
   - Click "Generate"
   - **COPY THE 16-CHARACTER PASSWORD** (you won't see it again!)
   - Example: `abcd efgh ijkl mnop`

#### 2. Add SMTP Credential in n8n

1. **Go to n8n:** https://n8n-9zlt.onrender.com

2. **Navigate to Credentials:**
   - Click "Credentials" in the left sidebar

3. **Create New Credential:**
   - Click "+ Add Credential" button
   - Search for "SMTP"
   - Click "SMTP" from the list

4. **Fill in the Details:**

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [paste your 16-character app password]
Host: smtp.gmail.com
Port: 587
Secure Connection: None (Use TLS)
```

**IMPORTANT:**
- Remove any spaces from the app password
- Example: `abcdefghijklmnop` (no spaces)

5. **Click "Save"**

6. **Test the Connection:**
   - Click "Test" button
   - Should show "Connection test successful"

---

## Option B: PrivateEmail Setup

### Step-by-Step:

#### 1. Get SMTP Settings from PrivateEmail

PrivateEmail uses these settings:

```
Host: smtp.privateemail.com
Port: 587
OR
Host: mail.privateemail.com
Port: 587
```

#### 2. Add SMTP Credential in n8n

1. **Go to n8n:** https://n8n-9zlt.onrender.com

2. **Credentials → "+ Add Credential" → "SMTP"**

3. **Fill in:**

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [your PrivateEmail password]
Host: smtp.privateemail.com
Port: 587
Secure Connection: None (Use TLS)
```

**Alternative if above doesn't work:**
```
Host: mail.privateemail.com
Port: 465
Secure Connection: SSL/TLS
```

4. **Save and Test**

---

## Option C: Outlook/Office365

```
Credential Name: HeyBuddy Email
User: info@heybuddydesign.com
Password: [your email password]
Host: smtp.office365.com
Port: 587
Secure Connection: None (Use TLS)
```

---

## Option D: Custom Hosting (cPanel/Plesk)

### Find Your SMTP Settings:

1. **Login to cPanel/Plesk**
2. **Look for "Email Accounts" or "Mail Settings"**
3. **Find "Mail Server Configuration"**

**Common settings:**
```
Host: mail.yourdomain.com
OR
Host: smtp.yourdomain.com
Port: 587 (TLS) or 465 (SSL)
User: info@heybuddydesign.com
Password: [your email password]
```

---

## Step 2: Add Credential in n8n

### Visual Guide:

1. **Open n8n Dashboard**
   ```
   https://n8n-9zlt.onrender.com
   ```

2. **Click "Credentials" (left sidebar)**

3. **Click "+ Add Credential"**

4. **Search for "SMTP"**

5. **Fill in the form:**
   - Credential Name: `HeyBuddy Email`
   - User: Your email address
   - Password: Your email password (or app password)
   - Host: SMTP server address
   - Port: Usually 587 or 465
   - Secure: Use TLS (for 587) or SSL/TLS (for 465)

6. **Click "Save"**

7. **Click "Test"** to verify connection

---

## Step 3: Use Credential in Workflow

### After creating the credential:

1. **Open your workflow** in n8n

2. **For each "Send Email" node:**
   - Click on the node
   - Under "Credentials"
   - Click the dropdown
   - Select "HeyBuddy Email"

3. **Save the workflow**

---

## 🧪 Test Your SMTP Setup

### Quick Test Email:

1. **In n8n, create a simple test workflow:**
   - Add a "Manual Trigger" node
   - Add a "Send Email" node
   - Configure:
     ```
     From: info@heybuddydesign.com
     To: info@heybuddydesign.com
     Subject: Test Email from n8n
     Message: This is a test email to verify SMTP setup.
     ```
   - Select your "HeyBuddy Email" credential
   - Click "Execute Node"

2. **Check your inbox** for the test email

---

## 🐛 Troubleshooting

### Problem: "Authentication failed"

**Solutions:**
1. **Gmail:** Make sure you're using App Password, not your regular password
2. **Check username:** Must be full email address (info@heybuddydesign.com)
3. **Check password:** No spaces, copy directly from source
4. **Enable "Less secure apps"** (if using Gmail without 2FA - not recommended)

### Problem: "Connection timeout"

**Solutions:**
1. **Try different port:**
   - Port 587 with TLS
   - Port 465 with SSL/TLS
   - Port 25 (usually blocked)
2. **Try different host:**
   - smtp.gmail.com
   - mail.privateemail.com vs smtp.privateemail.com
3. **Check firewall:** Render might block certain ports
4. **Contact Render support** if issue persists

### Problem: "Connection refused"

**Solutions:**
1. **Verify SMTP host** is correct
2. **Check port** matches security setting
3. **Verify email account** is active
4. **Check account limits** (daily sending limits)

### Problem: "Emails not arriving"

**Solutions:**
1. **Check spam/junk folder**
2. **Verify "From" email** is correct
3. **Check email provider limits**
4. **Use authenticated email** (don't use different From address)
5. **Wait 5-10 minutes** (sometimes delayed)

---

## 📋 Quick Reference Table

| Provider | Host | Port | Security | Notes |
|----------|------|------|----------|-------|
| Gmail | smtp.gmail.com | 587 | TLS | Requires app password |
| Gmail | smtp.gmail.com | 465 | SSL/TLS | Alternative |
| PrivateEmail | smtp.privateemail.com | 587 | TLS | Primary |
| PrivateEmail | mail.privateemail.com | 465 | SSL/TLS | Alternative |
| Outlook | smtp.office365.com | 587 | TLS | Regular password |
| Yahoo | smtp.mail.yahoo.com | 587 | TLS | Requires app password |

---

## ✅ Checklist

After setup, verify:

- [ ] SMTP credential created in n8n
- [ ] Connection test successful
- [ ] Credential selected in email nodes
- [ ] Test email sent and received
- [ ] Workflow activated
- [ ] Form submission triggers emails

---

## 🚨 Important Notes

### Gmail App Password:
- **Must have 2FA enabled** on Google account
- App password is **different** from your regular Gmail password
- App password is **16 characters**, usually shown with spaces
- **Remove spaces** when entering in n8n

### Security:
- ✅ Use TLS/SSL (encrypted connection)
- ✅ Use strong passwords
- ✅ Don't share credentials
- ⚠️ App passwords give full access - keep secure

### Limits:
- **Gmail:** 500 emails/day (free), 2000/day (Workspace)
- **PrivateEmail:** Varies by plan
- **Outlook:** 300 emails/day (free)

---

## 🆘 Need Help?

If you're stuck:

1. **Check the n8n logs:**
   - In workflow, click "Executions"
   - Click on failed execution
   - Read error message

2. **Try a different email provider:**
   - Gmail is usually most reliable
   - Create a test Gmail account if needed

3. **Contact your email provider:**
   - Ask for SMTP settings
   - Confirm SMTP is enabled

4. **Test with online SMTP tester:**
   - https://www.smtper.net/
   - Verify your credentials work outside n8n

---

## 📞 Support Resources

- **n8n Community:** https://community.n8n.io/
- **Gmail Help:** https://support.google.com/mail/answer/7126229
- **Render Support:** https://render.com/docs

---

## Next Steps

After SMTP is working:

1. ✅ Import complete workflow
2. ✅ Update email nodes with credential
3. ✅ Test form submission
4. ✅ Check both team and customer emails arrive
5. ✅ Deploy website to production

Good luck! 🚀
