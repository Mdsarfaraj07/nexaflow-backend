# PowerShell Deployment Script for NexaFlow
# Windows deployment to Railway.app
# For: Mdsarfaraj07 (mdsarfaraj9886@gmail.com)

Write-Color "
╔════════════════════════════════════════════════════════════════╗
║      NexaFlow Automated Deployment - Windows PowerShell       ║
║         GitHub: Mdsarfaraj07                                  ║
║         Email: mdsarfaraj9886@gmail.com                       ║
╚════════════════════════════════════════════════════════════════╝
" "Cyan"

# ============================================
# STEP 0: CREATE FREE ACCOUNTS (10 minutes)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 0: Create Free Accounts
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "0A. Create Railway Account (FREE)" "Cyan"
Write-Host "1. Open: https://railway.app"
Write-Host "2. Click: 'Get Started'"
Write-Host "3. Select: 'Continue with GitHub'"
Write-Host "4. Authorize Railway to access your GitHub"
Write-Host "5. Accept terms"
Write-Host ""
Read-Host "⏭️  Press Enter when Railway account is created"

Write-Host ""
Write-Color "0B. Create Brevo Email Account (FREE)" "Cyan"
Write-Host "1. Open: https://www.brevo.com/register"
Write-Host "2. Enter: mdsarfaraj9886@gmail.com"
Write-Host "3. Set: Strong password"
Write-Host "4. Verify: Email address"
Write-Host "5. Login → Settings → SMTP & API"
Write-Host "6. Generate: SMTP Password"
Write-Host "7. SAVE: This password (you'll need it!)"
Write-Host ""
Read-Host "⏭️  Press Enter when Brevo SMTP password is saved"

# ============================================
# STEP 1: SETUP GIT & PUSH CODE (3 minutes)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 1: Configure Git & Push Code to GitHub
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "Setting up Git..." "Green"

# Navigate to project
cd "d:\adminpanel\nexaflow-backend-complete"

# Configure Git
git config --global user.name "Md Sarfaraj"
git config --global user.email "mdsarfaraj9886@gmail.com"

# Initialize and commit
Write-Host "Initializing repository..."
git init | Out-Null
git add . | Out-Null
git commit -m "NexaFlow v3.0 - Production Ready on Railway" 2>$null

# Remove existing remote
git remote remove origin 2>$null

# Add new remote
git remote add origin https://github.com/Mdsarfaraj07/nexaflow.git

Write-Host ""
Write-Color "Pushing code to GitHub..." "Green"
Write-Host "Note: Git may open a browser for authentication"
Write-Host ""

git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Color "✓ Code pushed to GitHub successfully!" "Green"
} else {
    Write-Color "✗ Failed to push. Make sure:" "Red"
    Write-Host "  - Your GitHub account is logged in"
    Write-Host "  - You have internet connection"
    Write-Host "  - Repository nexaflow exists"
    exit 1
}

Read-Host ""

# ============================================
# STEP 2: CONNECT RAILWAY & ADD MYSQL (5 minutes)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 2: Connect Railway to GitHub Repository
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "Follow these steps in Railway Dashboard:" "Cyan"
Write-Host "1. Open: https://railway.app/dashboard"
Write-Host "2. Click: '+ New Project' (top left)"
Write-Host "3. Select: 'Deploy from GitHub repo'"
Write-Host "4. If prompted: Authorize Railway with GitHub"
Write-Host "5. Click: 'nexaflow' repository"
Write-Host "6. Railway will start building automatically"
Write-Host ""

Read-Host "⏭️  Press Enter when Railway shows 'Building...' status"

Write-Host ""
Write-Color "Adding MySQL Database:" "Cyan"
Write-Host "1. In Railway Dashboard"
Write-Host "2. Click: '+ Add' button (top bar)"
Write-Host "3. Search: 'MySQL'"
Write-Host "4. Click: 'Add MySQL'"
Write-Host "5. Wait: 2-3 minutes for MySQL to initialize"
Write-Host "6. You should see: 'mysql' service in dashboard"
Write-Host ""

Read-Host "⏭️  Press Enter when MySQL shows as running"

# ============================================
# STEP 3: ENVIRONMENT VARIABLES (5 minutes)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 3: Configure Environment Variables
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "In Railway Dashboard, click 'Variables' tab and add:" "Cyan"
Write-Host ""

Write-Color "Database Configuration:" "Green"
Write-Host "DB_HOST=mysql"
Write-Host "DB_PORT=3306"
Write-Host "DB_NAME=nexaflow_db"
Write-Host "DB_USER=nexaflow"
Write-Host "DB_PASS=SecurePassword123!@#"
Write-Host "DB_ROOT_PASSWORD=RootPassword123!@#"
Write-Host ""

Write-Color "Backend Configuration:" "Green"
Write-Host "SPRING_PROFILES_ACTIVE=railway"
Write-Host "PORT=8080"
Write-Host "JWT_SECRET=GenerateRandomString32CharsMinimumLength1234567890"
Write-Host "CORS_ALLOWED_ORIGINS=*"
Write-Host "DEFAULT_USD_TO_INR=83.5"
Write-Host ""

Write-Color "Email Configuration (from Brevo):" "Green"
Write-Host "MAIL_HOST=smtp-relay.brevo.com"
Write-Host "MAIL_PORT=587"
Write-Host "MAIL_USERNAME=[your-brevo-sender-email]"
Write-Host "MAIL_PASSWORD=[your-brevo-smtp-password-from-step-0]"
Write-Host "MAIL_FROM=noreply@nexaflow.com"
Write-Host ""

Write-Color "Frontend Configuration:" "Green"
Write-Host "BACKEND_URL=https://your-railway-url.railway.app"
Write-Host "APP_URL=https://your-railway-url.railway.app"
Write-Host "FRONTEND_PORT=3000"
Write-Host "NODE_ENV=production"
Write-Host ""

