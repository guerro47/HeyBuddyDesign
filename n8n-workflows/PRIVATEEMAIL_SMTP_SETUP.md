# PrivateEmail SMTP Setup for n8n (Render)

## 🎯 Quick Setup for info@heybuddydesign.com

Follow these exact steps to set up PrivateEmail SMTP in your Render n8n instance.

---

## Step 1: Go to Your n8n Instance

**URL:** https://n8n-9zlt.onrender.com

**Login** with your admin credentials

---

## Step 2: Create SMTP Credential

### Navigate to Credentials:

1. Click **"Credentials"** in the left sidebar
2. Click **"+ Add Credential"** button (top right)
3. In the search box, type: **"SMTP"**
4. Click **"SMTP"** from the results

---

## Step 3: Configure PrivateEmail SMTP

### Try Configuration #1 (Most Common):

Fill in these exact values:

```
Credential Name: HeyBuddy Email

Connection:
  - Host: smtp.privateemail.com
  - Port: 587
  - Secure Connection: None (Use TLS)

Authentication:
  - User: info@heybuddydesign.com
  - Password: [your PrivateEmail password]
```

**Click "Save"**

**Click "Test"** to verify connection

---

### If Test Fails - Try Configuration #2:

```
Credential Name: HeyBuddy Email

Connection:
  - Host: mail.privateemail.com
  - Port: 587
  - Secure Connection: None (Use TLS)

Authentication:
  - User: info@heybuddydesign.com
  - Password: [your PrivateEmail password]
```

---

### If Still Fails - Try Configuration #3:

```
Credential Name: HeyBuddy Email

Connection:
  - Host: smtp.privateemail.com
  - Port: 465
  - Secure Connection: SSL/TLS

Authentication:
  - User: info@heybuddydesign.com
  - Password: [your PrivateEmail password]
```

---

## 🧪 Test Your Credential

### After saving, click the "Test" button

**Success Response:**
```
✅ Connection test successful
```

**If you see an error:**
- Check password is correct (no extra spaces)
- Verify email address is exact
- Try different host/port combinations above
- See troubleshooting section below

---

## Step 4: Use Credential in Email Nodes

### After credential is created and tested:

1. **Open your workflow** in n8n
2. **Find the "Email - Team Notification" node**
   - Click on it
   - Scroll to "Credential to connect with"
   - Click the dropdown
   - Select **"HeyBuddy Email"**
3. **Find the "Email - Customer Confirmation" node**
   - Click on it
   - Scroll to "Credential to connect with"
   - Select **"HeyBuddy Email"**
4. **Save the workflow**

---

## 🔍 Visual Checklist

In n8n, you should see:

### Credentials Page:
```
Name                  Type
HeyBuddy Email        SMTP    ✅ Tested successfully
```

### Email Nodes:
```
Email - Team Notification
  ├─ Credential: HeyBuddy Email ✅
  ├─ From: info@heybuddydesign.com
  └─ To: info@heybuddydesign.com

Email - Customer Confirmation
  ├─ Credential: HeyBuddy Email ✅
  ├─ From: info@heybuddydesign.com
  └─ To: {{ $json.email }}
```

---

## 🧪 Complete Test

### Send a test email through n8n:

**Option A: Test via workflow execution**
1. Make sure workflow is **Activated** (green toggle)
2. Submit the contact form
3. Check both inboxes

**Option B: Quick test with manual trigger**
1. Create new workflow
2. Add "Manual Trigger" node
3. Add "Send Email" node with your credential
4. Configure:
   ```
   From: info@heybuddydesign.com
   To: info@heybuddydesign.com
   Subject: n8n SMTP Test
   Message: If you receive this, SMTP is working!
   ```
5. Click "Execute Node"
6. Check your inbox

---

## 🐛 Troubleshooting

### Error: "Connection timeout"

**This is the most common PrivateEmail issue on cloud platforms**

**Solutions to try:**

