# 🚀 NexaFlow - Complete Deployment to Railway (5 Steps)

## ✅ Pre-Deployment Checklist

- ✅ GitHub Repository Updated: https://github.com/Mdsarfaraj07/nexaflow-backend
- ✅ Backend Running Locally: http://localhost:8080
- ✅ Frontend Running Locally: http://localhost:3000
- ✅ Both Ready for Production

---

## 🎯 STEP 1: Create Railway Account (5 minutes)

### What to Do:
1. Open: https://railway.app
2. Click **"Get Started"**
3. Select **"Sign up with GitHub"**
4. Click **"Authorize railway"**
5. Accept terms
6. Choose a team name (or skip)
7. ✅ Done!

### Result:
- Railway account created
- Connected to your GitHub
- Ready to deploy

---

## 📦 STEP 2: Create New Project (3 minutes)

### What to Do:

1. Open: https://railway.app/dashboard
2. Click **"[+ New Project]"** button
3. Click **"Deploy from GitHub"**
4. Search for: `nexaflow-backend`
5. Click to select repository
6. Click **"Deploy"**

### What Railway Does Automatically:
- ✅ Detects Docker configuration
- ✅ Starts building backend (Maven)
- ✅ Starts building frontend (npm)
- ✅ Creates Docker image
- ✅ Deploys to production

### Watch the Progress:

Go to project → **[Deployments]** tab → Click latest deployment

You'll see logs like:
```
[1/5] Building with docker
[2/5] Compiling java files
[3/5] Installing npm dependencies
[4/5] Creating production image
[5/5] Starting services
✅ Build succeeded!
```

---

## 🔐 STEP 3: Add MySQL Database (2 minutes)

### What to Do:

1. In Railway Project, click **"[+ New Service]"**
2. Search for: **"MySQL"** / **"Database"**
3. Click **"MySQL"**
4. Wait for service to initialize (30-60 sec)

### What Railway Provides:
Automatically generates:
- `DATABASE_URL` - Connection string
- `DB_HOST` - Database hostname
- `DB_PORT` - Port (always 3306)
- `DB_NAME` - nexaflow
- `DB_USER` - root
- `DB_PASSWORD` - Secure password

You can see these in **[Variables]** tab 👈

---

## ⚙️ STEP 4: Add Environment Variables (10 minutes)

### What to Do:

1. Go to Railway Project → **[Variables]** tab
2. Click **"Raw Editor"** (easier)
3. Copy content from: `RAILWAY_ENV_VARIABLES.txt` (in this repo)
4. Replace placeholder values:

#### MUST CHANGE THESE:

```
# Database (auto-generated, keep as-is)
DATABASE_URL=mysql://root:xxxxx@xxx.railway.internal:3306/nexaflow

# Security (GENERATE NEW!)
JWT_SECRET=generate_secure_32_plus_char_string_here

# Your Domain (after deployment)
CORS_ALLOWED_ORIGINS=https://your-domain.railway.app
APP_URL=https://your-backend-api.railway.app

# Email (choose one)
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-specific-password

# Payment (get from Razorpay/Stripe dashboards)
RAZORPAY_KEY_ID=rzp_live_xxx
RAZORPAY_KEY_SECRET=xxx
```

5. Click **"Deploy"** to apply changes

### ⏳ Wait for Redeployment (~2 minutes)

Railway auto-redeploys with new environment variables

---

## 🔗 STEP 5: Get Your URLs (1 minute)

### What to Do:

1. Go to Railway Project → **Settings** tab
2. Scroll to **"Domains"** section
3. You'll see auto-generated URLs:

```
Backend: xxxxx-production.railway.app
Frontend: xxxxx-production.railway.app
```

### Update Your Configuration:

These URLs are your production domains. Update:

```
Backend URL:  https://xxxxx-production.railway.app
Frontend URL: https://xxxxx-production.railway.app/api
```

Update these in Railway **[Variables]** tab for both services.

---

## ✨ STEP 6: Verify Everything Works (5 minutes)

### Test Backend:

Open in browser or terminal:
```
https://your-backend-domain.railway.app/api/health
```

Expected response:
```json
{"status": "UP", "database": "Connected"}
```

