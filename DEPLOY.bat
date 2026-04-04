@echo off
REM NexaFlow Deployment Script for Railway.app
REM For: Mdsarfaraj07 (mdsarfaraj9886@gmail.com)

cls
echo.
echo ============================================================
echo  NexaFlow Automated Deployment - Railway.app
echo  GitHub: Mdsarfaraj07
echo  Email: mdsarfaraj9886@gmail.com
echo ============================================================
echo.

REM STEP 1: Create Railway Account
echo ============================================================
echo STEP 1: Create Free Railway Account
echo ============================================================
echo.
echo 1. Open browser: https://railway.app
echo 2. Click: 'Get Started'
echo 3. Select: 'Continue with GitHub'
echo 4. Authorize Railway
echo 5. Accept terms
echo.
pause

REM STEP 2: Create Brevo Account
echo.
echo ============================================================
echo STEP 2: Create Free Brevo Email Account
echo ============================================================
echo.
echo 1. Open browser: https://www.brevo.com/register
echo 2. Enter email: mdsarfaraj9886@gmail.com
echo 3. Create password
echo 4. Verify email
echo 5. Login - Settings - SMTP and API
echo 6. Copy SMTP Password
echo 7. SAVE THIS PASSWORD!!!
echo.
pause

REM STEP 3: Configure Git
echo.
echo ============================================================
echo STEP 3: Configure Git and Push Code
echo ============================================================
echo.

cd /d d:\adminpanel\nexaflow-backend-complete

echo Configuring Git...
git config --global user.name "Md Sarfaraj"
git config --global user.email "mdsarfaraj9886@gmail.com"

echo Initializing repository...
git init
git add .
git commit -m "NexaFlow v3.0 - Production Ready on Railway" 2>nul

git remote remove origin 2>nul
git remote add origin https://github.com/Mdsarfaraj07/nexaflow.git

echo Pushing code to GitHub...
git branch -M main
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS: Code pushed to GitHub!
) else (
    echo.
    echo ERROR: Failed to push to GitHub
    echo Check your GitHub credentials
)

echo.
pause

REM STEP 4: Connect Railway
echo.
echo ============================================================
echo STEP 4: Connect Railway to GitHub
echo ============================================================
echo.
echo 1. Go to: https://railway.app/dashboard
echo 2. Click: + New Project
echo 3. Select: Deploy from GitHub repo
echo 4. If prompted: Authorize Railway with GitHub
echo 5. Click: nexaflow repository
echo 6. Railway will auto-start building
echo.
pause

REM STEP 5: Add MySQL
echo.
echo ============================================================
echo STEP 5: Add MySQL Database
echo ============================================================
echo.
echo 1. In Railway Dashboard, click: + Add button
echo 2. Search: MySQL
echo 3. Click: MySQL - Add
echo 4. Wait 2-3 minutes for MySQL to start
echo.
pause

REM STEP 6: Environment Variables
echo.
echo ============================================================
echo STEP 6: Set Environment Variables
echo ============================================================
echo.
echo In Railway Dashboard, click 'Variables' tab:
echo.
echo DATABASE CONFIGURATION:
echo DB_HOST=mysql
echo DB_PORT=3306
echo DB_NAME=nexaflow_db
echo DB_USER=nexaflow
echo DB_PASS=SecurePassword123!@#
echo DB_ROOT_PASSWORD=RootPassword123!@#
echo.
echo BACKEND CONFIGURATION:
echo SPRING_PROFILES_ACTIVE=railway
echo PORT=8080
echo JWT_SECRET=GenerateRandomString32CharsMinimumLength1234567890
echo CORS_ALLOWED_ORIGINS=*
echo DEFAULT_USD_TO_INR=83.5
echo.
echo EMAIL CONFIGURATION:
echo MAIL_HOST=smtp-relay.brevo.com
echo MAIL_PORT=587
echo MAIL_USERNAME=[your-brevo-email]
echo MAIL_PASSWORD=[your-brevo-SMTP-password]
echo MAIL_FROM=noreply@nexaflow.com
echo.
echo FRONTEND CONFIGURATION:
echo BACKEND_URL=https://your-railway-url.railway.app
echo APP_URL=https://your-railway-url.railway.app
echo FRONTEND_PORT=3000
echo NODE_ENV=production
echo.
pause

REM STEP 7: Trigger Deployment
echo.
echo ============================================================
echo STEP 7: Trigger Deployment
echo ============================================================
echo.

git commit --allow-empty -m "Trigger Railway deployment"
git push origin main

echo.
echo Deployment triggered! Railway is building...
echo This may take 5-10 minutes
echo.
pause

REM STEP 8: Monitor
echo.
echo ============================================================
echo STEP 8: Monitor Deployment
echo ============================================================
echo.
echo Open Railway Dashboard: https://railway.app/dashboard
echo.
echo Watch for:
echo - Build Progress (should turn green)
echo - Deployment Status (should say Success)
echo - Your Live URL (https://nexaflow-xxxx.railway.app)
echo.

start https://railway.app/dashboard

pause

REM STEP 9: Verify
echo.
echo ============================================================
echo STEP 9: Verify Your Application
echo ============================================================
echo.
echo Test your live app:
echo 1. Open your app URL (from Railway Dashboard)
echo 2. Login with:
echo    Email: admin@nexaflow.in
echo    Password: Admin@123
echo 3. Check dashboard loads
echo 4. Create a test booking
echo 5. Verify email notification
echo.

REM Completion
echo.
echo ============================================================
echo SUCCESS: Your NexaFlow is LIVE on Railway! 
echo ============================================================
echo.
echo GitHub Repo: https://github.com/Mdsarfaraj07/nexaflow
echo Railway Dashboard: https://railway.app/dashboard
echo Your App: https://nexaflow-xxxx.railway.app
echo.
echo IMPORTANT: Change default password immediately!
echo Login: admin@nexaflow.in / Admin@123
echo Go to: Settings - Change Password
echo.
echo Congratulations! Your app is now LIVE! 
echo.
pause