1. **Try different hosts:**
   ```
   smtp.privateemail.com
   mail.privateemail.com
   server{number}.privateemail.com
   ```

2. **Try different ports:**
   ```
   Port 587 with TLS
   Port 465 with SSL/TLS
   Port 2525 (alternative SMTP port)
   ```

3. **Check Render's outgoing port restrictions:**
   - Render may block certain SMTP ports
   - Contact Render support if all configs fail
   - Consider using an SMTP relay service

4. **Alternative: Use SendGrid (Free tier available):**
   - More reliable on cloud platforms
   - 100 emails/day free
   - Better for production use

---

### Error: "Authentication failed"

**Solutions:**

1. **Verify email and password:**
   - Login to PrivateEmail webmail to confirm
   - Copy password directly (avoid typing)
   - Check for extra spaces

2. **Check email format:**
   - Must be: info@heybuddydesign.com
   - Not: info or info@

3. **Verify SMTP is enabled:**
   - Login to PrivateEmail control panel
   - Check that SMTP sending is allowed
   - Check if there are any restrictions

---

### Error: "TLS/SSL handshake failed"

**Solutions:**

1. Switch between TLS and SSL/TLS:
   ```
   Port 587 → Use "None (Use TLS)"
   Port 465 → Use "SSL/TLS"
   ```

2. Try "Ignore SSL issues" option (in advanced settings)

---

### Emails Sent But Not Received

**Solutions:**

1. **Check spam/junk folder**
2. **Check PrivateEmail sending limits**
3. **Verify sender domain** (info@heybuddydesign.com)
4. **Check PrivateEmail logs:**
   - Login to PrivateEmail control panel
   - Look for email delivery logs
5. **Wait 5-10 minutes** (sometimes delayed)

---

## 📊 PrivateEmail SMTP Settings Reference

| Setting | Value | Notes |
|---------|-------|-------|
| **Primary Host** | smtp.privateemail.com | Try this first |
| **Alternative Host** | mail.privateemail.com | If primary fails |
| **Port (TLS)** | 587 | Recommended |
| **Port (SSL)** | 465 | Alternative |
| **Security (587)** | None (Use TLS) | For port 587 |
| **Security (465)** | SSL/TLS | For port 465 |
| **Username** | info@heybuddydesign.com | Full email address |
| **Password** | Your PrivateEmail password | Same as webmail login |

---

## 🔐 Security Best Practices

✅ **DO:**
- Use TLS/SSL encryption
- Use strong email password
- Keep credentials in n8n only
- Test regularly

❌ **DON'T:**
- Share SMTP credentials
- Use unencrypted connections
- Hard-code passwords in workflows
- Use same password everywhere

---

## 📧 Alternative: SendGrid (If PrivateEmail Issues Persist)

If you continue having issues with PrivateEmail on Render, consider SendGrid:

**Benefits:**
- Free tier: 100 emails/day
- More reliable on cloud platforms
- Better deliverability
- Easy n8n integration

**Setup:**
1. Sign up: https://sendgrid.com/
2. Create API key
3. In n8n: Use "SendGrid" node instead of "Send Email"
4. Works great with Render

---

## ✅ Success Checklist

After setup, verify:

- [ ] SMTP credential created in n8n
- [ ] Credential name: "HeyBuddy Email"
- [ ] Connection test passes (green ✅)
- [ ] Both email nodes use the credential
- [ ] Test email sent successfully
- [ ] Test email received in inbox
- [ ] Workflow is activated
- [ ] Form submission triggers emails

---

## 📞 Support

**PrivateEmail Support:**
- https://www.privatemail.com/support

**n8n Community:**
- https://community.n8n.io/

**Render Support:**
- https://render.com/docs/troubleshooting

---

## 🚀 Next Steps

Once SMTP is working:

1. ✅ Import complete workflow
2. ✅ Connect email nodes to SMTP credential
3. ✅ Test form → email flow
4. ✅ Deploy website to production
5. ✅ Celebrate! 🎉

---

**Ready to test? Let's go!** 🚀
