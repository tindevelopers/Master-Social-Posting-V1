#!/bin/bash

# Setup script for new Railway service (heartfelt-integrity)

set -e

echo ""
echo "🔄 ========================================"
echo "   Setting up NEW Railway Service"
echo "   ========================================"
echo ""

# Check if railway CLI is available
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found!"
    exit 1
fi

# Check if logged in
if ! railway whoami &> /dev/null; then
    echo "❌ Not logged in to Railway!"
    exit 1
fi

echo "✅ Authenticated with Railway"
echo ""

# Get project and service info
echo "📋 Railway Project: postiz-master-social"
echo "📋 Environment: production"
echo "📋 New Service: heartfelt-integrity"
echo ""

echo "🔧 Setting environment variables..."
echo ""

# Set all variables
echo "   Setting DATABASE_URL..."
railway variables --set "DATABASE_URL=\${{Postgres.DATABASE_URL}}"

echo "   Setting REDIS_URL..."
railway variables --set "REDIS_URL=\${{Redis.REDIS_URL}}"

echo "   Setting JWT_SECRET..."
railway variables --set "JWT_SECRET=I8E8MINMtxCvMsm//ViA0I6jy/qb0vpzA9mb7GKY4YuWtqBydRyQgeKkVGj6nBJP"

echo "   Setting IS_GENERAL..."
railway variables --set "IS_GENERAL=true"

echo "   Setting NODE_ENV..."
railway variables --set "NODE_ENV=production"

echo "   Setting PORT..."
railway variables --set "PORT=5000"

echo "   Setting FRONTEND_URL..."
railway variables --set "FRONTEND_URL=\${{RAILWAY_PUBLIC_DOMAIN}}"

echo "   Setting NEXT_PUBLIC_BACKEND_URL..."
railway variables --set "NEXT_PUBLIC_BACKEND_URL=https://\${{RAILWAY_PUBLIC_DOMAIN}}/api"

echo "   Setting BACKEND_INTERNAL_URL..."
railway variables --set "BACKEND_INTERNAL_URL=http://localhost:3000"

echo "   Setting STORAGE_PROVIDER..."
railway variables --set "STORAGE_PROVIDER=local"

echo "   Setting API_LIMIT..."
railway variables --set "API_LIMIT=30"

echo ""
echo "✅ All variables set!"
echo ""

echo "📊 Verifying variables..."
echo ""
railway variables --kv

echo ""
echo "🎉 ========================================"
echo "   Setup Complete!"
echo "   ========================================"
echo ""
echo "🚀 Deployment will continue automatically"
echo "📊 Watch logs: railway logs --follow"
echo ""
