# Deploy n8n to Railway.app

## 🚀 Why Railway is Perfect for n8n

- ✅ **$5 free credit monthly** (hobby plan)
- ✅ **Super easy deployment** (easiest of all options!)
- ✅ **Always on** (no spin-down)
- ✅ **Automatic HTTPS**
- ✅ **Great performance**
- ✅ **Simple interface**
- ✅ **Persistent storage included**

**Cost:** ~$5-8/month after free credit

---

## 📋 Step-by-Step Deployment

### Step 1: Sign Up for Railway

**Go to:** https://railway.app

1. Click **"Login"** or **"Start a New Project"**
2. **Sign in with GitHub** (recommended) or email
3. Verify your email
4. You'll get **$5 free credit** each month on Hobby plan

---

### Step 2: Deploy n8n (Super Easy!)

#### Option A: One-Click Deploy from Template (EASIEST!)

1. **Go to Railway Templates:** https://railway.app/templates

2. **Search for "n8n"** in the template search

3. **Click on the n8n template**

4. **Click "Deploy Now"**

5. **Configure:**
   ```
   Project Name: heybuddy-n8n
   ```

6. **Click "Deploy"**

7. **Wait 2-3 minutes** for deployment ✨

---

#### Option B: Manual Deploy (More Control)

1. **Go to:** https://railway.app/dashboard

2. **Click "+ New Project"**

3. **Click "Deploy from Docker image"**

4. **Enter Docker image:**
   ```
   n8nio/n8n:latest
   ```

5. **Click "Deploy"**

---

### Step 3: Configure Environment Variables

**After deployment starts:**

1. **Click on your n8n service**

2. **Go to "Variables" tab**

3. **Add these environment variables:**

```
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://YOUR_APP_NAME.up.railway.app/
N8N_HOST=YOUR_APP_NAME.up.railway.app
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=HeyBuddy2025!
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true
```

**Note:** Railway will auto-generate a URL like `heybuddy-n8n-production.up.railway.app`

4. **Click "Add" for each variable**

---

### Step 4: Enable Public Domain

1. **In your service, go to "Settings" tab**

2. **Scroll to "Networking" section**

3. **Click "Generate Domain"**

4. **Copy your domain:** `something-production.up.railway.app`

5. **Update environment variables** with this domain:
   - Replace `YOUR_APP_NAME` in `WEBHOOK_URL` and `N8N_HOST`
   - Click "Redeploy" if needed

---

### Step 5: Add Persistent Storage (Important!)

1. **In your service, go to "Settings"**

2. **Scroll to "Volumes"**

3. **Click "+ New Volume"**

4. **Configure:**
   ```
   Mount Path: /home/node/.n8n
   Size: 1 GB
   ```

5. **Click "Add"**

6. **Redeploy** (Railway will prompt you)

---

### Step 6: Access Your n8n

**Once deployed (2-3 minutes):**

1. **Click "Deployments" tab**

2. **Wait for status to show "Active" (green)**

3. **Click your domain URL** or visit:
   ```
   https://your-app-name-production.up.railway.app
   ```

4. **Login:**
   - Username: `admin`
   - Password: `HeyBuddy2025!`

---

## 🎯 Import Your Workflow

### Step 1: Access n8n

Go to your Railway n8n URL

### Step 2: Import Workflow

1. **Click "Workflows"** → **"+ Add workflow"**

2. **Click "..." menu** (three dots) → **"Import from File"**

3. **Select:** `complete-workflow-with-emails.json`
   - From: `/home/user/Documents/heybuddy/n8n-workflows/backups/`

4. **Click "Open"**

5. **Workflow loads!** 🎉

6. **Click "Save"**

---

### Step 3: Add Gmail SMTP Credential

1. **Click "Credentials"** (left sidebar)

2. **Click "+ Add Credential"**

3. **Search "SMTP"** and select it

