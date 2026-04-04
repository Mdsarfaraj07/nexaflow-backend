# Railway Variables - COPY & PASTE FORMAT

## Quick Copy for Railway Dashboard

Click "Variables" tab → "+ New Variable" → Copy each line below

---

## MANDATORY VARIABLES (Must Add)

```
SERVER_PORT=8080
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
JWT_SECRET=NexaFlow@SecureKey#Production2024#SecureKey12345
JWT_EXPIRATION_MS=604800000
ALLOWED_ORIGINS=*
SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH=true
SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE=true
```

---

## DATABASE VARIABLES (From Railway MySQL Service)

⚠️ **IMPORTANT:** Get these from Railway → MySQL Service → Connect tab

Replace `ABC123`, `host`, and `port` with actual Railway values:

```
SPRING_DATASOURCE_URL=mysql://root:ABC123@containers-us-west-98.railway.app:6632/railway
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=ABC123
```

---

## EMAIL VARIABLES (Choose ONE Option)

### Option 1: BREVO (Recommended - Free 300/day)

Sign up: https://www.brevo.com
Get keys from: Settings → SMTP & API

```
SPRING_MAIL_HOST=smtp-relay.brevo.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=mdsarfaraj9886@gmail.com
SPRING_MAIL_PASSWORD=PASTE_BREVO_SMTP_KEY_HERE
MAIL_FROM_EMAIL=noreply@nexaflow.in
MAIL_FROM_NAME=NexaFlow
BREVO_API_KEY=PASTE_BREVO_API_KEY_HERE
```

### Option 2: GMAIL (If you prefer Gmail)

Get App Password: https://myaccount.google.com/apppasswords

```
SPRING_MAIL_HOST=smtp.gmail.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=mdsarfaraj9886@gmail.com
SPRING_MAIL_PASSWORD=PASTE_16_CHAR_GMAIL_PASSWORD_HERE
MAIL_FROM_EMAIL=mdsarfaraj9886@gmail.com
MAIL_FROM_NAME=NexaFlow
```

---

## OPTIONAL: PAYMENT GATEWAYS

### Razorpay (For India customers)

Get keys: https://dashboard.razorpay.com/settings/api-keys
Test keys start with `rzp_test_`

```
RAZORPAY_KEY_ID=rzp_test_PASTE_HERE
RAZORPAY_KEY_SECRET=PASTE_HERE
RAZORPAY_ENABLED=true
```

### Stripe (For International customers)

Get keys: https://dashboard.stripe.com/apikeys
Test keys start with `sk_test_` and `pk_test_`

```
STRIPE_API_KEY=sk_test_PASTE_HERE
STRIPE_PUBLISHABLE_KEY=pk_test_PASTE_HERE
STRIPE_ENABLED=true
```

---

## STEP BY STEP IN RAILWAY

1. Go to: https://railway.app/dashboard
2. Click your **nexaflow-backend** project
3. Click the service name
4. Go to **"Variables"** tab
5. For each variable above:
   - Click **"+ New Variable"**
   - Enter Key (left side)
   - Enter Value (right side)
   - Press Enter

6. After ALL variables added → Click **"Deploy"**
7. Wait 2-3 minutes for deployment
8. Check **"Logs"** tab - should see: `Started NexaFlowApplication`

---

## TEST YOUR SETUP

After deployment, test these URLs:

1. **Health Check (should return "OK"):**
   ```
   https://nexaflow-xxxx.railway.app/api/auth/health
   ```

2. **Login (should return JWT token):**
   - Email: `admin@nexaflow.in`
   - Password: `Admin@123`

3. **Dashboard:**
   ```
   https://nexaflow-xxxx.railway.app
   ```

---

## COMMON MISTAKES ❌

- ❌ Not adding DATABASE URL - App won't connect to database
- ❌ Wrong SMTP password - Emails won't send
- ❌ Missing JWT_SECRET - Authentication will fail
- ❌ Database URL with single backslashes instead of `://` separators
- ❌ Forgetting to REDEPLOY after adding variables

---

## SUCCESS INDICATORS ✅

- ✅ No errors in Logs
- ✅ Health check returns `{"status":"OK"}`
- ✅ Can login with admin credentials
- ✅ Dashboard loads without errors
- ✅ Can see database tables (email test)

---

Need help? Check logs in Railway → Logs tab → scroll for error messages

