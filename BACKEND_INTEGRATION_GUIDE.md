# HeyBuddyDesign - Backend Integration Guide

## 🚀 Overview
This guide shows you how to connect the contact form, booking system, and AI chatbot to real backends.

---

## 📧 Contact Form Integration

### Option 1: FormSpree (Easiest - No Backend Required)
```html
<!-- Replace the form tag with: -->
<form id="contactForm" action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
```

**Steps:**
1. Go to [formspree.io](https://formspree.io)
2. Sign up and create a new form
3. Get your form ID
4. Replace `YOUR_FORM_ID` in the action attribute
5. Done! Form submissions go to your email

### Option 2: EmailJS (Client-side Email)
```javascript
// Add to your HTML head:
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>

// Initialize EmailJS
emailjs.init('YOUR_PUBLIC_KEY');

// In the form submit handler:
document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    emailjs.sendForm('YOUR_SERVICE_ID', 'YOUR_TEMPLATE_ID', this)
        .then(() => {
            showSuccessMessage();
            this.reset();
        }, (error) => {
            alert('Failed to send message: ' + error);
        });
});
```

**Steps:**
1. Sign up at [emailjs.com](https://www.emailjs.com)
2. Create an email service (Gmail, Outlook, etc.)
3. Create an email template
4. Get your Public Key, Service ID, and Template ID
5. Replace in the code above

### Option 3: Custom Backend (Most Control)
```javascript
document.getElementById('contactForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        service: document.getElementById('service').value,
        message: document.getElementById('message').value
    };
    
    try {
        const response = await fetch('https://your-api.com/contact', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            showSuccessMessage();
            this.reset();
        } else {
            throw new Error('Failed to send');
        }
    } catch (error) {
        alert('Error: ' + error.message);
    }
});
```

**Backend Example (Node.js + Express):**
```javascript
const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.post('/contact', async (req, res) => {
    const { name, email, phone, service, message } = req.body;
    
    // Configure email transporter
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'your-email@gmail.com',
            pass: 'your-app-password'
        }
    });
    
    // Email content
    const mailOptions = {
        from: email,
        to: 'hello@heybuddydesign.com',
        subject: `New Contact Form: ${service}`,
        html: `
            <h2>New Contact Form Submission</h2>
            <p><strong>Name:</strong> ${name}</p>
            <p><strong>Email:</strong> ${email}</p>
            <p><strong>Phone:</strong> ${phone}</p>
            <p><strong>Service:</strong> ${service}</p>
            <p><strong>Message:</strong> ${message}</p>
        `
    };
    
    try {
        await transporter.sendMail(mailOptions);
        res.json({ success: true });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

---

## 📅 Booking System Integration

### Option 1: Calendly Integration (Easiest)
```html
<!-- Replace the booking section with Calendly embed -->
<div class="calendly-inline-widget" 
     data-url="https://calendly.com/your-username/30min" 
     style="min-width:320px;height:630px;">
</div>
<script type="text/javascript" src="https://assets.calendly.com/assets/external/widget.js"></script>
```

**Steps:**
1. Sign up at [calendly.com](https://calendly.com)
2. Set up your availability
3. Get your scheduling link
4. Replace `your-username` in the code

### Option 2: Cal.com (Open Source Alternative)
```html
<div id="my-cal-inline" style="width:100%;height:100%;overflow:scroll"></div>
<script type="text/javascript">
  (function (C, A, L) { 
    let p = function (a, ar) { 
      a.q.push(ar); 
    }; 
    let d = C.document; 
    C.Cal = C.Cal || function () { 
      let cal = C.Cal; 
      let ar = arguments; 
      if (!cal.loaded) { 
        cal.ns = {}; 
        cal.q = cal.q || []; 
        d.head.appendChild(d.createElement("script")).src = A; 
        cal.loaded = true; 
      } 
      if (ar[0] === L) { 
        const api = function () { 
          p(api, arguments); 
        }; 
        const namespace = ar[1]; 
        api.q = api.q || []; 
        typeof namespace === "string" ? (cal.ns[namespace] = api) && p(api, ar) : p(cal, ar); 
        return; 
      } 
      p(cal, ar); 
    }; 
  })(window, "https://app.cal.com/embed/embed.js", "init");
  
  Cal("init", {origin:"https://cal.com"});
  Cal("inline", {
    elementOrSelector:"#my-cal-inline",
    calLink: "your-username/30min"
  });
</script>
```

### Option 3: Custom Backend with Database
```javascript
// Frontend - Confirm booking
async function confirmBooking() {
    if (!selectedDate || !selectedTime) {
        alert('Please select both a date and time!');
        return;
    }
    
    try {
        const response = await fetch('https://your-api.com/bookings', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                date: selectedDate.toISOString(),
                time: selectedTime,
                name: 'User Name', // Get from a form
                email: 'user@example.com', // Get from a form
                service: 'Consultation'
            })
        });
        
        if (response.ok) {
            const data = await response.json();
            alert(`✓ Booking confirmed! ID: ${data.bookingId}`);
        }
    } catch (error) {
        alert('Booking failed: ' + error.message);
    }
}
```

**Backend Example (Node.js + MongoDB):**
```javascript
const express = require('express');
const mongoose = require('mongoose');

// Booking Schema
const bookingSchema = new mongoose.Schema({
    date: Date,
    time: String,
    name: String,
    email: String,
    service: String,
    status: { type: String, default: 'pending' },
    createdAt: { type: Date, default: Date.now }
});

