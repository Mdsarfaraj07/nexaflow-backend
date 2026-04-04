# 🚀 Deploy NexaFlow to Railway.app - Step-by-Step Guide

## ✅ Prerequisites Checklist

- [x] GitHub repository created: https://github.com/Mdsarfaraj07/nexaflow-backend
- [x] Code pushed to GitHub
- [x] Dockerfile configured
- [x] Ready to deploy

---

## 🎯 STEP-BY-STEP DEPLOYMENT PROCESS

### STEP 1: Go to Railway.app

1. Open: https://railway.app
2. If not logged in:
   - Click **"Login"** (top right)
   - Choose **"Login with GitHub"**
   - Authorize Railway to access GitHub
   - Done ✅

---

### STEP 2: Create New Project

1. Go to Dashboard: https://railway.app/dashboard
2. Click **"New Project"** (blue button, top right)
3. Click **"Deploy from GitHub"** option
4. Select your GitHub account (if prompted)
5. ✅ Proceed to next step

---

### STEP 3: Select Your Repository

1. Search for: **nexaflow-backend**
2. Click to select it
3. Confirm authorization (if prompted)
4. Click **"Deploy Now"** or **"Deploy"**
5. ✅ Railway starts building!

**Watch the deployment:**
- Go to **Deployments** tab
- See real-time build logs
- Expected time: 15-20 minutes for first build

---

### STEP 4: Add MySQL Database

1. Once backend deploys, click **"New Service"**
2. Search for **"MySQL"**
3. Click **"MySQL"** to add
4. Railway auto-configures everything
5. Wait ~30 seconds for initialization
6. ✅ Database service added!

---

### STEP 5: Configure Environment Variables

1. Click **"Variables"** tab
2. Railway shows auto-generated variables from MySQL:
   ```
   DATABASE_URL=mysql://user:password@host:3306/database
   ```

3. Click **"Raw Editor"** (easier method)
4. Add all these variables (copy from below):

```
# ═════════════════════════════════════════════════════
# DATABASE (Keep as-is, Railway generates these)
# ═════════════════════════════════════════════════════
DATABASE_URL=mysql://root:${DB_PASSWORD}@${DB_HOST}:3306/nexaflow

# ═════════════════════════════════════════════════════
# BACKEND - SPRING BOOT
# ═════════════════════════════════════════════════════
SPRING_PROFILES_ACTIVE=production
SPRING_DATASOURCE_URL=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?useSSL=false&serverTimezone=UTC
SPRING_DATASOURCE_USERNAME=${DB_USER}
SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}
SPRING_JPA_HIBERNATE_DDL_AUTO=update

# ═════════════════════════════════════════════════════
# JWT SECURITY (⚠️ CHANGE THIS!)
# Generate random string: https://generate-random.org/string-generator
# ═════════════════════════════════════════════════════
JWT_SECRET=change_me_to_secure_32_plus_char_string_NOW

# ═════════════════════════════════════════════════════
# APPLICATION URLS (Update after you get Railway domains)
# ═════════════════════════════════════════════════════
APP_URL=https://your-backend-domain.railway.app
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.railway.app,https://yourdomain.com

# ═════════════════════════════════════════════════════
# EMAIL (Optional - for notifications)
# ═════════════════════════════════════════════════════
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-specific-password

# ═════════════════════════════════════════════════════
# PAYMENT (Optional - get from Razorpay/Stripe)
# ═════════════════════════════════════════════════════
RAZORPAY_KEY_ID=rzp_live_your_key
RAZORPAY_KEY_SECRET=your_secret_key
STRIPE_SECRET_KEY=sk_live_your_key

# ═════════════════════════════════════════════════════
# PORT CONFIGURATION
# ═════════════════════════════════════════════════════
PORT=3000
SERVER_PORT=8080

# ═════════════════════════════════════════════════════
# FRONTEND (Node.js)
# ═════════════════════════════════════════════════════
NODE_ENV=production
BACKEND_URL=https://your-backend-domain.railway.app
API_BASE_URL=https://your-backend-domain.railway.app/api
```

5. Click **"Save"**
6. Railway auto-redeploys with new variables (~2 minutes)
7. ✅ Environment configured!

---

### STEP 6: Get Your Railway URLs

