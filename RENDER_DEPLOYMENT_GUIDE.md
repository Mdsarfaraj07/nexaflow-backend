# 🚀 Deploy NexaFlow to Render.com (FREE!)

## ✅ Complete Free Deployment Guide

**Platform**: Render.com  
**Cost**: $0/month (Free forever!)  
**Setup Time**: 10 minutes  
**Live Time**: 5-10 minutes after clicking Deploy

---

## 📋 What You're Deploying

```
Backend (Java/Spring Boot)
├─ Port: 8080
├─ Service: nexaflow-backend
└─ URL: https://nexaflow-backend.onrender.com

Frontend (Node.js/Express)
├─ Port: 3000
├─ Service: nexaflow-frontend  
└─ URL: https://nexaflow-frontend.onrender.com

Database (PostgreSQL)
├─ Service: nexaflow-postgres
├─ Storage: 4GB free
└─ Managed: Auto by Render
```

---

## 🎯 STEP-BY-STEP DEPLOYMENT

### STEP 1: Create Render Account (2 minutes)

1. Go to: https://render.com
2. Click **"Sign Up"** (top right)
3. Click **"Continue with GitHub"**
4. Authorize Render
5. ✅ Account created!

---

### STEP 2: Deploy Backend Service (3 minutes)

1. Go to: https://dashboard.render.com
2. Click **"New +"** (top right)
3. Select **"Web Service"**
4. Connect GitHub:
   - Search: **nexaflow-backend**
   - Click to select
   - Click **"Connect"**

5. Configure service:
   - **Name**: `nexaflow-backend`
   - **Environment**: `Docker`
   - **Plan**: `Free`
   - **Branch**: `main`
   - Leave other fields as default

6. Click **"Create Web Service"**
7. ✅ Backend deploying! (Takes 5-10 min)

**Watch the build:**
- Go to **Logs** tab
- See real-time build progress
- Wait for "Build succeeded"

---

### STEP 3: Deploy Database Service (2 minutes)

1. From Dashboard: Click **"New +"**
2. Select **"PostgreSQL"**
3. Configure:
   - **Name**: `nexaflow-postgres`
   - **Plan**: `Free`
   - Leave password blank (Render generates)
   - Click **"Create Database"**

