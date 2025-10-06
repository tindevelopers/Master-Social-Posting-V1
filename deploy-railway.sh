#!/bin/bash

# Railway Deployment Script for Postiz
# This script helps you deploy Postiz to Railway

set -e

echo "🚂 Railway Deployment Script for Postiz"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${RED}❌ Railway CLI is not installed${NC}"
    echo "Install it with: npm install -g @railway/cli"
    exit 1
fi

echo -e "${GREEN}✅ Railway CLI is installed${NC}"

# Check if logged in
if ! railway whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Railway${NC}"
    echo "Please run: railway login"
    exit 1
fi

echo -e "${GREEN}✅ Logged in to Railway${NC}"
railway whoami
echo ""

# Check current project status
echo -e "${BLUE}📊 Current Railway Status:${NC}"
railway status
echo ""

# Check if we're on the right branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "railway-cloud-deploy" ]; then
    echo -e "${YELLOW}⚠️  Warning: You're on branch '$CURRENT_BRANCH'${NC}"
    echo "Recommended branch: railway-cloud-deploy"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${GREEN}✅ On branch: $CURRENT_BRANCH${NC}"
echo ""

# Project info
echo -e "${BLUE}📦 Project Information:${NC}"
echo "Project: postiz-master-social"
echo "URL: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01"
echo ""

echo -e "${YELLOW}📝 Next Steps (Manual):${NC}"
echo ""
echo "1. Open Railway Dashboard:"
echo "   https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01"
echo ""
echo "2. Create a new service:"
echo "   - Click 'New' → 'GitHub Repo'"
echo "   - Select this repository"
echo "   - Choose branch: railway-cloud-deploy"
echo ""
echo "3. Configure the service:"
echo "   - Go to Settings → Port: 5000"
echo "   - Health Check Path: /api/health"
echo "   - Health Check Timeout: 300"
echo "   - Enable Public Networking"
echo ""
echo "4. Set Environment Variables (Variables tab):"
echo "   Copy from env.railway.example and update:"
echo ""
echo "   Required variables:"
echo "   - DATABASE_URL (from Postgres service)"
echo "   - REDIS_URL (from Redis service)"
echo "   - JWT_SECRET (generate a random string)"
echo "   - FRONTEND_URL (your Railway domain)"
echo "   - NEXT_PUBLIC_BACKEND_URL (your Railway domain/api)"
echo "   - CLOUDFLARE_* (your Cloudflare R2 credentials)"
echo "   - IS_GENERAL=true"
echo "   - NODE_ENV=production"
echo ""
echo "5. Deploy:"
echo "   Railway will automatically deploy after setting variables"
echo ""
echo -e "${GREEN}📚 Documentation:${NC}"
echo "   - Quick Start: RAILWAY_QUICKSTART.md"
echo "   - Full Guide: RAILWAY_DEPLOYMENT.md"
echo ""
echo -e "${BLUE}💡 Tip:${NC} After deployment, update FRONTEND_URL and NEXT_PUBLIC_BACKEND_URL"
echo "   with your actual Railway domain"
echo ""
