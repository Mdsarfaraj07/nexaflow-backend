# Railway Visual Setup Guide 🚀

## 📍 STEP 1: Login to Railway Dashboard

```
URL: https://railway.app/dashboard
└─ Click on your "nexaflow-backend" project
   └─ You'll see your deployed app
```

---

## 📍 STEP 2: Add MySQL Database

### In Railway Dashboard:

```
Dashboard
  └─ nexaflow-backend (project)
     └─ [Your Service] 
     └─ [+ Add Service] ← CLICK HERE
        └─ "Add from Marketplace"
           └─ Search: "MySQL"
           └─ Click "MySQL"
           └─ Click "Add Service"
```

### What happens:
✅ Railway creates MySQL database automatically
✅ Database name: `railway` (or similar)
✅ Username: `root`
✅ Password: (auto-generated, random)
✅ Host & Port: (auto-assigned)

---

## 📍 STEP 3: Get Database Connection Info

### In Railway Dashboard:

```
Your MySQL Service
  └─ Click "MySQL" service name
     └─ [Connect] tab ← CLICK HERE
        └─ Copy the "Database URL"
```

### What you'll see:
```
mysql://root:RandomPassword123@containers-us-west-98.railway.app:6632/railway
         ^^^^               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         user               password                   host:port/database
```

### **Save this URL!** You'll need it.

---

## 📍 STEP 4: Configure Application Environment Variables

### In Railway Dashboard:

```
nexaflow-backend Service
  ├─ Click "nexaflow-backend" (not MySQL)
  └─ [Variables] tab ← CLICK HERE
     └─ You'll see an empty list or existing vars
```

---

## 📍 STEP 5: Add Database Variables

### One by one, add these:

```
[+ New Variable] button

Variable 1:
  Key:   SPRING_DATASOURCE_URL
  Value: mysql://root:RandomPassword@containers-us-west-98.railway.app:6632/railway
  
[+ New Variable]

Variable 2:
  Key:   SPRING_DATASOURCE_USERNAME
  Value: root

[+ New Variable]

Variable 3:
  Key:   SPRING_DATASOURCE_PASSWORD
  Value: RandomPassword123

[+ New Variable]

Variable 4:
  Key:   SPRING_DATASOURCE_DRIVER_CLASS_NAME
  Value: com.mysql.cj.jdbc.Driver

[+ New Variable]

Variable 5:
  Key:   SPRING_JPA_HIBERNATE_DDL_AUTO
  Value: update
```

---

## 📍 STEP 6: Add Core Application Variables

### Continue adding:

```
[+ New Variable]

Variable 6:
  Key:   SERVER_PORT
  Value: 8080

[+ New Variable]

Variable 7:
  Key:   JWT_SECRET
  Value: NexaFlow@SecureKey#Production2024#MySecureKeyHere12345

[+ New Variable]

Variable 8:
  Key:   JWT_EXPIRATION_MS
  Value: 604800000
```

---

## 📍 STEP 7: Add Email Configuration

### Choose ONE option: Brevo OR Gmail

#### **OPTION A: Brevo (Recommended - Free 300/day emails)**

First, sign up: https://www.brevo.com

Then get SMTP key:
```
Brevo Dashboard
  └─ Settings (⚙️ icon)
     └─ SMTP & API
        └─ Copy SMTP password
        └─ Copy API Key
```

In Railway, add:
```
[+ New Variable]
  Key:   SPRING_MAIL_HOST
  Value: smtp-relay.brevo.com

[+ New Variable]
  Key:   SPRING_MAIL_PORT
  Value: 587

[+ New Variable]
  Key:   SPRING_MAIL_USERNAME
  Value: mdsarfaraj9886@gmail.com

[+ New Variable]
  Key:   SPRING_MAIL_PASSWORD
  Value: [PASTE BREVO SMTP KEY HERE]

[+ New Variable]
  Key:   MAIL_FROM_EMAIL
  Value: noreply@nexaflow.in

[+ New Variable]
  Key:   MAIL_FROM_NAME
  Value: NexaFlow

[+ New Variable]
  Key:   BREVO_API_KEY
  Value: [PASTE BREVO API KEY HERE]

[+ New Variable]
  Key:   SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH
  Value: true

[+ New Variable]
  Key:   SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE
  Value: true
```

#### **OPTION B: Gmail (If you prefer Gmail)**

First, get App Password:
```
Gmail Account
  └─ https://myaccount.google.com/apppasswords
     └─ Select: Mail & Windows
     └─ Copy 16-character password
```

