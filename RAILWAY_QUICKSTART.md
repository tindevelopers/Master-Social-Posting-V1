# Railway Quick Start Guide

Get Postiz deployed to Railway in under 10 minutes!

## 🚀 Quick Deploy (5 Steps)

### Step 1: Create Railway Account
1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Verify your email

### Step 2: Deploy from GitHub
1. Click **"New Project"** → **"Deploy from GitHub repo"**
2. Select your Postiz repository
3. Choose the `railway-cloud-deploy` branch
4. Railway will create your project

### Step 3: Add Databases
1. In your project, click **"New"** → **"Database"** → **"PostgreSQL"**
2. Click **"New"** again → **"Database"** → **"Redis"**
3. Copy the connection strings (you'll need these next)

### Step 4: Set Environment Variables

Click on your service → **"Variables"** tab → **"Raw Editor"** and paste:

```bash
# Copy DATABASE_URL and REDIS_URL from your Railway databases
DATABASE_URL=postgresql://postgres:password@postgres.railway.internal:5432/railway
REDIS_URL=redis://default:password@redis.railway.internal:6379

# Generate a random JWT secret (make it long!)
JWT_SECRET=your-super-long-random-secret-string-here

# These will be updated after first deployment
FRONTEND_URL=https://your-app.up.railway.app
NEXT_PUBLIC_BACKEND_URL=https://your-app.up.railway.app/api
BACKEND_INTERNAL_URL=http://localhost:3000

# Cloudflare R2 Storage (get these from Cloudflare dashboard)
STORAGE_PROVIDER=cloudflare
CLOUDFLARE_ACCOUNT_ID=your-account-id
CLOUDFLARE_ACCESS_KEY=your-access-key
CLOUDFLARE_SECRET_ACCESS_KEY=your-secret-key
CLOUDFLARE_BUCKETNAME=your-bucket-name
CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com/
CLOUDFLARE_REGION=auto

# Required settings
IS_GENERAL=true
NODE_ENV=production
API_LIMIT=30
```

### Step 5: Configure & Deploy

1. Go to **"Settings"** tab
2. Set these values:
   - **Port**: `5000`
   - **Health Check Path**: `/api/health`
   - **Health Check Timeout**: `300`
3. Enable **"Public Networking"**
4. Click **"Deploy"**

Wait 10-15 minutes for the first build to complete.

### Step 6: Update URLs

After deployment:
1. Copy your Railway domain (e.g., `your-app-abc123.up.railway.app`)
2. Go back to **"Variables"** and update:
   ```bash
   FRONTEND_URL=https://your-actual-domain.up.railway.app
   NEXT_PUBLIC_BACKEND_URL=https://your-actual-domain.up.railway.app/api
   ```
3. Railway will automatically redeploy

## ✅ Verify Deployment

Visit your Railway domain. You should see the Postiz login page!

## 🔧 Optional: Add Email (Recommended)

To enable user activation emails, add these variables:

```bash
RESEND_API_KEY=re_your_resend_api_key
EMAIL_FROM_ADDRESS=noreply@yourdomain.com
EMAIL_FROM_NAME=Postiz
```

Get a Resend API key at [resend.com](https://resend.com) (free tier available).

## 🎯 Optional: Add Social Media Integrations

Add credentials for platforms you want to support:

```bash
# Twitter/X
X_API_KEY=your-x-api-key
X_API_SECRET=your-x-api-secret

# LinkedIn
LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret

# Facebook
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret

# Add others as needed...
```

See `env.railway.example` for the complete list.

## 💰 Pricing

**Recommended Plan**: Pro ($20/month)

Estimated monthly cost:
- Service: $15-25
- PostgreSQL: $5-10
- Redis: $5
- **Total**: ~$25-40/month

Start with the Hobby plan ($5/month) for testing, but upgrade to Pro for production use.

## 🐛 Troubleshooting

### Build Failed?
- Check you're on the Pro plan (Hobby has limited memory)
- View logs in Railway dashboard
- Ensure all required env variables are set

### Can't Access App?
- Verify port is set to `5000`
- Check "Public Networking" is enabled
- Wait a few minutes after deployment

### Database Connection Error?
- Verify `DATABASE_URL` is correct
- Check PostgreSQL service is running
- Try redeploying

### Need Help?
- Check full guide: `RAILWAY_DEPLOYMENT.md`
- Railway Discord: [discord.gg/railway](https://discord.gg/railway)
- Postiz Docs: [docs.postiz.com](https://docs.postiz.com)

## 📚 Next Steps

1. **Set up custom domain** (Settings → Domains)
2. **Configure backups** (Settings → Backups)
3. **Add monitoring** (integrate Sentry)
4. **Set up payments** (add Stripe keys)
5. **Invite your team!**

---

**Need more details?** See the complete deployment guide in `RAILWAY_DEPLOYMENT.md`