### Test Frontend:

Open in browser:
```
https://your-frontend-domain.railway.app
```

Expected: NexaFlow login page loads

### Login with Demo Account:

- Email: `admin@nexaflow.in`
- Password: `Admin@123`

✅ If you see dashboard, deployment is successful!

---

## 🎁 Optional: Custom Domain (10 minutes)

### What to Do:

1. Buy domain: GoDaddy, NameCheap, etc.
2. Railway Project → **Settings** → **Custom Domains**
3. Enter: `api.yourdomain.com`
4. Railway shows DNS records to add
5. Add records to your domain provider
6. Wait 5-10 minutes for SSL certificate
7. ✅ Custom domain live!

### Example:
```
Before: nexaflow-backend-xxx.railway.app
After:  api.yourdomain.com ✨
```

---

## 🚀 DEPLOYMENT COMPLETE!

### What's Running:

| Service | URL | Status |
|---------|-----|--------|
| Backend API | `your-backend.railway.app` | ✅ Running |
| Frontend | `your-frontend.railway.app` | ✅ Running |
| Database | MySQL on Railway | ✅ Connected |
| SSL | Auto-managed | ✅ Active |

---

## 📊 Monitor Your Deployment

### Useful Links:

1. **Dashboard**: https://railway.app/dashboard
2. **Logs**: Project → [Deployments] → Click deployment
3. **Metrics**: Project → [Metrics]
4. **Variables**: Project → [Variables]
5. **Settings**: Project → [Settings]

### Monitor These Metrics:

- ✅ CPU Usage (should be <30%)
- ✅ Memory Usage (should be <60%)
- ✅ Network (check for errors)
- ✅ Logs (no ERROR entries)

---

## 🔄 Update & Redeploy

### To Push Updates:

1. Make changes locally
2. ```bash
   git add .
   git commit -m "Update message"
   git push origin main
   ```
3. Railroad auto-deploys (watch Dashboard)
4. Takes ~5 minutes for full deployment

---

## 🆘 Troubleshooting

### "Build Failed"

1. Check **[Deployments]** → **[Logs]**
2. Look for error messages
3. Common issues:
   - Java compilation error → Check pom.xml
   - npm error → Check package.json
   - Docker error → Check Dockerfile

### "Connection Refused"

1. Backend not started?
2. Check `DATABASE_URL` is set
3. Visit `/api/health` endpoint
4. Check logs for database errors

### "Frontend Blank Page"

1. Check browser console for errors
2. Verify `BACKEND_URL` matches backend domain
3. Check CORS settings
4. Check Network tab in DevTools

### "500 Internal Server Error"

1. Check backend logs
2. Verify database connection
3. Check environment variables
4. Look for stack trace in logs

---

## 💡 Performance Tips

1. **Increase Memory**: `JAVA_TOOL_OPTIONS=-Xmx1g`
2. **Enable Caching**: Add Redis plugin
3. **Add CDN**: For static files
4. **Database Backup**: Enable Railway backups
5. **Monitor**: Set up email alerts

---

## 📞 Need Help?

- **Railway Docs**: https://docs.railway.app
- **Spring Boot Help**: https://spring.io/projects/spring-boot
- **Node.js Issues**: https://nodejs.org/docs
- **GitHub Issues**: Report bugs in the repo

---

## ✅ Deployment Checklist

- [ ] Railway account created
- [ ] Project created
- [ ] MySQL database added
- [ ] Environment variables configured
- [ ] Backend URL working
- [ ] Frontend UI loading
- [ ] Login works
- [ ] API endpoints responding
- [ ] Database connected
- [ ] Email notifications working
- [ ] Payment gateway configured
- [ ] SSL certificate active
- [ ] Custom domain configured (optional)
- [ ] Monitoring enabled

---

**🎉 Congratulations! Your NexaFlow is now live on Railway!**

---

### Next Steps:

1. ✅ Share your public URL
2. ✅ Let users know it's live
3. ✅ Monitor performance
4. ✅ Collect feedback
5. ✅ Plan improvements

---

**Questions? Check RAILWAY_DEPLOYMENT_SETUP.md for detailed info.**
