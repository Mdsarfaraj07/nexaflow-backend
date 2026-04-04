#!/bin/bash
# NexaFlow Deployment Checklist for Railway.app
# ================================================

# COLORS for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}
╔════════════════════════════════════════════════════════════════╗
║       NexaFlow Railway Deployment Checklist v3.0               ║
║     Complete verification before going live in production      ║
╚════════════════════════════════════════════════════════════════╝
${NC}"

# Counter for completed items
COMPLETED=0
TOTAL=25

# Function to check item
check_item() {
  local item_num=$1
  local description=$2
  local command=$3
  
  echo -e "\n${YELLOW}[$item_num/25]${NC} $description"
  read -p "    ✓ Done? (y/n): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "    ${GREEN}✓ Complete${NC}"
    ((COMPLETED++))
  else
    echo -e "    ${RED}✗ Pending${NC}"
  fi
}

# ================================================
# PRE-DEPLOYMENT CHECKLIST
# ================================================

echo -e "${BLUE}
═══════════════════════════════════════════════════════════════
 PHASE 1: LOCAL VERIFICATION
═══════════════════════════════════════════════════════════════${NC}"

check_item 1 "Backend compiles without errors" "mvn clean install -U"
check_item 2 "Frontend npm packages installed" "npm install in frontend dir"
check_item 3 "Backend runs locally on :8080" ""
check_item 4 "Frontend runs locally on :3000" ""
check_item 5 "Database connection verified (H2/MySQL)" ""
check_item 6 "Default credentials work (admin/client)" ""
check_item 7 "API endpoints respond (HTTP 200)" ""

echo -e "${BLUE}
═══════════════════════════════════════════════════════════════
 PHASE 2: CONFIGURATION SETUP
═══════════════════════════════════════════════════════════════${NC}"

check_item 8 "Brevo email credentials obtained" ""
check_item 9 "Razorpay API keys configured (optional)" ""
check_item 10 "Stripe API keys configured (optional)" ""
check_item 11 "JWT_SECRET generated (32+ characters)" ""
check_item 12 "Database password created (strong)" ""
check_item 13 "CORS_ALLOWED_ORIGINS configured" ""

echo -e "${BLUE}
═════════════════════════════════════════════════════════════════
 PHASE 3: GITHUB & RAILWAY SETUP
═════════════════════════════════════════════════════════════════${NC}"

check_item 14 "Code committed to GitHub (main branch)" ""
check_item 15 "Railway.app account created" ""
check_item 16 "GitHub repository connected to Railway" ""
check_item 17 "MySQL plugin added to Railway project" ""

echo -e "${BLUE}
═════════════════════════════════════════════════════════════════
 PHASE 4: ENVIRONMENT VARIABLES on RAILWAY
═════════════════════════════════════════════════════════════════${NC}"

check_item 18 "DB_HOST, DB_PORT, DB_NAME set" ""
check_item 19 "JWT_SECRET & security variables set" ""
check_item 20 "Email (MAIL_*) variables configured" ""
check_item 21 "BACKEND_URL & APP_URL set for frontend" ""
check_item 22 "All optional payment keys added (if using)" ""

echo -e "${BLUE}
═════════════════════════════════════════════════════════════════
 PHASE 5: DEPLOYMENT & VERIFICATION
═════════════════════════════════════════════════════════════════${NC}"

check_item 23 "Application deployed successfully on Railway" ""
check_item 24 "Backend API responsive (health check)" ""
check_item 25 "Frontend loads without errors" ""

# Summary
echo -e "${BLUE}
═════════════════════════════════════════════════════════════════
 DEPLOYMENT SUMMARY
═════════════════════════════════════════════════════════════════${NC}"

PERCENTAGE=$((COMPLETED * 100 / TOTAL))
echo -e "Completed: ${GREEN}$COMPLETED/$TOTAL${NC} items ($PERCENTAGE%)"

if [ $COMPLETED -eq $TOTAL ]; then
  echo -e "\n${GREEN}
╔════════════════════════════════════════════════════════════════╗
║         ✓ ALL CHECKS COMPLETE - READY FOR PRODUCTION!          ║
║                  Your app is live on Railway! 🚀               ║
╚════════════════════════════════════════════════════════════════╝
${NC}"

  echo -e "
${YELLOW}NEXT STEPS:${NC}
1. Access your application: https://your-app.railway.app
2. Monitor logs: Railway Dashboard → Logs
3. Set up custom domain: Railway Dashboard → Custom Domain
4. Configure SSL certificate: Railway auto-handles this
5. Test all features thoroughly
6. Set up monitoring & alerts
7. Document API for frontend team

${YELLOW}PRODUCTION CHECKLIST:${NC}
✓ Backup database regularly
✓ Monitor server performance
✓ Set up error alerts
✓ Review security settings
✓ Update dependencies monthly
✓ Monitor payment gateway transactions
✓ Check spam folder for sent emails
"
else
  echo -e "\n${RED}
⚠️  Some tasks are incomplete.
Please complete all items before deploying to production!
${NC}"
fi

echo -e "
${BLUE}═════════════════════════════════════════════════════════════════${NC}
Documentation: RAILWAY_DEPLOYMENT_GUIDE.md
${BLUE}═════════════════════════════════════════════════════════════════${NC}
"
