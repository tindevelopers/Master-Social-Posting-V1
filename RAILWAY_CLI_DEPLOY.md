# Railway CLI Deployment Guide

Since the Railway CLI requires interactive mode for some operations, here's how to deploy using the CLI:

## 🚀 Quick CLI Deployment

### Method 1: Using the Interactive Script (Recommended)

Run the interactive deployment script:

```bash
./railway-deploy-interactive.sh
```

This script will guide you through each step.

### Method 2: Manual CLI Commands

Follow these commands in order:

#### Step 1: Verify You're Logged In

```bash
railway whoami
```

You should see: "Logged in as TIN Wizard (dev@tin.ca) 👋"

#### Step 2: Check Current Status

```bash
railway status
```

Should show:
- Project: postiz-master-social
- Environment: production
- Service: None (we'll fix this)

#### Step 3: Create a Service in Railway Dashboard

The CLI can't create services non-interactively, so:

1. Open: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01
2. Click **"New"** → **"Empty Service"**
3. Name it: `postiz-app`
4. Click **"Create"**

#### Step 4: Link the Service

In your terminal, run:

```bash
railway service
```

This will open an interactive prompt. Select `postiz-app`.

Or if you know the service name:

```bash
railway service postiz-app
```

#### Step 5: Set Environment Variables

You have two options:

**Option A: Via Dashboard (Easier for bulk)**

1. Go to your service in Railway dashboard
2. Click **"Variables"** tab
3. Click **"Raw Editor"**
4. Copy the template from `RAILWAY_CREDENTIALS.md`
5. Paste and fill in the values
6. Click **"Save"**

**Option B: Via CLI (One at a time)**

```bash
# Required variables
railway variables set JWT_SECRET="I8E8MINMtxCvMsm//ViA0I6jy/qb0vpzA9mb7GKY4YuWtqBydRyQgeKkVGj6nBJP"
railway variables set DATABASE_URL="postgresql://postgres:xxxxx@postgres.railway.internal:5432/railway"
railway variables set REDIS_URL="redis://default:xxxxx@redis.railway.internal:6379"
railway variables set FRONTEND_URL="https://your-app.railway.app"
railway variables set NEXT_PUBLIC_BACKEND_URL="https://your-app.railway.app/api"
railway variables set BACKEND_INTERNAL_URL="http://localhost:3000"
railway variables set STORAGE_PROVIDER="cloudflare"
railway variables set CLOUDFLARE_ACCOUNT_ID="your-account-id"
railway variables set CLOUDFLARE_ACCESS_KEY="your-access-key"
railway variables set CLOUDFLARE_SECRET_ACCESS_KEY="your-secret-key"
railway variables set CLOUDFLARE_BUCKETNAME="your-bucket-name"
railway variables set CLOUDFLARE_BUCKET_URL="https://your-bucket.r2.cloudflarestorage.com/"
railway variables set CLOUDFLARE_REGION="auto"
railway variables set IS_GENERAL="true"
railway variables set NODE_ENV="production"
railway variables set API_LIMIT="30"
```

#### Step 6: Configure Service Settings

In Railway Dashboard → Your Service → Settings:

- **Port**: `5000`
- **Health Check Path**: `/api/health`
- **Health Check Timeout**: `300`
- **Enable Public Networking**: Yes

#### Step 7: Deploy!

```bash
railway up
```

This will:
- Upload your code
- Build the application
- Deploy to Railway
- Stream the logs

To deploy without watching logs:

```bash
railway up --detach
```

#### Step 8: Check Deployment Status

```bash
railway status
```

#### Step 9: View Logs

```bash
# View all logs
railway logs

# Follow logs in real-time
railway logs --follow

# View only recent logs
railway logs --tail 100
```

#### Step 10: Get Your Domain

```bash
railway domain
```

Or generate a Railway domain:

```bash
railway domain --generate
```

#### Step 11: Update URLs

After getting your domain, update these variables:

```bash
railway variables set FRONTEND_URL="https://your-actual-domain.railway.app"
railway variables set NEXT_PUBLIC_BACKEND_URL="https://your-actual-domain.railway.app/api"
```

Railway will automatically redeploy with the new variables.

## 🔄 Redeploying

To redeploy after making changes:

```bash
# Commit your changes
git add .
git commit -m "Your changes"
git push

# Deploy
railway up
```

Or to redeploy the latest deployment without changes:

```bash
railway redeploy
```

## 📊 Monitoring

### View Current Deployment

```bash
railway status
```

### View Logs

```bash
# All logs
railway logs

# Follow in real-time
railway logs --follow

# Last 50 lines
railway logs --tail 50
```

### View Variables

```bash
railway variables
```

### Open Dashboard

```bash
railway open
```

Note: This requires interactive mode, so it will open in your browser.

## 🐛 Troubleshooting

### Error: "No service linked"

**Solution**: Link a service first:

```bash
railway service
```

Then select or create a service.

### Error: "Multiple services found"

**Solution**: Specify the service:

```bash
railway up --service postiz-app
```

### Error: "Build failed"

**Check logs**:

```bash
railway logs
```

Common issues:
- Missing environment variables
- Insufficient memory (upgrade to Pro plan)
- Build timeout (increase in settings)

### Error: "Health check failed"

**Check**:
- Port is set to `5000`
- Health check path is `/api/health`
- Health check timeout is `300`
- Application is actually running

**View logs**:

```bash
railway logs --follow
```

## 📝 Useful Commands

```bash
# Check who you're logged in as
railway whoami

# Check project status
railway status

# List all projects
railway list

# View environment variables
railway variables

# Set a variable
railway variables set KEY="value"

# Delete a variable
railway variables delete KEY

# Deploy
railway up

# Deploy without logs
railway up --detach

# Redeploy latest
railway redeploy

# View logs
railway logs

# Follow logs
railway logs --follow

# Connect to PostgreSQL
railway connect postgres

# Connect to Redis
railway connect redis

# Run a command with Railway env vars
railway run node script.js

# Open a shell with Railway env vars
railway shell

# Generate a domain
railway domain --generate

# Add a custom domain
railway domain your-domain.com

# Open project in browser
railway open

# Unlink from current directory
railway unlink

# Get help
railway help
```

## 🎯 Complete Deployment Checklist

- [ ] Logged in to Railway CLI (`railway whoami`)
- [ ] On correct branch (`railway-cloud-deploy`)
- [ ] Created service in Railway dashboard
- [ ] Linked service (`railway service postiz-app`)
- [ ] Set all required environment variables
- [ ] Configured service settings (port, health check)
- [ ] Deployed application (`railway up`)
- [ ] Checked deployment status (`railway status`)
- [ ] Viewed logs to verify (`railway logs`)
- [ ] Got Railway domain (`railway domain`)
- [ ] Updated FRONTEND_URL and NEXT_PUBLIC_BACKEND_URL
- [ ] Tested application in browser

## 🚀 Quick Deploy (After Initial Setup)

Once everything is configured, deploying is simple:

```bash
# Make your changes
git add .
git commit -m "Update feature"
git push

# Deploy to Railway
railway up
```

That's it! Railway will build and deploy automatically.

## 📚 Additional Resources

- **Railway CLI Docs**: https://docs.railway.app/develop/cli
- **Railway Dashboard**: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01
- **Your Credentials**: `RAILWAY_CREDENTIALS.md`
- **Setup Guide**: `RAILWAY_SETUP_GUIDE.md`
- **Quick Start**: `RAILWAY_QUICKSTART.md`

---

**Your Project**: postiz-master-social
**Railway URL**: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01
**Branch**: railway-cloud-deploy ✅
**JWT Secret**: Check `RAILWAY_CREDENTIALS.md`
