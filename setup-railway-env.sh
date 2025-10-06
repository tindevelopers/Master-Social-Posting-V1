#!/bin/bash

# Railway Environment Variables Setup Script
# This script sets all required environment variables for the Postiz application

set -e  # Exit on error

echo ""
echo "🚀 ========================================"
echo "   Railway Environment Setup"
echo "   ========================================"
echo ""

# Check if railway CLI is available
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found!"
    echo "   Install it with: npm install -g @railway/cli"
    exit 1
fi

# Check if logged in
echo "🔍 Checking Railway authentication..."
if ! railway whoami &> /dev/null; then
    echo "❌ Not logged in to Railway!"
    echo "   Run: railway login"
    exit 1
fi

echo "✅ Authenticated with Railway"
echo ""

# Link to service if not already linked
echo "🔗 Linking to Railway service..."
echo "   If prompted, select your service from the list"
echo ""

# Try to link (this will be interactive if not already linked)
railway service 2>/dev/null || echo "   (Service linking may require manual selection)"

echo ""
echo "📝 Setting environment variables..."
echo ""

# Generate JWT secret if needed
JWT_SECRET="I8E8MINMtxCvMsm//ViA0I6jy/qb0vpzA9mb7GKY4YuWtqBydRyQgeKkVGj6nBJP"

# Core required variables
echo "   Setting core variables..."

railway variables --set "DATABASE_URL=\${{Postgres.DATABASE_URL}}" 2>/dev/null || echo "   ⚠️  DATABASE_URL: May need PostgreSQL service"
railway variables --set "REDIS_URL=\${{Redis.REDIS_URL}}" 2>/dev/null || echo "   ⚠️  REDIS_URL: May need Redis service"
railway variables --set "JWT_SECRET=$JWT_SECRET"
railway variables --set "IS_GENERAL=true"
railway variables --set "NODE_ENV=production"
railway variables --set "PORT=5000"

echo "   ✅ Core variables set"
echo ""

# Application URLs
echo "   Setting application URLs..."

railway variables --set "FRONTEND_URL=\${{RAILWAY_PUBLIC_DOMAIN}}"
railway variables --set "NEXT_PUBLIC_BACKEND_URL=https://\${{RAILWAY_PUBLIC_DOMAIN}}/api"
railway variables --set "BACKEND_INTERNAL_URL=http://localhost:3000"

echo "   ✅ URL variables set"
echo ""

# Storage (local for now)
echo "   Setting storage configuration..."

railway variables --set "STORAGE_PROVIDER=local"

echo "   ✅ Storage variables set"
echo ""

# Optional but recommended
echo "   Setting optional variables..."

railway variables --set "API_LIMIT=30"

echo "   ✅ Optional variables set"
echo ""

echo "✅ ========================================"
echo "   All Variables Set Successfully!"
echo "   ========================================"
echo ""

echo "📋 Variables that were set:"
echo ""
railway variables
echo ""

echo "🎯 Next Steps:"
echo ""
echo "   1. Verify PostgreSQL service exists:"
echo "      → Railway Dashboard → Check for PostgreSQL service"
echo ""
echo "   2. Verify Redis service exists:"
echo "      → Railway Dashboard → Check for Redis service"
echo ""
echo "   3. Deploy your application:"
echo "      railway up"
echo "      OR"
echo "      Click 'Deploy' in Railway Dashboard"
echo ""
echo "   4. Watch the logs:"
echo "      railway logs --follow"
echo ""

echo "⚠️  IMPORTANT NOTES:"
echo ""
echo "   • DATABASE_URL and REDIS_URL use Railway references"
echo "   • Make sure PostgreSQL and Redis services exist!"
echo "   • For production, configure Cloudflare R2 storage"
echo "   • Add social media API keys as needed"
echo ""

echo "📚 For more configuration options, see:"
echo "   • env.railway.example"
echo "   • CRITICAL_DATABASE_ISSUE.md"
echo ""
