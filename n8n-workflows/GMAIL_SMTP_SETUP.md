# Gmail SMTP Setup for n8n - Complete Guide

## 🎯 Quick Setup for HeyBuddy Design

Gmail is the most reliable SMTP provider for n8n on cloud platforms.

---

## ⚠️ IMPORTANT: You Need a Gmail App Password

You **CANNOT** use your regular Gmail password. You must create an "App Password."

---

## Step 1: Enable 2-Step Verification (If Not Already Enabled)

### Check if 2-Step Verification is On:

1. **Go to:** https://myaccount.google.com/security

2. **Look for "2-Step Verification"**
   - If it says "Off" → Click it and turn it ON
   - If it says "On" → You're good! Skip to Step 2

### To Enable 2-Step Verification:

1. Click **"2-Step Verification"**
2. Click **"Get Started"**
3. Follow the prompts:
   - Enter your password
   - Add your phone number
   - Verify with code sent to your phone
   - Click "Turn On"

---

## Step 2: Generate Gmail App Password

### Create the App Password:

1. **Go directly to:** https://myaccount.google.com/apppasswords

   **OR**

   - Go to: https://myaccount.google.com/security
   - Scroll down to "How you sign in to Google"
   - Click "2-Step Verification"
   - Scroll to bottom
   - Click "App passwords"

2. **You might be asked to sign in again** - enter your Gmail password

3. **Create the app password:**
   - **Select app:** Choose "Mail" or "Other"
   - **Select device:** Choose "Other (Custom name)"
   - **Enter name:** Type "n8n HeyBuddy"
   - Click **"Generate"**

4. **IMPORTANT: Copy the 16-character password!**

   You'll see something like:
   ```
   abcd efgh ijkl mnop
   ```

   **Copy this immediately!** You won't be able to see it again.

5. **Remove the spaces:**
   ```
   abcdefghijklmnop
   ```
   Keep this ready for the next step.

---

## Step 3: Create SMTP Credential in n8n

### Go to Your n8n Instance:

**URL:** https://n8n-9zlt.onrender.com

### Add the Credential:

1. **Click "Credentials"** (left sidebar)

2. **Click "+ Add Credential"** (top right)

3. **Search for "SMTP"** and select it

4. **Fill in these EXACT values:**

```
Credential Name: HeyBuddy Email

Connection:
  Host: smtp.gmail.com
  Port: 587
  Secure Connection: None (Use TLS)

Authentication:
  User: info@heybuddydesign.com
  Password: [paste your 16-character app password - NO SPACES]
```

**Example:**
```
User: info@heybuddydesign.com
Password: abcdefghijklmnop
```

5. **Click "Save"**

6. **Click "Test"**

   You should see: ✅ **"Connection test successful"**

---

## ✅ Success! What You Should See:

### In n8n Credentials Page:
```
Name              Type    Status
HeyBuddy Email    SMTP    ✅ Tested successfully
```

---

## 🐛 Troubleshooting

### Error: "Invalid credentials"

**Solutions:**

1. **Check the app password:**
   - Must be 16 characters
   - No spaces
   - Copy it directly, don't type it
   - Generate a new one if unsure

2. **Verify email address:**
   - Must be: info@heybuddydesign.com
   - Must match the Gmail account that created the app password

3. **Make sure you're using APP PASSWORD, not regular Gmail password**

### Error: "2-Step Verification required"

**Solution:**
- Go back to Step 1
- Enable 2-Step Verification
- Then create app password

### Error: "Connection timeout"

**Solutions:**

1. **Try alternative port:**
   ```
   Port: 465
   Security: SSL/TLS
   ```

2. **Check Render isn't blocking port:**
   - Port 587 usually works on Render
   - Contact Render support if blocked

### Error: "App Passwords option not available"

**Reasons:**

1. **2-Step Verification not enabled:**
   - Enable it first (see Step 1)

2. **Using Google Workspace (work/school account):**
   - Admin might have disabled app passwords
   - Ask admin to enable
   - Or use a personal Gmail account

3. **Advanced Protection enabled:**
   - Can't use app passwords with Advanced Protection
   - Need to disable or use different account

---

## 📧 Gmail SMTP Settings Reference

