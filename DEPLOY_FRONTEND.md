# Deploy Frontend on Railway - 5 Minute Setup

## ✅ What's Ready

Your frontend and backend are already pushed to GitHub:
```
https://github.com/Mdsarfaraj07/nexaflow-backend
```

Everything is configured and ready to deploy!

---

## 🚀 Deploy Frontend (5 Steps)

### **STEP 1: Go to Railway Dashboard**
```
https://railway.app/dashboard
```

### **STEP 2: Create New Service**
1. Click your **nexaflow-backend** project
2. Click **[+ New Service]**
3. Select **"Deploy from GitHub"**

### **STEP 3: Select Repository**
1. Select: **Mdsarfaraj07/nexaflow-backend**
2. Leave **Root Directory** empty (or `/`)
3. Click **"Deploy"**

### **STEP 4: Set Environment Variables**

Wait for deployment to start, then go to **[Variables]** tab and add:

```
API_URL = https://nexaflow-backend-production.up.railway.app
NODE_ENV = production
PORT = 3000
```

### **STEP 5: Wait for Deployment**

- Watch **[Logs]** tab
- Should see: `Server running on port 3000`
- Look for your frontend URL (appears at top)

---

## 🌐 Your URLs After Deploy

```
Frontend: https://nexaflow-XXXX.railway.app
Backend API: https://nexaflow-backend-production.up.railway.app/api/
```

### **Test It:**
1. Open frontend URL
2. You should see login page
3. Login: admin@nexaflow.in / Admin@123

---

## ✅ Success!

You're done! Both frontend and backend are now **live and connected**! 🎉

---

## 🆘 Troubleshooting

**If you see "Port already in use":**
- Add: `PORT = 3000` to variables

**If frontend won't load:**
- Check: `API_URL = https://nexaflow-backend-production.up.railway.app`
- Check logs for errors

**If API calls fail:**
- Backend needs: `ALLOWED_ORIGINS = *` (should already be set)
- Verify backend URL is correct

---

## 📝 Your Credentials

```
Admin Email: admin@nexaflow.in
Admin Password: Admin@123

Demo Email: client@demo.com
Demo Password: Client@123
```

---

**That's it! You're fully deployed! 🚀**
