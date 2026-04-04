# 🚀 NexaFlow Complete Deployment Guide - Railway

## ✅ Pre-Deployment Checklist

- ✅ GitHub Repository: https://github.com/Mdsarfaraj07/nexaflow-backend
- ✅ Backend: Spring Boot 3.2 (Java 17)
- ✅ Frontend: Node.js 18+ (Express Server)
- ✅ Database: MySQL 8.0+
- ✅ Monorepo Structure: Ready
- ✅ Docker Configuration: Ready

---

## 📋 Step 1: Create Railway Account

1. Go to: https://railway.app
2. Click **"Get Started"** → **"Sign up with GitHub"**
3. Authorize Railway to access your GitHub
4. Accept terms and conditions
5. Complete setup

---

## 🎯 Step 2: Create New Project on Railway

### Option A: Using Docker (Easiest)

1. In Railway Dashboard: **New Project** → **Deploy from GitHub**
2. Select repository: **Mdsarfaraj07/nexaflow-backend**
3. Railway auto-detects Docker
4. Click **Deploy**

### Option B: Using Railway Services (More Control)

1. **New Project**
2. Search and add these services:
   - **MySQL Plugin** (Database)
   - **Node.js** (Frontend)
   - **Java 17** (Backend)

---

## 🔐 Step 3: Configure Environment Variables

### MySQL Database Variables

After adding MySQL plugin, Railway auto-generates:
```
DATABASE_URL=mysql://user:pass@host:port/dbname
DB_HOST=your-mysql-host.railway.internal
DB_PORT=3306
DB_NAME=nexaflow
DB_USER=root
DB_PASS=your_secure_password
```

### Backend (Java) Variables

Add these to Railway **Variables** tab:

```
# Server
SERVER_PORT=8080
JAVA_TOOL_OPTIONS=-Xmx512m

# Database
SPRING_DATASOURCE_URL=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}
SPRING_DATASOURCE_USERNAME=${DB_USER}
SPRING_DATASOURCE_PASSWORD=${DB_PASS}
SPRING_JPA_HIBERNATE_DDL_AUTO=update

# JWT Security (GENERATE NEW!)
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-change-this-in-prod

# CORS & Origin
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.railway.app,https://yourdomain.com
APP_URL=https://your-backend-domain.railway.app

# Email Configuration (Optional)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-specific-password

# Payment Integration (Optional)
RAZORPAY_KEY_ID=rzp_live_your_key_id
RAZORPAY_KEY_SECRET=your_key_secret
STRIPE_SECRET_KEY=sk_live_your_stripe_key
```

### Frontend (Node.js) Variables

Add these variables:

```
# Server
PORT=3000
NODE_ENV=production

# Backend Connection
BACKEND_URL=https://your-backend-domain.railway.app
API_BASE_URL=https://your-backend-domain.railway.app/api

# Payment Keys
RAZORPAY_KEY_ID=rzp_live_your_key_id
STRIPE_PUBLISHABLE_KEY=pk_live_your_stripe_key

# Email (Brevo/SMTP)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-specific-password

# JWT Secret (Must match backend)
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-change-this-in-prod
```

---

## 🎲 Step 4: Deploy via Docker Compose

### Using Root Docker File (Recommended)

Railway will use: `./Dockerfile` (multi-stage build)

This automatically:
1. Builds backend (Maven → Java)
2. Builds frontend (npm install → Node.js)
3. Creates production container
4. Deploys to Railway

---

## 📊 Step 5: Deployment Flow

### Expected Timeline

| Step | Time | Action |
|------|------|--------|
| 1 | 2-3 min | Repository cloned |
| 2 | 5-8 min | Backend built (Maven compile) |
| 3 | 3-5 min | Frontend built (npm install) |
| 4 | 1-2 min | Container created & pushed |
| 5 | 1-2 min | Services started |
| **Total** | **~15-20 min** | **Live!** |

### Monitor Deployment

1. Go to Railway Project
2. Click **[Deployments]** tab
3. Watch **[Logs]** for build progress
4. Watch for: ✅ **Build succeeded**

---

## ✨ Step 6: Verify Deployment

### Check Backend is Running

```bash
curl https://your-backend-domain.railway.app/api/health
```

Expected response:
```json
{"status": "UP"}
```

### Check Frontend is Running

Visit: `https://your-frontend-domain.railway.app`

Expected: Full NexaFlow interface loads

---

## 🔗 Step 7: Custom Domain (Optional)

1. Go to Railway **Settings** → **Custom Domain**
2. Enter your domain: `api.yourdomain.com`
3. Add DNS records (Railway shows instructions)
4. Wait for SSL cert (auto)
5. Domain is live!

---

## 🚨 Troubleshooting

### Backend Won't Start
- Check Java version: Should be 17+
- Check DATABASE_URL format
- Check MySQL connection
- View logs for errors

### Frontend Shows Blank Page
- Check API_BASE_URL points to backend
- Check CORS_ALLOWED_ORIGINS includes frontend
- View browser console for errors

### Unable to Connect to Database
- Verify DB_HOST format (with `.railway.internal` suffix)
- Check firewall/network settings
- Ensure MySQL service is running

### Deployment Stuck at "Building"
- Check logs for errors
- Maven might timeout (15+ min) - normal for first build
- Check disk space

---

## 🎯 Manual Deployment Steps (If Auto-Deploy Doesn't Work)

### Step A: SSH into Railway Container
```bash
railway run bash
```

### Step B: Build Backend
```bash
cd nexaflow-backend
mvn clean install -DskipTests
```

### Step C: Build Frontend
```bash
cd ../nexaflow-v3-complete
npm install
```

### Step D: Start Services
```bash
# In one terminal
cd nexaflow-backend && java -jar target/nexaflow-backend-3.0.0.jar

# In another terminal
cd nexaflow-v3-complete && node server.js
```

---

## 📈 Post-Deployment Checklist

- [ ] Backend health check passes
- [ ] Frontend UI loads
- [ ] Login works (admin@nexaflow.in / Admin@123)
- [ ] API endpoints responding
- [ ] Database connected
- [ ] Email service configured
- [ ] Payment gateway working
- [ ] SSL certificate active
- [ ] Custom domain configured

---

## 💡 Performance Optimization

Add to Railway **Variables**:

```
# Java Optimization
JAVA_TOOL_OPTIONS=-Xmx512m -XX:+UseG1GC

# Node.js Optimization
NODE_ENV=production
NODE_OPTIONS=--max-old-space-size=512
```

---

## 🔄 Continuous Deployment

Railway auto-deploys when you push to GitHub:

1. Make changes locally
2. `git add .`
3. `git commit -m "Update message"`
4. `git push origin main`
5. Watch Railway auto-deploy (takes ~5 min)

---

## 📞 Support & Resources

- Railway Docs: https://docs.railway.app
- Spring Boot Docs: https://spring.io/projects/spring-boot
- Node.js Docs: https://nodejs.org/docs
- NexaFlow Repo: https://github.com/Mdsarfaraj07/nexaflow-backend

---

**Ready to deploy? Let's go! 🚀**