| Setting | Value | Notes |
|---------|-------|-------|
| **Host** | smtp.gmail.com | Always this |
| **Port (Recommended)** | 587 | Use with TLS |
| **Port (Alternative)** | 465 | Use with SSL/TLS |
| **Security (587)** | None (Use TLS) | Recommended |
| **Security (465)** | SSL/TLS | Alternative |
| **Username** | info@heybuddydesign.com | Full Gmail address |
| **Password** | App Password | 16 chars, NO spaces |

---

## 🧪 Test Your Setup

### Quick Test (Before Using in Workflow):

1. **In n8n, create a new workflow**

2. **Add these nodes:**
   - "Manual Trigger" node
   - "Send Email" node

3. **Configure the Send Email node:**
   ```
   Credential: HeyBuddy Email
   From Email: info@heybuddydesign.com
   To Email: info@heybuddydesign.com
   Subject: Gmail SMTP Test from n8n
   Email Type: Text
   Message: If you receive this, Gmail SMTP is working perfectly!
   ```

4. **Click "Execute Node"**

5. **Check your Gmail inbox** - you should receive the email within seconds!

---

## 📊 Gmail Sending Limits

### Free Gmail Account:
- **500 emails per day**
- **500 recipients per email**
- Resets at midnight PST

### Google Workspace:
- **2,000 emails per day**
- Better for production use

### For Your Use Case:
- Contact form submissions: Well within limits
- 500/day = plenty for a business contact form

---

## 🔄 How to Change Email in n8n Workflow

### After SMTP credential is working:

1. **Open your workflow** in n8n

2. **Click on "Email - Team Notification" node**
   - Scroll to "Credential to connect with"
   - Select **"HeyBuddy Email"**
   - Verify "From Email" is: `info@heybuddydesign.com`

3. **Click on "Email - Customer Confirmation" node**
   - Select credential: **"HeyBuddy Email"**
   - Verify "From Email" is: `info@heybuddydesign.com`

4. **Save the workflow**

---

## 🔐 Security Best Practices

✅ **DO:**
- Use app passwords (not regular password)
- Keep app password secure
- Delete app passwords you're not using
- Use different app password for each app

❌ **DON'T:**
- Share app passwords
- Use same password for multiple services
- Store passwords in plain text
- Disable 2-Step Verification

---

## 🎯 Why Gmail is Better Than PrivateEmail for n8n

| Feature | Gmail | PrivateEmail |
|---------|-------|--------------|
| **Reliability on cloud** | ✅ Excellent | ⚠️ Can be problematic |
| **Port blocking** | ✅ Rarely blocked | ⚠️ Often blocked |
| **Setup difficulty** | ✅ Easy | ⚠️ Complex |
| **Deliverability** | ✅ Excellent | ✅ Good |
| **Daily limit** | 500 emails | Varies by plan |
| **n8n compatibility** | ✅ Perfect | ⚠️ Sometimes issues |

---

## 📝 Quick Checklist

- [ ] Go to https://myaccount.google.com/apppasswords
- [ ] Generate app password for "n8n HeyBuddy"
- [ ] Copy 16-character password (remove spaces)
- [ ] Go to https://n8n-9zlt.onrender.com
- [ ] Create SMTP credential with Gmail settings
- [ ] Test connection (should pass ✅)
- [ ] Update email nodes to use new credential
- [ ] Send test email
- [ ] Verify email received

---

## 🆘 Still Having Issues?

### Can't find App Passwords option?

**Solution:**
1. Make sure 2FA is enabled
2. Wait 10-15 minutes after enabling 2FA
3. Try incognito/private browsing window
4. Clear browser cache

### App password not working?

**Solution:**
1. Generate a new app password
2. Delete the old one
3. Make sure no spaces in password
4. Try copy-paste instead of typing

### Want to use a different Gmail account?

**You can:**
1. Create a new Gmail account (free)
2. Set up forwarding from info@heybuddydesign.com to new Gmail
3. Use new Gmail for SMTP sending
4. Replies will still go to info@heybuddydesign.com

---

## 🚀 Next Steps

Once Gmail SMTP is working:

1. ✅ Import complete workflow (with email nodes)
2. ✅ Connect email nodes to Gmail credential
3. ✅ Test form submission
4. ✅ Verify both emails (team + customer) arrive
5. ✅ Deploy website to production
6. ✅ Celebrate! 🎉

---

**Ready to get started? Follow Step 1 above!** 🚀