Write-Color "⚠️  IMPORTANT:" "Yellow"
Write-Host "  - Replace [your-brevo-sender-email] with your email"
Write-Host "  - Replace [your-brevo-smtp-password] from Brevo"
Write-Host "  - Generate random 32+ char string for JWT_SECRET"
Write-Host ""

Read-Host "⏭️  Press Enter after saving ALL variables in Railway"

# ============================================
# STEP 4: TRIGGER DEPLOYMENT (3 minutes)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 4: Trigger Deployment
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "Pushing deployment trigger..." "Green"

git commit --allow-empty -m "Trigger Railway deployment"
git push origin main

Write-Host ""
Write-Color "✓ Deployment triggered!" "Green"
Write-Host ""
Write-Host "Railway is now building your application..."
Write-Host "This may take 5-10 minutes"
Write-Host ""

# ============================================
# STEP 5: MONITOR BUILD (Real-time)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 5: Monitor Deployment
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "✓ Open your Railway Dashboard:" "Cyan"
Write-Host "  https://railway.app/dashboard"
Write-Host ""
Write-Host "✓ Click your project"
Write-Host "✓ Click 'Deployments' tab"
Write-Host "✓ Watch the build progress"
Write-Host ""
Write-Host "You should see:"
Write-Host "  BUILD PROGRESS:"
Write-Host "  ├── Building Docker image... (yellow ⏳)"
Write-Host "  ├── Deploying... (blue 🔵)"
Write-Host "  └── ✓ Success (green ✅)"
Write-Host ""
Write-Host "Once complete, you'll see your URL:"
Write-Host "  https://nexaflow-xxxx.railway.app"
Write-Host ""

Read-Host "⏭️  Press Enter when deployment is COMPLETE (green ✓)"

# ============================================
# STEP 6: VERIFY DEPLOYMENT (2 minutes)
# ============================================

Write-Color "
═══════════════════════════════════════════════════════════════
 STEP 6: Verify Your Application
═══════════════════════════════════════════════════════════════" "Yellow"

Write-Host ""
Write-Color "Testing your Live Application:" "Cyan"
Write-Host ""
Write-Host "1. Your app URL: https://nexaflow-xxxx.railway.app"
Write-Host "   (Replace xxxx with your Railway domain)"
Write-Host ""
Write-Host "2. Test login with default credentials:"
Write-Host "   Email: admin@nexaflow.in"
Write-Host "   Password: Admin@123"
Write-Host ""
Write-Host "3. Verify these features work:"
Write-Host "   ✓ Dashboard loads without errors"
Write-Host "   ✓ Can see services list"
Write-Host "   ✓ Can view bookings"
Write-Host "   ✓ Can create a new booking"
Write-Host ""
Write-Host "4. Check email notification:"
Write-Host "   - Create a booking"
Write-Host "   - Check your email for confirmation"
Write-Host "   - Should arrive within 30 seconds"
Write-Host ""

Read-Host "⏭️  Press Enter after verifying all features work"

# ============================================
# COMPLETION
# ============================================

Write-Color "
╔════════════════════════════════════════════════════════════════╗
║            ✅ DEPLOYMENT SUCCESSFUL!                          ║
║                                                                ║
║  Your NexaFlow is now LIVE on Railway.app! 🚀                 ║
║                                                                ║
║  You deployed:                                                 ║
║  ✓ Backend Spring Boot API (8080)                             ║
║  ✓ Frontend Node.js Server (3000)                             ║
║  ✓ MySQL Database                                             ║
║  ✓ Brevo Email Service                                        ║
╚════════════════════════════════════════════════════════════════╝
" "Green"

Write-Host ""
Write-Color "📊 YOUR DEPLOYMENT SUMMARY:" "Yellow"
Write-Host "────────────────────────────────────────────────────────────────"
Write-Host "GitHub Repo: https://github.com/Mdsarfaraj07/nexaflow"
Write-Host "Railway Dashboard: https://railway.app/dashboard"
Write-Host "Your Live App: https://nexaflow-xxxx.railway.app"
Write-Host "Database: MySQL on Railway"
Write-Host "Email: Brevo SMTP"
Write-Host ""

Write-Color "🔐 IMPORTANT - CHANGE DEFAULT PASSWORD:" "Red"
Write-Host "────────────────────────────────────────────────────────────────"
Write-Host "1. Login with: admin@nexaflow.in / Admin@123"
Write-Host "2. Go to: Settings → Change Password"
Write-Host "3. Set a NEW strong password"
Write-Host "4. Save changes"
Write-Host ""

Write-Color "💡 NEXT STEPS:" "Cyan"
Write-Host "────────────────────────────────────────────────────────────────"
Write-Host "1. Test all features (bookings, payments, emails)"
Write-Host "2. Add custom domain (optional, in Railway Settings)"
Write-Host "3. Configure Razorpay/Stripe (optional, for payments)"
Write-Host "4. Setup regular backups"
Write-Host "5. Monitor application in Railway Logs"
Write-Host ""

Write-Color "📚 USEFUL LINKS:" "Cyan"
Write-Host "────────────────────────────────────────────────────────────────"
Write-Host "Railway Dashboard: https://railway.app/dashboard"
Write-Host "Railway Documentation: https://railway.app/docs"
Write-Host "Brevo SMTP Setup: https://www.brevo.com/settings"
Write-Host "GitHub Repository: https://github.com/Mdsarfaraj07/nexaflow"
Write-Host ""

Write-Color "🎉 Congratulations! Your application is now LIVE! 🎉" "Green"
Write-Host ""

Start-Process "https://railway.app/dashboard"
