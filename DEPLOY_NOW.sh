# 🚀 NexaFlow Automated Deployment - Your Account Setup
# Complete step-by-step deployment for mdsarfaraj9886@gmail.com
# GitHub: Mdsarfaraj07

# ============================================
# STEP 1: CREATE FREE ACCOUNTS (5 minutes)
# ============================================

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        NexaFlow Automated Deployment Setup                     ║"
echo "║          GitHub: Mdsarfaraj07                                 ║"
echo "║          Email: mdsarfaraj9886@gmail.com                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1A: Create Railway Account
echo "STEP 1A: Create Railway Account (FREE)"
echo "════════════════════════════════════════════════"
echo "1. Open browser: https://railway.app"
echo "2. Click 'Get Started'"
echo "3. Sign up with GitHub (click GitHub button)"
echo "4. Authorize Railway to access GitHub"
echo "5. ✓ Railway account created!"
echo ""
echo "⏯️  Press any key when Railway account is created..."
read -n 1

# Step 1B: Create Brevo Account
echo ""
echo "STEP 1B: Create Brevo Email Account (FREE)"
echo "════════════════════════════════════════════════"
echo "1. Open browser: https://www.brevo.com/register"
echo "2. Enter email: mdsarfaraj9886@gmail.com"
echo "3. Create strong password"
echo "4. Go to Settings → SMTP & API"
echo "5. Copy SMTP Password (save it somewhere!)"
echo "6. ✓ Brevo account created!"
echo ""
echo "⏯️  Press any key when Brevo SMTP password is ready..."
read -n 1

# ============================================
# STEP 2: SETUP GIT AND PUSH CODE (3 minutes)
# ============================================

echo ""
echo "STEP 2: Configure Git and Push Code"
echo "════════════════════════════════════════════════"

cd "d:\adminpanel\nexaflow-backend-complete"

# Configure Git with your details
git config --global user.name "Md Sarfaraj"
git config --global user.email "mdsarfaraj9886@gmail.com"

# Initialize repository
git init
git add .
git commit -m "NexaFlow v3.0 - Production Ready on Railway"

# Add remote (using HTTPS - no SSH key needed)
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/Mdsarfaraj07/nexaflow.git

# Push to GitHub
echo ""
echo "🔓 You will be prompted for GitHub credentials..."
echo "   - Username: Mdsarfaraj07"
echo "   - Password: <your GitHub personal access token or password>"
echo ""
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
  echo "✓ Code pushed to GitHub successfully!"
else
  echo "✗ Push failed. Check credentials and try again."
  exit 1
fi

# ============================================
# STEP 3: CONNECT RAILWAY TO GITHUB (2 minutes)
# ============================================

echo ""
echo "STEP 3: Connect Railway to GitHub Repository"
echo "════════════════════════════════════════════════"
echo ""
echo "1. Go to: https://railway.app/dashboard"
echo "2. Click: '+ New Project'"
echo "3. Select: 'Deploy from GitHub repo'"
echo "4. Authorize Railway with GitHub (if prompted)"
echo "5. Find and select: 'nexaflow' repository"
echo "6. Railway will auto-detect Dockerfile and start building"
echo "7. ✓ Repository connected!"
echo ""
echo "⏯️  Press any key when Railway project is created..."
read -n 1

# ============================================
# STEP 4: ADD MYSQL DATABASE (2 minutes)
# ============================================

echo ""
echo "STEP 4: Add MySQL Database to Railway"
echo "════════════════════════════════════════════════"
echo ""
echo "1. In Railway Dashboard"
echo "2. Click: '+ Add' button (top right)"
echo "3. Search: 'MySQL'"
echo "4. Click: 'MySQL' → 'Add'"
echo "5. Wait 2-3 minutes for MySQL to start"
echo "6. ✓ MySQL database added!"
echo ""
echo "⏯️  Press any key when MySQL is running in Railway..."
read -n 1

# ============================================
# STEP 5: CONFIGURE ENVIRONMENT VARIABLES (5 minutes)
# ============================================

