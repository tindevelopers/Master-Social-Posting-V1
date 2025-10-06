# Railway Setup Guide - Current Deployment

## ✅ What's Been Done

1. **Railway CLI Installed**: ✅ Version 4.10.0
2. **Logged In**: ✅ As TIN Wizard (dev@tin.ca)
3. **Project Created**: ✅ `postiz-master-social`
4. **Databases Added**: ✅ PostgreSQL + Redis
5. **Branch Ready**: ✅ `railway-cloud-deploy`

## 🔗 Your Railway Project

**Project URL**: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01

## 📋 Next Steps (Complete in Railway Dashboard)

### Step 1: Connect Your GitHub Repository

1. Open your project: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01
2. Click **"New"** → **"GitHub Repo"**
3. Select: `tindevelopers/Master-Social-Posting-V1`
4. Choose branch: `railway-cloud-deploy`
5. Railway will create a new service

### Step 2: Configure Service Settings

In your new service:

1. Go to **"Settings"** tab
2. Set these values:
   - **Port**: `5000`
   - **Health Check Path**: `/api/health`
   - **Health Check Timeout**: `300`
3. Enable **"Public Networking"**
4. Click **"Save"**

### Step 3: Get Database Connection Strings

1. Click on your **PostgreSQL** service
2. Go to **"Variables"** tab
3. Copy the `DATABASE_URL` value
4. Click on your **Redis** service
5. Copy the `REDIS_URL` value

### Step 4: Set Environment Variables

Go to your main service → **"Variables"** tab → **"Raw Editor"**

Paste this template and fill in the values:

```bash
# ============================================
# REQUIRED - Fill these in!
# ============================================

# Database (Copy from PostgreSQL service Variables tab)
DATABASE_URL=postgresql://postgres:xxxxx@postgres.railway.internal:5432/railway

# Redis (Copy from Redis service Variables tab)
REDIS_URL=redis://default:xxxxx@redis.railway.internal:6379

# JWT Secret (Generate a random 32+ character string)
# You can use: openssl rand -base64 32
JWT_SECRET=CHANGE_THIS_TO_A_LONG_RANDOM_STRING

# Application URLs (Update after first deployment)
FRONTEND_URL=https://postiz-master-social-production.up.railway.app
NEXT_PUBLIC_BACKEND_URL=https://postiz-master-social-production.up.railway.app/api
BACKEND_INTERNAL_URL=http://localhost:3000

# Cloudflare R2 Storage (Get from Cloudflare dashboard)
STORAGE_PROVIDER=cloudflare
CLOUDFLARE_ACCOUNT_ID=your-account-id-here
CLOUDFLARE_ACCESS_KEY=your-access-key-here
CLOUDFLARE_SECRET_ACCESS_KEY=your-secret-key-here
CLOUDFLARE_BUCKETNAME=your-bucket-name-here
CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com/
CLOUDFLARE_REGION=auto

# General Settings
IS_GENERAL=true
NODE_ENV=production
API_LIMIT=30

# ============================================
# OPTIONAL - Add these for full functionality
# ============================================

# Email (Resend - for user activation)
#RESEND_API_KEY=re_your_key_here
#EMAIL_FROM_ADDRESS=noreply@yourdomain.com
#EMAIL_FROM_NAME=Postiz

# AI Features
#OPENAI_API_KEY=sk-your-key-here

# Social Media - Add as needed
#X_API_KEY=your-key
#X_API_SECRET=your-secret
#LINKEDIN_CLIENT_ID=your-id
#LINKEDIN_CLIENT_SECRET=your-secret
#FACEBOOK_APP_ID=your-id
#FACEBOOK_APP_SECRET=your-secret
# ... add others from env.railway.example

# Payments (Stripe)
#STRIPE_PUBLISHABLE_KEY=pk_live_your_key
#STRIPE_SECRET_KEY=sk_live_your_key
#STRIPE_SIGNING_KEY=whsec_your_key
#FEE_AMOUNT=0.05

# Monitoring (Sentry)
#NEXT_PUBLIC_SENTRY_DSN=https://your-dsn@sentry.io/project
#SENTRY_ORG=your-org
#SENTRY_PROJECT=your-project
#SENTRY_AUTH_TOKEN=your-token
```

### Step 5: Deploy!

1. Click **"Save"** in the Variables tab
2. Railway will automatically start building and deploying
3. Monitor the **"Deployments"** tab for progress
4. First build takes 10-15 minutes

