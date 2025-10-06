#!/bin/bash

# Deploy specific branch to Railway
# This ensures the railway-cloud-deploy branch is used

set -e

echo "🚂 Deploying railway-cloud-deploy branch to Railway..."
echo ""

# Check if on correct branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "railway-cloud-deploy" ]; then
    echo "⚠️  You're on branch: $CURRENT_BRANCH"
    echo "Switching to railway-cloud-deploy..."
    git checkout railway-cloud-deploy
fi

echo "✅ On branch: railway-cloud-deploy"
echo ""

# Ensure latest changes are pushed
echo "📤 Pushing latest changes to GitHub..."
git push origin railway-cloud-deploy

echo ""
echo "✅ Branch pushed to GitHub"
echo ""
echo "📋 Next Steps:"
echo ""
echo "In Railway Dashboard:"
echo "1. Go to: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01"
echo "2. If service exists:"
echo "   - Click on the service"
echo "   - Settings → Source → Configure"
echo "   - Change branch to: railway-cloud-deploy"
echo "   - Save"
echo ""
echo "3. If creating new service:"
echo "   - Click 'New' → 'GitHub Repo'"
echo "   - Select: tindevelopers/Master-Social-Posting-V1"
echo "   - Branch: railway-cloud-deploy"
echo "   - Deploy"
echo ""
echo "🔗 Railway Project: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01"
echo ""