4. **Fill in:**
   ```
   Credential Name: HeyBuddy Email
   Host: smtp.gmail.com
   Port: 587
   Secure Connection: None (Use TLS)
   User: [your Gmail address]
   Password: [your 16-character Gmail app password, NO spaces]
   ```

5. **Click "Save"**

6. **Click "Test"** → Should show ✅

---

### Step 4: Connect SMTP to Email Nodes

**Go back to your workflow:**

1. **Click "Email - Team Notification" node**
   - Scroll to "Credential to connect with"
   - Select "HeyBuddy Email"

2. **Click "Email - Customer Confirmation" node**
   - Select "HeyBuddy Email"

3. **Click "Save"** (workflow)

---

### Step 5: ACTIVATE Workflow

1. **Look at top-right corner**

2. **Click the toggle** to make it **GREEN (Active)**

3. **You should see:** `Active ✅`

---

### Step 6: Get Your Webhook URL

**Your production webhook URL will be:**
```
https://your-app-name-production.up.railway.app/webhook/0f6bd949-4e9a-4f4c-b9b1-b3cff418804d
```

**Copy this!** We'll update your contact form with it.

---

## 🧪 Test Your Deployment

Let me know your Railway n8n URL and I'll test it for you!

Or test yourself:

```bash
curl -X POST https://your-railway-url.up.railway.app/webhook/0f6bd949-4e9a-4f4c-b9b1-b3cff418804d \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Railway Test",
    "email": "test@example.com",
    "phone": "07123456789",
    "budget": "£1,000-£2,000",
    "timeline": "ASAP - Urgent",
    "service": "Professional Website",
    "message": "Testing Railway deployment"
  }'
```

Should return success response and send emails!

---

## 💰 Railway Pricing

**Hobby Plan:**
- $5/month free credit
- $0.000231/GB-hour for usage
- ~$5-8/month total for n8n
- No credit card required for trial

**Pro Plan:**
- $20/month
- More resources
- Better for production

---

## ✅ Deployment Checklist

- [ ] Sign up for Railway
- [ ] Deploy n8n (template or Docker)
- [ ] Configure environment variables
- [ ] Generate public domain
- [ ] Add persistent volume (1GB)
- [ ] Wait for deployment (2-3 min)
- [ ] Access n8n interface
- [ ] Import workflow
- [ ] Create SMTP credential
- [ ] Connect credential to email nodes
- [ ] Activate workflow
- [ ] Test webhook
- [ ] Update contact form with new URL

---

## 🚀 Advantages of Railway Over Render

| Feature | Railway | Render |
|---------|---------|--------|
| **Setup** | Easier | Easy |
| **Free Tier** | $5 credit/month | Spins down |
| **Always On** | ✅ Yes | ❌ Free tier spins down |
| **Persistent Storage** | ✅ Built-in | ⚠️ Paid tier only |
| **Deployment Speed** | ⚡ Faster | Normal |
| **Interface** | 🎨 Beautiful | Functional |
| **Cost** | ~$5-8/month | $7/month (starter) |

---

## 🎯 Quick Start Commands

**If you have Railway CLI installed:**

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Create new project
railway init

# Add n8n
railway add

# Select Docker deployment
# Image: n8nio/n8n:latest

# Deploy
railway up
```

---

## 🆘 Troubleshooting

### Issue: Can't access n8n

**Solutions:**
1. Check deployment status is "Active"
2. Make sure domain is generated
3. Wait 2-3 minutes after deployment
4. Check logs for errors

### Issue: Workflow not saving

**Solutions:**
1. Add persistent volume
2. Mount path: `/home/node/.n8n`
3. Redeploy service

### Issue: Emails not sending

**Solutions:**
1. Verify Gmail SMTP credential
2. Check app password has no spaces
3. Test SMTP connection
4. Check spam folder

---

## 📞 Support

- **Railway Docs:** https://docs.railway.app
- **Railway Discord:** https://discord.gg/railway
- **n8n Docs:** https://docs.n8n.io

---

**Ready to deploy? Tell me when you're in Railway and I'll help you through each step!**
