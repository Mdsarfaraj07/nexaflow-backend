#!/bin/bash
# 🚀 NexaFlow Railway Deployment Script
# Automates the deployment process to Railway

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║     NexaFlow - Railway Deployment Automation Script          ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${RED}❌ Railway CLI not found!${NC}"
    echo "Install from: https://docs.railway.app/develop/cli"
    echo ""
    echo "Quick install:"
    echo "  Windows: npm install -g railway"
    echo "  macOS/Linux: curl -fsSL railway.app/install.sh | bash"
    exit 1
fi

echo -e "${GREEN}✅ Railway CLI detected${NC}"
echo ""

# Check git status
echo -e "${YELLOW}📋 Checking git status...${NC}"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  You have uncommitted changes${NC}"
    echo "Commit all changes before deploying:"
    echo "  git add ."
    echo "  git commit -m 'Your message'"
    echo "  git push origin main"
    exit 1
fi

echo -e "${GREEN}✅ Git status clean${NC}"
echo ""

# Push to GitHub
echo -e "${YELLOW}📤 Pushing to GitHub...${NC}"
git push origin main
echo -e "${GREEN}✅ Pushed to GitHub${NC}"
echo ""

# Login to Railway
echo -e "${YELLOW}🔐 Logging in to Railway...${NC}"
railway login

echo ""
echo -e "${GREEN}✅ Deployment ready!${NC}"
echo ""
echo "Next steps:"
echo "1. Go to: https://railway.app/dashboard"
echo "2. Create NEW project"
echo "3. Select: Deploy from GitHub"
echo "4. Choose: Mdsarfaraj07/nexaflow-backend"
echo "5. Add environment variables (see RAILWAY_DEPLOYMENT_SETUP.md)"
echo "6. Deploy!"
echo ""
echo "For automated deployment, use:"
echo "  railway up"
echo ""