4. ✅ Database created!
5. Copy the **Internal Database URL** (you'll need this)

---

### STEP 4: Deploy Frontend Service (3 minutes)

1. From Dashboard: Click **"New +"**
2. Select **"Web Service"**
3. Connect GitHub:
   - Search: **nexaflow-backend** (same repo)
   - Click **"Connect"**

4. Configure service:
   - **Name**: `nexaflow-frontend`
   - **Environment**: `Node`
   - **Plan**: `Free`
   - **Build Command**: `npm install`
   - **Start Command**: `cd nexaflow-v3-complete && npm start`
   - **Branch**: `main`

5. Click **"Create Web Service"**
6. ✅ Frontend deploying!

---

### STEP 5: Configure Environment Variables

#### For Backend Service:

1. Go to **nexaflow-backend** service
2. Click **"Environment"** tab
3. Click **"Add Environment Variable"**
4. Add these variables:

```
SPRING_PROFILES_ACTIVE = production
PORT = 8080
SPRING_DATASOURCE_URL = postgresql://user:pass@nexaflow-postgres.render.internal:5432/nexaflow
SPRING_DATASOURCE_USERNAME = postgres
SPRING_DATASOURCE_PASSWORD = [from database service]
SPRING_JPA_HIBERNATE_DDL_AUTO = update
JWT_SECRET = [generate 32+ char random string]
CORS_ALLOWED_ORIGINS = https://nexaflow-frontend.onrender.com
APP_URL = https://nexaflow-backend.onrender.com
MAIL_HOST = smtp.gmail.com
MAIL_PORT = 587
MAIL_USERNAME = your-email@gmail.com
MAIL_PASSWORD = app-specific-password
```

#### For Frontend Service:

1. Go to **nexaflow-frontend** service
2. Click **"Environment"** tab
3. Add these variables:

```
NODE_ENV = production
PORT = 3000
BACKEND_URL = https://nexaflow-backend.onrender.com
API_BASE_URL = https://nexaflow-backend.onrender.com/api
JWT_SECRET = [same as backend]
```

✅ Environment variables set!

---

### STEP 6: Get Your Live URLs

1. Dashboard → Click **nexaflow-backend**
   - Copy the URL shown (e.g., https://nexaflow-backend-xxxxx.onrender.com)

2. Dashboard → Click **nexaflow-frontend**
   - Copy the URL shown (e.g., https://nexaflow-frontend-xxxxx.onrender.com)

3. Update Backend Environment Variables:
   - `CORS_ALLOWED_ORIGINS` = your frontend URL
   - `APP_URL` = your backend URL

---

### STEP 7: Test Your Deployment

#### Test Backend:

Open in browser:
```
https://nexaflow-backend-xxxxx.onrender.com/api/health
```

Expected response:
```json
{"status":"UP"}
```

✅ If you see this → Backend works!

#### Test Frontend:

Open in browser:
```
https://nexaflow-frontend-xxxxx.onrender.com
```

Expected: NexaFlow login page loads

✅ If you see login page → Frontend works!

#### Test Login:

Email: `admin@nexaflow.in`  
Password: `Admin@123`

✅ If dashboard loads → Everything works!

---

## 🎁 Your Live URLs

Once deployed, you'll have:

```
🚀 Backend API:
https://nexaflow-backend-xxxxx.onrender.com

🎨 Frontend UI:
https://nexaflow-frontend-xxxxx.onrender.com

💾 Database:
Managed by Render (auto)
```

Share these URLs with users!

---

## ⚙️ Important Notes

### Free Tier Features:
- ✅ Always-on deployment
- ✅ Auto-scaling
- ✅ SSL certificate (free)
- ✅ GitHub auto-deploy
- ✅ PostgreSQL database

### Free Tier Limits:
- ⚠️ Shared CPU (might be slow)
- ⚠️ Services spin down after 15 min inactivity
- ⚠️ First request might take 10 seconds

### Upgrade When Needed:
- **Pro plan**: $7/month per service
- **Features**: Dedicated resources, 24/7 uptime, no spin-down

---

## 🔄 Auto-Deploy from GitHub

Once deployed, updates are automatic:

```bash
git push origin main
  ↓
Render detects changes
  ↓
Auto-rebuilds services
  ↓
Deploys new version (5 min)
```

No manual redeploy needed!

---

## 🆘 Troubleshooting

### Backend shows error:

1. Check **Logs** tab
2. Look for error messages
3. Verify environment variables
4. Check database connection

### Frontend blank page:

1. Check browser console (F12)
2. Check API request is going to backend URL
3. Verify CORS_ALLOWED_ORIGINS
4. Check backend is responding

### Database not connecting:

1. Verify DATABASE_URL format
2. Check username/password
3. Ensure database service is running
4. Check firewall rules

### Services keep spinning down:

- This is normal on free tier
- First request after spin-down takes 10-15 seconds
- Upgrade to Pro ($7/month) for always-on

---

## 📊 Free Tier Performance

| Metric | Expected |
|--------|----------|
| Response time | 200-500ms |
| Uptime | 99% (excluding spin-down) |
| Database | 4GB storage |
| Requests/month | Unlimited |
| Images | Can pull from DockerHub |

---

## 💰 Total Cost

| Service | Free Tier | Pro Tier |
|---------|-----------|----------|
| Backend | $0 | $7/month |
| Frontend | $0 | $7/month |
| Database | $0 | $15/month |
| **Total** | **$0** | **$29/month** |

Start free, upgrade only when needed!

---

## 🎯 Next Steps

1. ✅ Deploy services on Render.com
2. ✅ Test all endpoints
3. ✅ Configure payment gateways (optional)
4. ✅ Set up custom domain (optional)
5. ✅ Monitor performance
6. ✅ Collect user feedback

---

## 📞 Documentation

- **Render Docs**: https://render.com/docs
- **Spring Boot Docs**: https://spring.io/projects/spring-boot
- **Express Docs**: https://expressjs.com/
- **PostgreSQL**: https://www.postgresql.org/docs/

---

## ✅ Deployment Checklist

- [ ] Render account created
- [ ] GitHub connected
- [ ] Backend service deployed
- [ ] Database service created
- [ ] Frontend service deployed
- [ ] Environment variables configured
- [ ] Backend health check working
- [ ] Frontend UI loads
- [ ] Login works
- [ ] Everything is LIVE! 🎉

---

**🚀 Your NexaFlow app is now live on Render.com for FREE!**

**Questions? Check Render documentation or visit https://render.com/support**