const Booking = mongoose.model('Booking', bookingSchema);

app.post('/bookings', async (req, res) => {
    try {
        const booking = new Booking(req.body);
        await booking.save();
        
        // Send confirmation email
        await sendBookingEmail(booking);
        
        res.json({ 
            success: true, 
            bookingId: booking._id 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get available slots
app.get('/bookings/available', async (req, res) => {
    const { date } = req.query;
    
    const bookedSlots = await Booking.find({
        date: new Date(date),
        status: 'confirmed'
    }).select('time');
    
    const allSlots = ['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM'];
    const availableSlots = allSlots.filter(
        slot => !bookedSlots.find(b => b.time === slot)
    );
    
    res.json({ availableSlots });
});
```

---

## 🤖 AI Chatbot Integration

### Option 1: OpenAI Integration (Best Quality)
```javascript
async function sendMessage() {
    const input = document.getElementById('chatInput');
    const message = input.value.trim();
    
    if (!message) return;
    
    addMessage(message, 'user');
    input.value = '';
    showTypingIndicator();
    
    try {
        const response = await fetch('https://your-api.com/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ message })
        });
        
        const data = await response.json();
        hideTypingIndicator();
        addMessage(data.reply, 'bot');
    } catch (error) {
        hideTypingIndicator();
        addMessage('Sorry, I had trouble connecting. Try again!', 'bot');
    }
}
```

**Backend Example (Node.js + OpenAI):**
```javascript
const OpenAI = require('openai');

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY
});

app.post('/chat', async (req, res) => {
    const { message } = req.body;
    
    try {
        const completion = await openai.chat.completions.create({
            model: "gpt-4",
            messages: [
                {
                    role: "system",
                    content: `You are BuddyBot, a helpful AI assistant for heybuddydesign. 
                    We offer web design, hosting, AI agents, and automation services.
                    Be friendly, concise, and helpful. Answer questions about:
                    - Services (web design, hosting, AI agents, automation)
                    - Pricing (starts at $999 for websites, $29/mo for hosting)
                    - Timeline (2-4 weeks typical, 1 week rush available)
                    - Contact info (hello@heybuddydesign.com)`
                },
                {
                    role: "user",
                    content: message
                }
            ],
            max_tokens: 150,
            temperature: 0.7
        });
        
        res.json({ 
            reply: completion.choices[0].message.content 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
```

### Option 2: Anthropic Claude Integration
```javascript
const Anthropic = require('@anthropic-ai/sdk');

const anthropic = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY
});

app.post('/chat', async (req, res) => {
    const { message } = req.body;
    
    try {
        const response = await anthropic.messages.create({
            model: "claude-3-5-sonnet-20241022",
            max_tokens: 200,
            system: `You are BuddyBot for heybuddydesign. Be concise and helpful.`,
            messages: [
                { role: "user", content: message }
            ]
        });
        
        res.json({ 
            reply: response.content[0].text 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
```

### Option 3: Dialogflow (Google)
1. Create a Dialogflow agent at [dialogflow.cloud.google.com](https://dialogflow.cloud.google.com)
2. Set up intents (greetings, pricing questions, service inquiries)
3. Get your project ID and API key
4. Use the Dialogflow SDK:

```javascript
const dialogflow = require('@google-cloud/dialogflow');

const sessionClient = new dialogflow.SessionsClient({
    keyFilename: './google-credentials.json'
});

app.post('/chat', async (req, res) => {
    const { message, sessionId } = req.body;
    
    const sessionPath = sessionClient.projectAgentSessionPath(
        'your-project-id',
        sessionId || 'default-session'
    );
    
    const request = {
        session: sessionPath,
        queryInput: {
            text: {
                text: message,
                languageCode: 'en-US',
            },
        },
    };
    
    try {
        const responses = await sessionClient.detectIntent(request);
        const result = responses[0].queryResult;
        
        res.json({ 
            reply: result.fulfillmentText 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
```

---

## 🔧 Quick Setup Recommendations

### For Beginners:
1. **Contact Form:** Use FormSpree (5 min setup)
2. **Booking:** Use Calendly (10 min setup)
3. **Chatbot:** Keep the current rule-based one or use Tawk.to (free live chat)

### For Intermediate:
1. **Contact Form:** EmailJS
2. **Booking:** Cal.com (self-hosted)
3. **Chatbot:** OpenAI API with simple backend

### For Advanced:
1. **Contact Form:** Custom backend with database
2. **Booking:** Custom system with real-time availability
3. **Chatbot:** Claude/GPT-4 with conversation memory and CRM integration

---

## 🌐 Deployment

### Recommended Platforms:
- **Static Site:** Vercel, Netlify, Cloudflare Pages (free)
- **Backend:** Vercel Functions, Cloudflare Workers, Railway (free tier)
- **Full Stack:** DigitalOcean, Heroku, AWS

### Quick Deploy with Vercel:
```bash
npm install -g vercel
vercel login
vercel
```

---

## 📊 Analytics & Tracking

Add Google Analytics:
```html
<!-- Add before </head> -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

---

## 🔐 Security Tips

1. **Never expose API keys in frontend code**
2. Use environment variables for secrets
3. Add rate limiting to prevent spam
4. Validate all user inputs
5. Use HTTPS only
6. Add CORS protection on backend

---

## 💡 Need Help?

- **Docs:** Check API documentation for each service
- **Support:** Contact hello@heybuddydesign.com
- **Community:** Join our Discord for help

---

Made with 💚 by heybuddydesign