1. Go to **"Settings"** tab
2. Scroll to **"Domains"** section
3. You'll see auto-generated URLs:
   ```
   Example:
   Backend: nexaflow-prod-xxxxx.railway.app
   Frontend: nexaflow-web-xxxxx.railway.app
   ```

4. Copy these URLs
5. Go back to **"Variables"** tab
6. Update:
   - `APP_URL` → your backend URL
   - `CORS_ALLOWED_ORIGINS` → your frontend URL
   - `BACKEND_URL` → your backend URL
   - `API_BASE_URL` → your backend URL + `/api`

7. Click **"Save"** again
8. ✅ URLs configured!

---

### STEP 7: Verify Deployment

#### Test Backend Health:

1. Open in browser (or terminal):
   ```
   https://your-backend-domain.railway.app/api/health
   ```

2. Should return:
   ```json
   {"status": "UP"}
   ```

   If you see this → ✅ **Backend works!**

#### Test Frontend:

1. Open in browser:
   ```
   https://your-frontend-domain.railway.app
   ```

2. Should show NexaFlow login page
   If you see the login → ✅ **Frontend works!**

#### Login Test:

1. Email: `admin@nexaflow.in`
2. Password: `Admin@123`
3. If dashboard loads → ✅ **Everything works!**

---

## ✅ Deployment Complete!

Your application is now live at:
- **Backend API**: https://your-backend-domain.railway.app
- **Frontend UI**: https://your-frontend-domain.railway.app
- **Health Check**: https://your-backend-domain.railway.app/api/health

---

## 🔗 View Your Live Project

1. **Railway Dashboard**: https://railway.app/dashboard
2. **Your Project**: Shows real-time logs, metrics, deployments
3. **Monitor**: CPU, Memory, Network usage
4. **Logs**: View application logs for debugging

---

## 📊 Monitor Your Deployment

### Check Logs:
1. Project → **[Deployments]** tab
2. Click latest deployment
3. View real-time logs

### Check Metrics:
1. Project → **[Metrics]** tab
2. Monitor CPU, Memory, Network

### Check Status:
1. Project → **[Overview]** or **[Settings]**
2. See deployment status

---

## 🚨 Troubleshooting

### If deployment fails:
1. Check **[Deployments]** → **[Logs]**
2. Look for error messages
3. Common issues:
   - Java compilation error → Check pom.xml
   - Database connection → Check DATABASE_URL
   - Missing variables → Add all required env vars

### If backend doesn't respond:
1. Wait 2-3 minutes (services might be starting)
2. Check `/api/health` endpoint
3. Look at logs for errors
4. Verify DATABASE_URL is correct

### If frontend shows blank:
1. Check browser console for errors
2. Verify BACKEND_URL matches backend domain
3. Check CORS_ALLOWED_ORIGINS
4. Wait for backend to be fully ready

### Check if services are running:
```bash
# Backend should respond
curl https://your-backend-domain.railway.app/api/health

# Frontend should return HTML
curl https://your-frontend-domain.railway.app
```

---

## 🔄 Update Your Application

To push updates to production:

1. Make changes locally
   ```bash
   git add .
   git commit -m "Your message"
   git push origin main
   ```

2. Railway automatically redeploys (~5 minutes)

3. Check [Deployments] tab to monitor

---

## 💾 Important Notes

- **First deployment**: ~20 minutes (compiling everything)
- **Subsequent updates**: ~5 minutes (incremental builds)
- **Database**: Auto-created on first run
- **SSL**: Auto-configured by Railway
- **Backups**: Enable in Railway settings

---

## 🎁 Optional: Add Custom Domain

1. Buy domain (GoDaddy, NameCheap, etc.)
2. Railway Project → **[Settings]** → **Custom Domains**
3. Add your domain
4. Railway provides DNS records to add
5. Add records to your domain provider
6. Wait 5-10 minutes for SSL cert
7. ✅ Custom domain live!

---

## ✨ Success Checklist

- [ ] Railway account created
- [ ] Project deployed from GitHub
- [ ] MySQL database added
- [ ] Environment variables configured
- [ ] Backend responds to /api/health
- [ ] Frontend UI loads
- [ ] Login with demo account works
- [ ] No errors in logs
- [ ] Both services running

---

**🎉 Your project is now live on Railway! 🎉**

Monitor your application at: https://railway.app/dashboard
