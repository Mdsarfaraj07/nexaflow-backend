# 🔐 NexaFlow Deployment - Credentials & Setup Guide

**KEEP THIS FILE SECURE - Contains sensitive setup instructions**

---

## 📋 Table of Contents
1. [Getting Started Accounts](#getting-started-accounts)
2. [Credential Checklist](#credential-checklist)
3. [Service Setup Instructions](#service-setup-instructions)
4. [Deployment Variables](#deployment-variables)
5. [Post-Deployment Steps](#post-deployment-steps)

---

## 🎯 Getting Started Accounts

You'll need accounts at these services (most are free):

| Service | Purpose | Free Tier | Link |
|---------|---------|-----------|------|
| **GitHub** | Code hosting | ✅ Unlimited | https://github.com |
| **Railway** | Deployment platform | ✅ Free $5/month | https://railway.app |
| **Brevo** | Email sending | ✅ 300/day | https://brevo.com |
| **MySQL** | Database | ✅ On Railway | Included with Railway MySQL |
| **Razorpay** | India payments | ✅ Test mode | https://razorpay.com |
| **Stripe** | Intl payments | ✅ Test mode | https://stripe.com |

---

## ✅ Credential Checklist

### Must Have (Required)
- [ ] GitHub account with repository
- [ ] Railway account connected to GitHub
- [ ] Brevo account with SMTP credentials
- [ ] Strong JWT secret (32+ characters)

### Nice to Have (Optional)
- [ ] Razorpay API keys (India payments)
- [ ] Stripe API keys (International payments)
- [ ] Custom domain
- [ ] SendGrid or other email service

---

## 🔧 Service Setup Instructions

### 1️⃣ GitHub Setup (5 minutes)

**Create GitHub Account:**
1. Go to https://github.com/signup
2. Create account with your email
3. Verify email address

**Create Repository:**
1. Click **"+"** → **"New repository"**
2. Name: `nexaflow`
3. Description: `NexaFlow - Global SaaS Platform v3.0`
4. Make it **Public** (for Railway to access)
5. Click **"Create repository"**

**Push Your Code:**
```bash
cd d:\adminpanel\nexaflow-backend-complete

git config user.name "Your Name"
git config user.email "your@email.com"

git init
git add .
git commit -m "Initial NexaFlow deployment"
git remote add origin https://github.com/YOUR_USERNAME/nexaflow.git
git branch -M main
git push -u origin main
```

---

### 2️⃣ Railway Setup (10 minutes)

**Create Railway Account:**
1. Go to https://railway.app
2. Click **"Get Started"**
3. Sign up with GitHub (recommended)
4. Grant Railway access to GitHub

**Connect Repository:**
1. Dashboard → **"New Project"**
2. **"Deploy from GitHub repo"**
3. Select your **nexaflow** repository
4. Railway auto-detects and builds

**Add MySQL Database:**
1. Click **"+ Add"** button
2. Search **"MySQL"**
3. Click **"Add MySQL"**
4. Railway configures (wait 2-3 minutes)

---

### 3️⃣ Brevo Email Setup (8 minutes)

**Create Brevo Account:**
1. Go to https://brevo.com/register
2. Sign up with your email
3. Verify email
4. Complete onboarding

**Get SMTP Credentials:**
1. Login → **Settings** (left menu)
2. Click **"SMTP & API"**
3. In **"SMTP"** section, you'll see:
   - **SMTP Host:** `smtp-relay.brevo.com`
   - **SMTP Port:** `587`
   - **SMTP Username:** Your email address
   - **SMTP Password:** ⚠️ **Generate or use existing**

**Generate SMTP Password:**
1. In "SMTP & API" section
2. Click **"Generate SMTP password"** (if needed)
3. Copy the password (save it!)
4. This becomes `MAIL_PASSWORD` on Railway

**Verify Sender:**
1. Add your sender email address
2. Brevo sends verification email
3. Click verification link
4. Now you can send emails!

---

### 4️⃣ Razorpay Setup (Optional, 5 minutes)

**For India Payments:**

1. Go to https://razorpay.com
2. Sign up with email
3. Complete business verification
4. Dashboard → **Settings** → **API Keys**
5. Copy:
   - **Key ID** → `RAZORPAY_KEY_ID`
   - **Key Secret** → `RAZORPAY_KEY_SECRET`

---

### 5️⃣ Stripe Setup (Optional, 5 minutes)

**For International Payments:**

1. Go to https://stripe.com
2. Create account
3. Complete verification
4. Dashboard → **Developers** → **API Keys**
5. Copy **Secret Key** → `STRIPE_SECRET_KEY`
6. Copy **Publishable Key** → `STRIPE_PUBLISHABLE_KEY`

---

## 📝 Deployment Variables

### All Variables You Need to Set on Railway

```
# ================================================
# 1. DATABASE (Auto-set by Railway, but verify)
# ================================================
DB_HOST=mysql-db
DB_PORT=3306
DB_NAME=nexaflow_db
DB_USER=nexaflow
DB_PASS=[GENERATE STRONG PASSWORD]
DB_ROOT_PASSWORD=[GENERATE STRONG PASSWORD]

# ================================================
# 2. BACKEND SECURITY
# ================================================
# Generate 32+ character random string here:
# Use: https://1password.com/password-generator/ or
# node: require('crypto').randomBytes(32).toString('hex')
JWT_SECRET=[RANDOM 32+ CHARS]
JWT_EXPIRATION=604800000

# ================================================
# 3. CORS & FRONTEND
# ================================================
CORS_ALLOWED_ORIGINS=*
BACKEND_URL=https://your-railway-url.railway.app
APP_URL=https://your-railway-url.railway.app
FRONTEND_PORT=3000

# ================================================
# 4. EMAIL (From Brevo Setup)
# ================================================
MAIL_HOST=smtp-relay.brevo.com
MAIL_PORT=587
MAIL_USERNAME=[YOUR_BREVO_SENDER_EMAIL]
MAIL_PASSWORD=[YOUR_BREVO_SMTP_PASSWORD]
MAIL_FROM=[YOUR_FROM_EMAIL]

# ================================================
# 5. PAYMENT GATEWAYS (Optional)
# ================================================
# From Razorpay Dashboard:
RAZORPAY_KEY_ID=rzp_live_[GET FROM DASHBOARD]
RAZORPAY_KEY_SECRET=[GET FROM DASHBOARD]

# From Stripe Dashboard:
STRIPE_SECRET_KEY=sk_live_[GET FROM DASHBOARD]
STRIPE_PUBLISHABLE_KEY=pk_live_[GET FROM DASHBOARD]

# ================================================
# 6. EXCHANGE RATE
# ================================================
DEFAULT_USD_TO_INR=83.5

# ================================================
# 7. LOGGING
# ================================================
SPRING_PROFILES_ACTIVE=railway
LOG_LEVEL=INFO
NODE_ENV=production
```

---

## 🚀 Post-Deployment Steps

### Step 1: First Access (Immediately)

1. Visit: `https://your-railway-url.railway.app`
2. Sign in with:
   - **Email:** `admin@nexaflow.in`
   - **Password:** `Admin@123`
3. ⚠️ **CHANGE THIS PASSWORD IMMEDIATELY!**

### Step 2: Test Core Functions (Day 1)

- [ ] Admin dashboard loads
- [ ] Can create a service
- [ ] Can create a booking
- [ ] Can create an invoice
- [ ] Email is sent for bookings
- [ ] Payment gateway responds

### Step 3: Database Backup (Day 1)

Railway auto-backups, but backup manually:
```bash
# Connect to Railway MySQL
mysql -h your-mysql-host -u nexaflow -p nexaflow_db < backup.sql
```

### Step 4: Monitor (Ongoing)

- Check logs daily for errors
- Monitor CPU/memory usage
- Check email delivery status
- Review payment transactions

### Step 5: Security Hardening (Day 2)

- [ ] Change all default credentials
- [ ] Enable 2FA on GitHub
- [ ] Setup Railway alerts
- [ ] Configure SSH keys
- [ ] Review database permissions

### Step 6: Custom Domain (Optional)

1. Buy domain: Namecheap, GoDaddy, etc.
2. In Railway → **Settings** → **Custom Domain**
3. Add your domain
4. Update DNS records
5. SSL auto-configured ✓

### Step 7: Setup Monitoring (Week 1)

- Setup error alerts
- Configure uptime monitoring
- Setup payment monitoring
- Create database backup schedule

---

## 🔒 Important Security Notes

### ⚠️ DO NOT
- Commit `.env` files to GitHub
- Share API keys publicly
- Use simple passwords
- Use same password for all services
- Expose database credentials

### ✅ DO
- Use strong, random passwords (32+ characters)
- Store credentials securely (password manager)
- Rotate API keys periodically
- Enable 2FA on all accounts
- Regular database backups
- Monitor access logs

---

## 📞 Need Help?

### Troubleshooting Guide
- **Build fails:** Check logs in Railway Deployments tab
- **DB not connecting:** Verify DB_HOST, DB_USER, DB_PASS
- **Email not sending:** Verify Brevo credentials and sender verification
- **Payment not working:** Check API keys in payment gateway dashboard

### Useful Links
- Railway Docs: https://railway.app/docs
- Brevo SMTP Guide: https://developers.brevo.com/docs/smtp-integration
- Razorpay Docs: https://razorpay.com/docs
- Stripe Docs: https://stripe.com/docs

### Support
- GitHub Issues: https://github.com/YOUR_USERNAME/nexaflow/issues
- Email: your-email@example.com

---

## ✅ Checklist - Before Going Live

- [ ] GitHub repository with latest code pushed
- [ ] Railway project created and connected
- [ ] MySQL database provisioned and running
- [ ] All environment variables set correctly
- [ ] Email tested (Brevo SMTP working)
- [ ] Backend API responding (HTTP 200)
- [ ] Frontend loads without errors
- [ ] Default admin credentials changed
- [ ] Database backup created
- [ ] Payment gateways configured (if using)
- [ ] Custom domain setup (if using)
- [ ] Monitoring/alerts configured
- [ ] Tested full booking workflow
- [ ] Verified email notifications
- [ ] Checked security settings
- [ ] Documentation updated

---

**Congratulations!** 🎉 Your NexaFlow application is now live on Railway!

For questions, check:
1. RAILWAY_QUICKSTART.md - Fast 5-step deployment
2. RAILWAY_DEPLOYMENT_GUIDE.md - Complete detailed guide
3. RAILWAY_DEPLOYMENT_CHECKLIST.sh - Pre-deployment verification

**Next:** Customize your instance and start acquiring customers! 🚀
