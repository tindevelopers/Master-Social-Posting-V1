#!/bin/bash

# Interactive Railway Deployment Script for Postiz
# This script will guide you through deploying to Railway using the CLI

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║         🚂 Railway Interactive Deployment Script          ║"
echo "║              Postiz Social Media Platform                 ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

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
    echo ""
    echo "Please run: ${CYAN}railway login${NC}"
    echo "Then run this script again."
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

echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📝 Deployment Steps${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}Step 1: Link to a Service${NC}"
echo "Since you don't have a service linked yet, we need to create one."
echo ""
echo "Please follow these steps:"
echo ""
echo "1. Run: ${CYAN}railway service${NC}"
echo "   This will show you available services or let you create a new one"
echo ""
echo "2. If no services exist, create one in the Railway dashboard:"
echo "   ${CYAN}https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01${NC}"
echo "   - Click 'New' → 'Empty Service'"
echo "   - Name it: 'postiz-app'"
echo ""
echo "3. Then link it: ${CYAN}railway service postiz-app${NC}"
echo ""

read -p "Press Enter when you've linked a service..." 

echo ""
echo -e "${BLUE}Step 2: Set Environment Variables${NC}"
echo "You need to set environment variables before deploying."
echo ""
echo "Option A - Use Railway Dashboard (Recommended):"
echo "  1. Open: ${CYAN}https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01${NC}"
echo "  2. Click on your service"
echo "  3. Go to 'Variables' tab"
echo "  4. Click 'Raw Editor'"
echo "  5. Copy from ${CYAN}RAILWAY_CREDENTIALS.md${NC}"
echo ""
echo "Option B - Use CLI (One at a time):"
echo "  ${CYAN}railway variables set JWT_SECRET='your-secret-here'${NC}"
echo "  ${CYAN}railway variables set DATABASE_URL='your-db-url'${NC}"
echo "  ... etc"
echo ""

read -p "Have you set all required environment variables? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Please set the environment variables first.${NC}"
    echo "Required variables are in: ${CYAN}RAILWAY_CREDENTIALS.md${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Step 3: Configure Service Settings${NC}"
echo "Before deploying, configure your service:"
echo ""
echo "In Railway Dashboard → Your Service → Settings:"
echo "  • Port: ${CYAN}5000${NC}"
echo "  • Health Check Path: ${CYAN}/api/health${NC}"
echo "  • Health Check Timeout: ${CYAN}300${NC}"
echo "  • Enable Public Networking: ${CYAN}Yes${NC}"
echo ""

read -p "Have you configured the service settings? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Please configure the service settings first.${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Step 4: Deploy!${NC}"
echo "Now we'll deploy your application to Railway."
echo ""
echo -e "${YELLOW}⚠️  Note: First deployment takes 10-15 minutes${NC}"
echo ""

read -p "Ready to deploy? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Deployment cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🚀 Starting Deployment...${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo ""

# Deploy
echo "Running: railway up"
echo ""
railway up

echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}📋 Post-Deployment Steps:${NC}"
echo ""
echo "1. Get your Railway domain:"
echo "   ${CYAN}railway domain${NC}"
echo ""
echo "2. Update these environment variables with your actual domain:"
echo "   • FRONTEND_URL=https://your-domain.railway.app"
echo "   • NEXT_PUBLIC_BACKEND_URL=https://your-domain.railway.app/api"
echo ""
echo "3. Check deployment status:"
echo "   ${CYAN}railway status${NC}"
echo ""
echo "4. View logs:"
echo "   ${CYAN}railway logs${NC}"
echo ""
echo "5. Test your application:"
echo "   Visit your Railway domain in a browser"
echo ""

echo -e "${GREEN}🎉 Congratulations! Your Postiz app is deployed!${NC}"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo "  • Setup Guide: RAILWAY_SETUP_GUIDE.md"
echo "  • Credentials: RAILWAY_CREDENTIALS.md"
echo "  • Full Guide: RAILWAY_DEPLOYMENT.md"
echo ""
echo -e "${YELLOW}💡 Need help?${NC}"
echo "  • Railway Discord: https://discord.gg/railway"
echo "  • Railway Docs: https://docs.railway.app"
echo ""