In Railway, add:
```
[+ New Variable]
  Key:   SPRING_MAIL_HOST
  Value: smtp.gmail.com

[+ New Variable]
  Key:   SPRING_MAIL_PORT
  Value: 587

[+ New Variable]
  Key:   SPRING_MAIL_USERNAME
  Value: mdsarfaraj9886@gmail.com

[+ New Variable]
  Key:   SPRING_MAIL_PASSWORD
  Value: [PASTE 16-CHAR GMAIL PASSWORD HERE]

[+ New Variable]
  Key:   MAIL_FROM_EMAIL
  Value: mdsarfaraj9886@gmail.com

[+ New Variable]
  Key:   MAIL_FROM_NAME
  Value: NexaFlow

[+ New Variable]
  Key:   SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH
  Value: true

[+ New Variable]
  Key:   SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE
  Value: true
```

---

## 📍 STEP 8: Add CORS Configuration

```
[+ New Variable]
  Key:   ALLOWED_ORIGINS
  Value: *
```

(Later, change to: `https://yourdomain.com`)

---

## 📍 STEP 9: Save & Redeploy

### Click the **[Deploy]** button

```
nexaflow-backend Service
  └─ Top right: [Deploy] button ← CLICK HERE
     └─ Wait 2-3 minutes
     └─ Check [Logs] tab for: "Started NexaFlowApplication"
```

### Progress:
```
Building... ⏳
└─ Deploying... ⏳
   └─ Running ✅
```

---

## 📍 STEP 10: Verify It's Working

### Check Logs:
```
Railway Dashboard
  └─ Logs tab
     └─ Scroll down to see latest messages
     └─ SUCCESS: "Started NexaFlowApplication in X seconds"
     └─ FAIL: "Could not connect to database" = Check DATABASE_URL
```

### Test Health Endpoint:
```
Open browser:
https://nexaflow-xxxx.railway.app/api/auth/health

Should see:
{"status":"OK"}
```

### Test Login:
```
Open browser:
Go to: https://nexaflow-xxxx.railway.app

Login with:
Email:    admin@nexaflow.in
Password: Admin@123

Success! ✅ Dashboard should load
```

---

## 🆘 TROUBLESHOOTING

### Problem: "Could not connect to database"
```
Check:
1. SPRING_DATASOURCE_URL is correct (copy from Railway MySQL Connect tab)
2. SPRING_DATASOURCE_USERNAME = root
3. SPRING_DATASOURCE_PASSWORD matches the one in URL
4. MySQL service is running (check in Railway)
```

### Problem: "Email sending failed"
```
Check:
1. SMTP credentials are correct
2. SPRING_MAIL_HOST matches (brevo: smtp-relay.brevo.com, gmail: smtp.gmail.com)
3. SPRING_MAIL_PORT is 587
4. SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH = true
5. SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE = true
6. Check Brevo/Gmail account is active
```

### Problem: "JWT errors"
```
Check:
1. JWT_SECRET is set and not empty
2. JWT_EXPIRATION_MS = 604800000 (7 days)
```

### Problem: 404 errors on endpoints
```
Check:
1. Backend URL is correct: https://nexaflow-xxxx.railway.app
2. Endpoint path is correct (starts with /api/)
3. Check Logs for "No handler found" errors
```

---

## ✅ SUCCESS CHECKLIST

- ✅ MySQL database running in Railway
- ✅ All environment variables added
- ✅ Application redeployed
- ✅ Logs show "Started NexaFlowApplication"
- ✅ Health check returns status: OK
- ✅ Can login with admin credentials
- ✅ Dashboard loads without errors
- ✅ Default users created (admin & demo)
- ✅ Database tables exist (check logs)
- ✅ (Optional) Email service working
- ✅ (Optional) Payment gateways configured

---

## 🎉 Your App is Live!

```
Production URL: https://nexaflow-xxxx.railway.app
Default Admin:  admin@nexaflow.in / Admin@123
Database:       MySQL (Railway)
Email:          Brevo or Gmail SMTP
Monitoring:     Railway Dashboard Logs
Status:         🟢 RUNNING
```

---

## 📞 Need Help?

- Railway Docs: https://railway.app/docs
- GitHub Repo: https://github.com/Mdsarfaraj07/nexaflow-backend
- Check Logs: Railway Dashboard → Your Service → Logs tab
- Common issues: See TROUBLESHOOTING section above
