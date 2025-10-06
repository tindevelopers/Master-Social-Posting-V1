# 🔄 Switch Railway Deployment to Main Branch

## ✅ Code Changes Complete

The configuration files have been updated to use the `main` branch with Dockerfile deployment.

**Files Updated:**
- ✅ `railway.yaml` - Updated to use Dockerfile.dev
- ✅ `railway.toml` - Already configured correctly
- ✅ Changes pushed to `main` branch

## 🎯 Next Step: Update Railway Service Settings

You need to change the deployment branch in the Railway dashboard from `railway-cloud-deploy` to `main`.

### Option 1: Change Branch in Service Settings (Recommended)

1. **Go to Railway Dashboard**:
   - Open: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01

2. **Select Your Service**:
   - Click on the service (likely named "remarkable-reprieve" or similar)

3. **Go to Settings**:
   - Click on the "Settings" tab

4. **Find Source Settings**:
   - Scroll down to the "Source" section
   - Look for "Branch" or "Deploy Branch"

5. **Change the Branch**:
   - Change from: `railway-cloud-deploy`
   - Change to: `main`
   - Click "Save" or it may auto-save

6. **Trigger Redeploy**:
   - Go back to the "Deployments" tab
   - Click "Deploy" or "Redeploy"
   - Railway will now deploy from the `main` branch

### Option 2: Using Railway CLI

```bash
cd /Users/gene/Projects/Master-Social-Posting-V1

# Link to your service (if not already linked)
railway service

# Update the branch
railway variables set RAILWAY_GIT_BRANCH=main

# Or directly in the service settings
railway service --branch main
```

### Option 3: Disconnect and Reconnect (If Settings Don't Work)

If you can't find the branch setting:

1. **Go to Service Settings**
2. **Disconnect the GitHub repository**:
   - Find "Source" or "GitHub" section
   - Click "Disconnect" or "Remove"
3. **Reconnect with Main Branch**:
   - Click "Connect to GitHub"
   - Select your repository: `tindevelopers/Master-Social-Posting-V1`
   - **Select branch: `main`** ← Important!
   - Confirm

## 🔍 Verify the Change

After changing the branch, check:

1. **In Railway Dashboard**:
   - Service Settings → Source → Branch should show `main`
   - Next deployment should say "Deploying from main"

2. **In Deployment Logs**:
   ```
   Source: github.com/tindevelopers/Master-Social-Posting-V1
   Branch: main  ← Should show main now
   Commit: [latest commit hash]
   ```

## 📋 What Happens Next

Once you switch to `main`:

1. **Railway will detect the change**
2. **Automatic deployment will trigger** (or click "Deploy")
3. **Build will use Dockerfile.dev** (as configured in railway.yaml)
4. **Services will start properly** (nginx + PM2)
5. **Health check should pass** ✅

## 🎉 Benefits of Using Main Branch

- ✅ **Simpler workflow** - Deploy from main like most projects
- ✅ **Single source of truth** - No need to sync branches
- ✅ **Team collaboration** - Everyone works on main
- ✅ **CI/CD ready** - Standard deployment pipeline

## 🗑️ Optional: Clean Up Railway-Cloud-Deploy Branch

After confirming main branch deployment works:

```bash
# Locally delete the branch
git branch -d railway-cloud-deploy

# Delete from GitHub
git push origin --delete railway-cloud-deploy
```

**Note**: Only do this after confirming the main branch deployment is successful!

## 📊 Current Configuration

### railway.yaml (Main Branch)
```yaml
build:
  builder: DOCKERFILE
  dockerfilePath: Dockerfile.dev
deploy:
  startCommand: sh -c 'nginx && pnpm run pm2'
  healthcheckPath: /api/health
  healthcheckTimeout: 600
```

### railway.toml (Main Branch)
```toml
[build]
    builder = "DOCKERFILE"
    dockerfilePath = "Dockerfile.dev"

[deploy]
    startCommand = "sh -c 'nginx && pnpm run pm2'"
    restartPolicyType = "ON_FAILURE"
    restartPolicyMaxRetries = 10
    healthcheckPath = "/api/health"
    healthcheckTimeout = 600
```

Both files are configured identically for consistent deployment! ✅

## 🆘 Troubleshooting

### If Railway Still Shows railway-cloud-deploy:

1. **Hard refresh** the Railway dashboard (Cmd+Shift+R / Ctrl+Shift+R)
2. **Check service settings** again
3. **Try disconnecting and reconnecting** the GitHub repo
4. **Contact Railway support** if the setting is stuck

### If Deployment Fails:

1. **Check the logs**: `railway logs --tail 200`
2. **Verify environment variables** are still set
3. **Ensure Dockerfile.dev exists** in main branch (it does ✅)
4. **Check Railway service settings** for any overrides

## 📞 Need Help?

If you encounter issues:
1. Check `DEPLOYMENT_FIX.md` for troubleshooting
2. Check `RAILWAY_TROUBLESHOOTING.md` for common issues
3. Run: `railway logs --follow` to see real-time logs

---

**Status**: ✅ Code ready on main branch
**Next Action**: Change branch in Railway dashboard to `main`
**Expected Result**: Successful deployment from main branch with all services running
