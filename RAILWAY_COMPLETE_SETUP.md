# Railway Deployment - Complete Setup Guide

## 🚀 Step-by-Step Railway Configuration

### **STEP 1: Access Railway Dashboard**
1. Go to: https://railway.app/dashboard
2. Select your **nexaflow-backend** project
3. Click on your deployed service

---

## **STEP 2: Add MySQL Database**

### In Railway Dashboard:
1. Click **"+ Add Service"** → **"Add from Marketplace"**
2. Search and select **"MySQL"**
3. Click **"Add Service"**
4. Railway will provision a MySQL database automatically

### MySQL Details (visible in Railway):
- Copy the generated `DATABASE_URL` (it includes all connection details)
- Format: `mysql://username:password@host:port/database`

---

## **STEP 3: Configure Environment Variables**

### In Railway Dashboard:
1. Click on your **nexaflow-backend** service
2. Go to **"Variables"** tab
3. Add each variable below:

### **REQUIRED Variables** (Database + Core):

```
# Database Configuration
SPRING_DATASOURCE_URL=mysql://root:RandomPasswordHere@containers-us-west-98.railway.app:6632/railway
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=RandomPasswordHere
SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_SHOW_SQL=false

# Server Configuration
SERVER_PORT=8080
SERVER_SERVLET_CONTEXT_PATH=/

# JWT Configuration (USE SECURE KEY)
JWT_SECRET=NexaFlow@SecureKey#Production2024#RandomString12345
JWT_EXPIRATION_MS=604800000

# CORS Configuration
ALLOWED_ORIGINS=*
```

### **EMAIL Configuration** (Choose One):

#### **Option A: Use Brevo (Recommended)**
```
# Brevo SMTP Configuration
SPRING_MAIL_HOST=smtp-relay.brevo.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=mdsarfaraj9886@gmail.com
SPRING_MAIL_PASSWORD=YOUR_BREVO_SMTP_KEY
SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH=true
SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE=true
MAIL_FROM_EMAIL=noreply@nexaflow.in
MAIL_FROM_NAME=NexaFlow

# Brevo API Key (for external calls)
BREVO_API_KEY=YOUR_BREVO_API_KEY
```

**Get Brevo Keys:**
1. Sign up: https://www.brevo.com
2. Go to: Settings → SMTP & API
3. Copy SMTP password and API key

#### **Option B: Use Gmail**
```
SPRING_MAIL_HOST=smtp.gmail.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=mdsarfaraj9886@gmail.com
SPRING_MAIL_PASSWORD=YOUR_GMAIL_APP_PASSWORD
SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH=true
SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE=true
MAIL_FROM_EMAIL=mdsarfaraj9886@gmail.com
MAIL_FROM_NAME=NexaFlow
```

**Get Gmail App Password:**
1. Go to: https://myaccount.google.com/apppasswords
2. Select Mail & Windows
3. Copy the 16-character password

---

### **PAYMENT Gateways** (Optional but Recommended):

#### **Razorpay** (India Payments)
```
RAZORPAY_KEY_ID=rzp_test_xxxxx
RAZORPAY_KEY_SECRET=xxxxxxxxxxxx
RAZORPAY_ENABLED=true
```

**Get Keys from:** https://dashboard.razorpay.com/settings/api-keys

#### **Stripe** (International)
```
STRIPE_API_KEY=sk_test_xxxxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxx
STRIPE_ENABLED=true
```

**Get Keys from:** https://dashboard.stripe.com/apikeys

---

## **STEP 4: Get Database Connection String from Railway**

1. In Railway Dashboard, click your **MySQL** service
2. Go to **"Connect"** tab
3. Copy the **"Database URL"** 
4. It looks like: `mysql://root:ABC123@containers-us-west-98.railway.app:6632/railway`

---

## **STEP 5: Add All Variables to Railway**

### In Railway Dashboard - Variables Tab:
1. Copy each variable from above sections
2. Click **"+ New Variable"**
3. Paste the key and value
4. Press **Enter** to save

### **Example:** Adding SPRING_DATASOURCE_URL
- **Key:** `SPRING_DATASOURCE_URL`
- **Value:** `mysql://root:ABC123@containers-us-west-98.railway.app:6632/railway`
- Click **"+ New Variable"**

**Repeat for ALL variables listed above**

---

## **STEP 6: Redeploy After Adding Variables**

1. After adding all variables, click **"Deploy"** button
2. Or: Go to **"Deployments"** → Click **"Deploy"** on latest commit
3. Wait 2-3 minutes for deployment
4. Check **"Logs"** tab for any errors

---

## **STEP 7: Verify Deployment**

### Check Logs:
1. Click **"Logs"** tab in Railway
2. Should see: `Started NexaFlowApplication in X seconds`
3. No ERROR messages = Success ✅

### Test API Endpoints:
1. Your app URL: `https://nexaflow-xxxx.railway.app` (find in Railway dashboard)
2. Test health check: `https://nexaflow-xxxx.railway.app/api/auth/health`
3. Should return: `{"status":"OK"}`

### Test Login:
```bash
curl -X POST https://nexaflow-xxxx.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@nexaflow.in","password":"Admin@123"}'
```

Response should include a JWT token.

---

## **STEP 8: Access Your App**

1. **Dashboard:** `https://nexaflow-xxxx.railway.app`
2. **Login with:**
   - Email: `admin@nexaflow.in`
   - Password: `Admin@123`

---

## **Troubleshooting**

### **If database connection fails:**
- Check `SPRING_DATASOURCE_URL` matches Railway's MySQL service URL
- Verify `SPRING_DATASOURCE_USERNAME` and `SPRING_DATASOURCE_PASSWORD` are correct
- Check MySQL service is running (Railway dashboard, MySQL service tab)

### **If emails don't send:**
- Verify SMTP credentials in variables
- Check Brevo/Gmail account is active
- Verify `MAIL_FROM_EMAIL` is correct

### **If deployment fails:**
- Check Railway **Logs** tab for error messages
- Verify Java/Maven versions: `java -version` and `mvn -version`
- Check `pom.xml` has all required dependencies

### **Database Not Created?**
Run this SQL on Railway MySQL:
```sql
CREATE DATABASE IF NOT EXISTS nexaflow_db;
USE nexaflow_db;
```

---

## **Final Checklist**

✅ MySQL database provisioned on Railway
✅ All environment variables added
✅ Application redeployed
✅ Health check endpoint responding
✅ Can login with admin@nexaflow.in / Admin@123
✅ Database tables created automatically
✅ (Optional) Email service configured
✅ (Optional) Payment gateways configured

---

## **Going Live**

Once verified:
1. Update `ALLOWED_ORIGINS` to your domain: `https://yourdomain.com`
2. Change `JWT_SECRET` to a strong random key
3. Update email from address to your domain
4. Enable payment gateways (Razorpay/Stripe)
5. Configure custom domain (Railway settings)

---

**Your Production URL:** 🚀 `https://nexaflow-xxxx.railway.app`

For more help, visit: https://railway.app/docs