### Step 6: Update URLs After Deployment

Once deployed:

1. Go to **"Settings"** → **"Domains"**
2. Copy your Railway domain (e.g., `postiz-master-social-production.up.railway.app`)
3. Go back to **"Variables"** tab
4. Update these two variables with your actual domain:
   ```bash
   FRONTEND_URL=https://your-actual-domain.up.railway.app
   NEXT_PUBLIC_BACKEND_URL=https://your-actual-domain.up.railway.app/api
   ```
5. Railway will automatically redeploy

## 🎯 Quick Setup Checklist

- [ ] Open Railway project dashboard
- [ ] Connect GitHub repository (railway-cloud-deploy branch)
- [ ] Configure service settings (port 5000, health checks)
- [ ] Copy DATABASE_URL from PostgreSQL service
- [ ] Copy REDIS_URL from Redis service
- [ ] Generate JWT_SECRET
- [ ] Set up Cloudflare R2 credentials
- [ ] Set all required environment variables
- [ ] Wait for first deployment (10-15 min)
- [ ] Copy Railway domain
- [ ] Update FRONTEND_URL and NEXT_PUBLIC_BACKEND_URL
- [ ] Test the application!

## 🔧 Generating a JWT Secret

Run this command in your terminal:

```bash
openssl rand -base64 32
```

Or use Node.js:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

## 📦 Setting Up Cloudflare R2

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Navigate to **R2** in the sidebar
3. Create a new bucket (e.g., `postiz-storage`)
4. Go to **Manage R2 API Tokens**
5. Create a new API token with:
   - **Permissions**: Object Read & Write
   - **Bucket**: Your bucket name
6. Copy the credentials:
   - Account ID
   - Access Key ID
   - Secret Access Key
   - Bucket URL

## 🐛 Troubleshooting

### Build Fails

**Check:**
- You're on the Pro plan (Hobby has limited memory)
- All required environment variables are set
- DATABASE_URL and REDIS_URL are correct

**View logs:**
- Go to Deployments tab → Click on the deployment → View logs

### Can't Access Application

**Check:**
- Port is set to `5000`
- Public Networking is enabled
- Deployment completed successfully
- Health check is passing

### Database Connection Error

**Check:**
- DATABASE_URL is copied correctly from PostgreSQL service
- PostgreSQL service is running (green status)
- No typos in the connection string

### Redis Connection Error

**Check:**
- REDIS_URL is copied correctly from Redis service
- Redis service is running (green status)
- No typos in the connection string

## 📊 Monitoring Your Deployment

### View Logs

```bash
# In your terminal
railway logs

# Follow logs in real-time
railway logs --follow
```

### Check Service Status

```bash
railway status
```

### View Metrics

Go to your service in Railway Dashboard → **"Metrics"** tab

## 💰 Expected Costs

**Pro Plan** (~$25-40/month):
- Main Service: $15-25/month
- PostgreSQL: $5-10/month
- Redis: $5/month

**Starter/Hobby Plan** ($5/month):
- Good for testing, but may have memory issues during builds
- Upgrade to Pro for production use

## 🚀 After Successful Deployment

1. **Test the application**:
   - Visit your Railway domain
   - Create an account
   - Test basic functionality

2. **Set up custom domain** (optional):
   - Settings → Domains → Add Custom Domain
   - Update DNS records
   - Update FRONTEND_URL and NEXT_PUBLIC_BACKEND_URL

3. **Add optional integrations**:
   - Social media credentials
   - Email service (Resend)
   - Payment processing (Stripe)
   - Monitoring (Sentry)

4. **Set up backups**:
   - Settings → Backups
   - Enable automatic backups

## 📚 Additional Resources

- **Railway Documentation**: https://docs.railway.app
- **Postiz Documentation**: https://docs.postiz.com
- **Quick Start Guide**: `RAILWAY_QUICKSTART.md`
- **Full Deployment Guide**: `RAILWAY_DEPLOYMENT.md`
- **Environment Variables**: `env.railway.example`

## 🆘 Need Help?

- **Railway Discord**: https://discord.gg/railway
- **Railway Support**: support@railway.app
- **Postiz Community**: Check your NEXT_PUBLIC_DISCORD_SUPPORT URL

---

**Current Status**: ✅ Project created, databases added, ready for GitHub connection!

**Next Action**: Open the Railway dashboard and connect your GitHub repository.
