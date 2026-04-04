# NexaFlow Railway Deployment Guide

Complete guide to deploy NexaFlow (Spring Boot Backend + Node.js Frontend) on Railway.app with MySQL database.

## 📋 Prerequisites

1. **Railway Account**: Sign up at https://railway.app
2. **GitHub Repository**: Push your code to GitHub
3. **Git Installed**: For local version control
4. **Brevo Account**: For email service (optional but recommended)

## 🚀 Step-by-Step Deployment

### Step 1: Prepare Your Repository

1. Initialize git in your project root:
```bash
cd d:\adminpanel\nexaflow-backend-complete
git init
git add .
git commit -m "Initial commit - NexaFlow v3.0"
```

2. Create a GitHub repository and push:
```bash
git remote add origin https://github.com/YOUR_USERNAME/nexaflow.git
git branch -M main
git push -u origin main
```

### Step 2: Connect Railway to GitHub

1. Go to **https://railway.app/dashboard**
2. Click **"New Project"** → **"Deploy from GitHub repo"**
3. Authorize Railway with GitHub
4. Select your **nexaflow** repository
5. Railway will auto-detect the Dockerfile

### Step 3: Configure Environment Variables on Railway

1. Go to your Railway project → **Variables**
2. Add the following variables:

#### Database Configuration
```
DB_HOST=mysql-db
DB_PORT=3306
DB_NAME=nexaflow_db
DB_USER=nexaflow
DB_PASS=YourSecureDbPassword123!
DB_ROOT_PASSWORD=RootPassword123!
```

#### Backend Configuration
```
SPRING_PROFILES_ACTIVE=railway
JWT_SECRET=YourVeryLongRandomJWTSecretMinimum32CharactersHere123!
CORS_ALLOWED_ORIGINS=*
DEFAULT_USD_TO_INR=83.5
```

#### Email Configuration (Brevo)
```
MAIL_HOST=smtp-relay.brevo.com
MAIL_PORT=587
MAIL_USERNAME=your-brevo-email@example.com
MAIL_PASSWORD=YourBrevoSMTPPassword
MAIL_FROM=noreply@nexaflow.com
```

#### Payment Gateways (Optional)
```
RAZORPAY_KEY_ID=rzp_live_xxxxxx
RAZORPAY_KEY_SECRET=your_secret_key
STRIPE_SECRET_KEY=sk_live_xxxx
STRIPE_PUBLISHABLE_KEY=pk_live_xxxx
```

#### Frontend Configuration
```
BACKEND_URL=https://your-railway-url.railway.app
APP_URL=https://your-railway-url.railway.app
```

### Step 4: Add MySQL Plugin on Railway

1. In Railway dashboard, click **"+ Add"** at the top
2. Search for **"MySQL"**
3. Click **"Add MySQL"**
4. Railway will auto-configure DB connection

**Railway will automatically map these env vars:**
- `DATABASE_URL` - Connection string
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_PASSWORD`

### Step 5: Configure Dockerfile

Railway will use the root `Dockerfile.railway` file. Ensure it exists with:

```dockerfile
# Build backend
FROM openjdk:17-slim AS backend
# ... build steps

# Build frontend
FROM node:18-alpine AS frontend
# ... build steps

# Runtime
FROM openjdk:17-slim
EXPOSE 8080 3000
CMD start-services.sh
```

### Step 6: Deploy

1. Push changes to GitHub:
```bash
git add .
git commit -m "Configure for Railway deployment"
git push origin main
```

2. Railway will auto-deploy when changes are pushed
3. Monitor deployment in **Railway Dashboard** → **Deployments**

### Step 7: Monitor & Verify

1. Check **Logs** tab for errors
2. Access your app at: `https://nexaflow-xxx.railway.app`
3. Backend API: `https://nexaflow-xxx.railway.app/api/services`
4. Frontend: `https://nexaflow-xxx.railway.app`

## 🔧 Post-Deployment Configuration

### Update Frontend API Endpoint

In `nexaflow-v3-complete/server.js`, ensure:
```javascript
const BACKEND_URL = process.env.BACKEND_URL || 'https://nexaflow-xxx.railway.app';
```

### Email Setup (Brevo)

1. Sign up at https://www.brevo.com
2. Get SMTP credentials from **Settings** → **SMTP & API**
3. Add to Railway variables:
   - `MAIL_USERNAME`: Your Brevo email
   - `MAIL_PASSWORD`: SMTP access key

### Custom Domain (Optional)

1. In Railway: **Settings** → **Custom Domain**
2. Add your domain (e.g., `nexaflow.com`)
3. Update DNS records as shown in Railway

## 🗄️ Database Management

### View MySQL Data
```bash
# Connect to MySQL
mysql -h your-mysql-host.railway.app -u nexaflow -p
```

### Backup Database
```bash
mysqldump -h your-host -u nexaflow -p nexaflow_db > backup.sql
```

### Import SQL File
```bash
mysql -h your-host -u nexaflow -p nexaflow_db < backup.sql
```

## 📊 Monitoring & Logs

### View Real-time Logs
In Railway Dashboard → Click project → **Logs** tab

### Check Application Health
```bash
curl https://your-app.railway.app/api/auth/health
```

### Monitor Resources
Railway Dashboard shows CPU, Memory, and Network usage

## 🚨 Troubleshooting

### Issue: "Port in use" error
**Solution**: Railway automatically assigns `PORT` env var. Backend should use `PORT` from env.

### Issue: Database connection failed
**Solution**: 
- Check `DATABASE_URL` variable exists
- Verify MySQL plugin is added
- Wait 2-3 minutes for DB to fully start

### Issue: Frontend can't reach backend
**Solution**: 
- Update `BACKEND_URL` in frontend env vars
- Check CORS settings in backend
- Verify both services are running in logs

### Issue: Email not sending
**Solution**:
- Verify Brevo credentials are correct
- Ensure SMTP host/port are set properly
- Check email logs in dashboard

## 🔐 Security Best Practices

✅ **Do's:**
- Keep JWT_SECRET longer than 32 characters
- Use strong, random database passwords
- Enable HTTPS (Railway handles this automatically)
- Regularly update dependencies

❌ **Don'ts:**
- Don't commit `.env` files to GitHub
- Don't use same password for all environments
- Don't expose API keys in public logs
- Don't use default credentials in production

## 📧 Contact & Support

- **Documentation**: https://railway.app/docs
- **Email**: support@nexaflow.com
- **Issue Tracker**: GitHub Issues

## 🎉 Success Checklist

- ✅ GitHub repo connected to Railway
- ✅ MySQL database provisioned
- ✅ Environment variables configured
- ✅ Dockerfile builds successfully
- ✅ Backend API responding (HTTP 200)
- ✅ Frontend loads (HTTP 200)
- ✅ Database migrations completed
- ✅ Email service tested
- ✅ Payment gateways configured (if needed)
- ✅ Custom domain set up (if needed)

Your NexaFlow application is now live on Railway! 🚀