echo ""
echo "STEP 5: Set Environment Variables on Railway"
echo "════════════════════════════════════════════════"
echo ""
echo "1. In Railway Dashboard → Your Project"
echo "2. Click: 'Variables' tab"
echo "3. Add each variable below (copy-paste):"
echo ""
echo "────────────────────────────────────────"
echo "DATABASE CONFIGURATION:"
echo "────────────────────────────────────────"
echo "DB_HOST=mysql"
echo "DB_PORT=3306"
echo "DB_NAME=nexaflow_db"
echo "DB_USER=nexaflow"
echo "DB_PASS=SecurePass123!@#"
echo "DB_ROOT_PASSWORD=RootPass123!@#"
echo ""
echo "────────────────────────────────────────"
echo "BACKEND CONFIGURATION:"
echo "────────────────────────────────────────"
echo "SPRING_PROFILES_ACTIVE=railway"
echo "PORT=8080"
echo "JWT_SECRET=SuperSecretJWTKey32CharactersLongRandom1234"
echo "CORS_ALLOWED_ORIGINS=*"
echo "DEFAULT_USD_TO_INR=83.5"
echo ""
echo "────────────────────────────────────────"
echo "EMAIL CONFIGURATION (from Brevo):"
echo "────────────────────────────────────────"
echo "MAIL_HOST=smtp-relay.brevo.com"
echo "MAIL_PORT=587"
echo "MAIL_USERNAME=<your-brevo-sender-email>"
echo "MAIL_PASSWORD=<your-brevo-SMTP-password>"
echo "MAIL_FROM=noreply@nexaflow.com"
echo ""
echo "────────────────────────────────────────"
echo "FRONTEND CONFIGURATION:"
echo "────────────────────────────────────────"
echo "BACKEND_URL=https://nexaflow-xxx.railway.app"
echo "APP_URL=https://nexaflow-xxx.railway.app"
echo "FRONTEND_PORT=3000"
echo "NODE_ENV=production"
echo ""
echo "⚠️  NOTE: Replace these with actual values:"
echo "    - MAIL_USERNAME: Your Brevo email"
echo "    - MAIL_PASSWORD: Your Brevo SMTP password"
echo "    - JWT_SECRET: Generate random 32+ char string"
echo ""
echo "⏯️  Press any key after setting ALL variables in Railway..."
read -n 1

# ============================================
# STEP 6: DEPLOY (3 minutes)
# ============================================

echo ""
echo "STEP 6: Trigger Deployment"
echo "════════════════════════════════════════════════"
echo ""
echo "Option A (Automatic): Push code change"
git commit --allow-empty -m "Trigger Railway deployment"
git push origin main

echo ""
echo "✓ Deployment triggered! Railway is building..."
echo ""
echo "CHECK DEPLOYMENT STATUS:"
echo "1. Go to: https://railway.app/dashboard"
echo "2. Click your project"
echo "3. Click: 'Deployments' tab"
echo "4. Watch the build progress (should be green ✓)"
echo "5. Once deployed, you'll see: 'https://nexaflow-xxxx.railway.app'"
echo ""
echo "⏯️  Press any key after deployment is complete (green ✓)..."
read -n 1

# ============================================
# STEP 7: VERIFY DEPLOYMENT (2 minutes)
# ============================================

echo ""
echo "STEP 7: Verify Your Deployed Application"
echo "════════════════════════════════════════════════"
echo ""
echo "1. Open your app in browser:"
echo "   URL shown in Railway Dashboard (https://nexaflow-xxxx.railway.app)"
echo ""
echo "2. Test Login with:"
echo "   - Email: admin@nexaflow.in"
echo "   - Password: Admin@123"
echo ""
echo "3. Check these work:"
echo "   ✓ Dashboard loads"
echo "   ✓ Can see services"
echo "   ✓ Can create booking"
echo "   ✓ Email notification received"
echo ""

# ============================================
# COMPLETION
# ============================================

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║            ✅ DEPLOYMENT COMPLETE!                            ║"
echo "║                                                                ║"
echo "║  Your NexaFlow application is now LIVE on Railway! 🚀         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 DEPLOYMENT SUMMARY:"
echo "────────────────────────────────────────────────────────────────"
echo "✓ GitHub: https://github.com/Mdsarfaraj07/nexaflow"
echo "✓ Railway: https://railway.app/dashboard"
echo "✓ Your App: https://nexaflow-xxxx.railway.app"
echo "✓ Email: Brevo SMTP configured"
echo "✓ Database: MySQL on Railway"
echo ""
echo "🔐 FIRST LOGIN - IMPORTANT!"
echo "────────────────────────────────────────────────────────────────"
echo "1. Login with: admin@nexaflow.in / Admin@123"
echo "2. ⚠️  CHANGE THIS PASSWORD IMMEDIATELY!"
echo "3. Settings → Change Password"
echo ""
echo "💡 NEXT STEPS:"
echo "────────────────────────────────────────────────────────────────"
echo "1. Test all features"
echo "2. Add custom domain (optional)"
echo "3. Configure payment gateways (optional)"
echo "4. Setup backups"
echo "5. Monitor application logs"
echo ""
echo "📚 DOCUMENTATION:"
echo "────────────────────────────────────────────────────────────────"
echo "RAILWAY_QUICKSTART.md - What you just did"
echo "RAILWAY_DEPLOYMENT_GUIDE.md - Detailed reference"
echo "DEPLOYMENT_CREDENTIALS_GUIDE.md - Advanced setup"
echo ""
echo "🎉 Congratulations! Your app is now live! 🎉"
echo ""
