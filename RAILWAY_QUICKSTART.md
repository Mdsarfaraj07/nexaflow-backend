# 🚀 NexaFlow Railway Deployment - Quick Start

**Complete deployment in 15 minutes**

## Prerequisites
- GitHub Account
- Railway Account (free at railway.app)
- Brevo Account (free at brevo.com - for emails)

---

## ⚡ 5-Step Deployment

### **STEP 1: Push to GitHub (2 minutes)**

```bash
cd d:\adminpanel\nexaflow-backend-complete

git init
git add .
git commit -m "NexaFlow v3.0 - Ready for Railway deployment"
git remote add origin https://github.com/YOUR_USERNAME/nexaflow.git
git branch -M main
git push -u origin main
```

✅ Your code is now on GitHub!

---

### **STEP 2: Create Railway Project (3 minutes)**

1. Go to **https://railway.app/dashboard**
2. Click **"New Project"** → **"Deploy from GitHub repo"**
3. Select your **nexaflow** repository
4. Railway auto-detects Dockerfile ✓

✅ Railway connected to GitHub!

---

### **STEP 3: Add MySQL Database (2 minutes)**

1. In Railway dashboard, click **"+ Add"** button
2. Search and select **"MySQL"** plugin
3. Click **"Add"** (Railway configures automatically)

Railway will auto-set these env vars:
- `DATABASE_URL`
- `MYSQLHOST`
- `MYSQL_PASSWORD`

✅ Database ready!

---

### **STEP 4: Configure Environment Variables (5 minutes)**

Click **"Variables"** tab and paste these (replacing placeholders):

```
# DATABASE (auto-set by Railway, but verify)
DB_HOST=mysql-db
DB_PORT=3306
DB_NAME=nexaflow_db
DB_USER=nexaflow
DB_PASS=YourSecurePassword123!
DB_ROOT_PASSWORD=RootPassword123!

# BACKEND CONFIG
SPRING_PROFILES_ACTIVE=railway
JWT_SECRET=Generate32CharRandomStringHere123456789ABCDEF
CORS_ALLOWED_ORIGINS=*
DEFAULT_USD_TO_INR=83.5

# EMAIL (Brevo SMTP)
MAIL_HOST=smtp-relay.brevo.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your_brevo_smtp_key_from_settings
MAIL_FROM=noreply@nexaflow.com

# FRONTEND CONFIG
BACKEND_URL=https://nexaflow-xxxx.railway.app
APP_URL=https://nexaflow-xxxx.railway.app

# PAYMENT GATEWAYS (optional)
RAZORPAY_KEY_ID=rzp_live_xxxxx
RAZORPAY_KEY_SECRET=your_secret
STRIPE_SECRET_KEY=sk_live_xxxxx
STRIPE_PUBLISHABLE_KEY=pk_live_xxxxx
```

📝 **Getting Brevo SMTP Key:**
1. Sign up at https://brevo.com
2. Go Settings → SMTP & API
3. Copy SMTP password → paste as `MAIL_PASSWORD`

✅ All variables configured!

---

### **STEP 5: Deploy (3 minutes)**

Push any change to trigger deployment:
```bash
git add .
git commit -m "Deploy to Railway"
git push origin main
```

**Or click "Deploy" in Railway dashboard manually**

Monitor deployment:
1. Click **"Deployments"** tab
2. Watch logs in real-time
3. Your app is live when all green ✓

✅ **LIVE!** 🎉

---

## ✅ Verify Your Deployment

### Check Backend
```bash
curl https://your-railway-url.railway.app/api/services
# Should return: [ { service data }, ... ]
```

### Check Frontend
Visit: `https://your-railway-url.railway.app`
- Sign in: `admin@nexaflow.in` / `Admin@123`
- Should see dashboard ✓

### Test Email
- In dashboard, create a booking
- Check email received
- If not, verify Brevo credentials ✓

---

## 🎯 Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| **Build fails** | Check logs for missing env vars |
| **DB connection error** | Verify `DB_HOST`, `DB_USER`, `DB_PASS` |
| **Email not working** | Verify Brevo SMTP credentials |
| **Frontend shows 404** | Clear browser cache, try incognito |
| **Slow initial load** | Railway free tier uses sleep, takes 10s first time |

---

## 🔗 Next Steps

### Option 1: Add Custom Domain
1. Buy domain (Namecheap, GoDaddy, etc.)
2. In Railway → **Settings** → **Custom Domain**
3. Add your domain
4. Update DNS records as shown
5. SSL auto-configured ✓

### Option 2: Setup Email Templates
1. Test with existing templates
2. Customize in `server.js` (frontend) or `EmailService.java` (backend)
3. Deploy changes

### Option 3: Configure Payment Gateways
Already set up! Just add API keys to Railway variables:
- **Razorpay**: https://dashboard.razorpay.com
- **Stripe**: https://dashboard.stripe.com

---

## 📊 Monitoring Your App

**View Logs:**
- Railway Dashboard → **Logs** tab
- Real-time application output

**Check Performance:**
- Memory, CPU, Network usage
- Railway Dashboard → **Metrics**

**Setup Alerts:**
- Railway → Settings → Notifications
- Get alerted on deploy failures

---

## 🔐 Security Reminders

✅ **Done:**
- HTTPS enabled automatically
- Database credentials secured
- JWT authentication configured

⚠️ **To Do:**
- Change default admin password after first login
- Enable 2FA on GitHub account
- Regularly backup database
- Monitor logs for errors

---

## 🎉 Success!

Your NexaFlow application is now:
- ✅ Live on Railway
- ✅ Connected to MySQL
- ✅ Running both backend & frontend
- ✅ Receiving and sending emails
- ✅ Processing payments (if configured)
- ✅ Accessible worldwide

**Your app URL:** `https://your-railway-url.railway.app`

---

## 📞 Support

**Documentation:**
- Railway: https://railway.app/docs
- Backend: RAILWAY_DEPLOYMENT_GUIDE.md
- Detailed checklist: RAILWAY_DEPLOYMENT_CHECKLIST.sh

**Troubleshooting:**
- Check logs in Railway dashboard
- Verify all env vars are set
- Ensure database is running
- Check GitHub commit is the latest code

---

**Deployed! 🚀** Your NexaFlow application is now live on Railway!
