# Railway Deployment Guide for Postiz

This guide will help you deploy the Postiz social media management platform to Railway.

## Prerequisites

1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **Railway CLI** (optional but recommended): 
   ```bash
   npm install -g @railway/cli
   ```
3. **GitHub Account**: For connecting your repository to Railway

## Architecture Overview

Postiz is a monorepo with multiple services:
- **Frontend**: Next.js application (port 4200)
- **Backend**: NestJS API (port 3000)
- **Workers**: Background job processors
- **Cron**: Scheduled task runners
- **Nginx**: Reverse proxy (port 5000)

All services run together using PM2 process manager behind an Nginx reverse proxy.

## Required Environment Variables

### Essential (Required)

```bash
# Database
DATABASE_URL="postgresql://user:password@host:port/database"

# Redis
REDIS_URL="redis://host:port"

# JWT
JWT_SECRET="your-long-random-jwt-secret-string"

# URLs (Update these with your Railway domain)
FRONTEND_URL="https://your-app.railway.app"
NEXT_PUBLIC_BACKEND_URL="https://your-app.railway.app/api"
BACKEND_INTERNAL_URL="http://localhost:3000"

# Storage (Cloudflare R2 required for production)
STORAGE_PROVIDER="cloudflare"
CLOUDFLARE_ACCOUNT_ID="your-account-id"
CLOUDFLARE_ACCESS_KEY="your-access-key"
CLOUDFLARE_SECRET_ACCESS_KEY="your-secret-access-key"
CLOUDFLARE_BUCKETNAME="your-bucket-name"
CLOUDFLARE_BUCKET_URL="https://your-bucket-url.r2.cloudflarestorage.com/"
CLOUDFLARE_REGION="auto"

# General Settings
IS_GENERAL="true"
NODE_ENV="production"
```

### Optional (But Recommended)

```bash
# Email (Resend)
RESEND_API_KEY="your-resend-api-key"
EMAIL_FROM_ADDRESS="noreply@yourdomain.com"
EMAIL_FROM_NAME="Postiz"

# AI Features
OPENAI_API_KEY="your-openai-api-key"

# Social Media Integrations
X_API_KEY="your-x-api-key"
X_API_SECRET="your-x-api-secret"
LINKEDIN_CLIENT_ID="your-linkedin-client-id"
LINKEDIN_CLIENT_SECRET="your-linkedin-client-secret"
FACEBOOK_APP_ID="your-facebook-app-id"
FACEBOOK_APP_SECRET="your-facebook-app-secret"
# ... add other social media credentials as needed

# Payments (Stripe)
STRIPE_PUBLISHABLE_KEY="your-stripe-publishable-key"
STRIPE_SECRET_KEY="your-stripe-secret-key"
STRIPE_SIGNING_KEY="your-stripe-signing-key"
FEE_AMOUNT="0.05"

# Analytics & Monitoring
NEXT_PUBLIC_SENTRY_DSN="your-sentry-dsn"
SENTRY_ORG="your-sentry-org"
SENTRY_PROJECT="your-sentry-project"
SENTRY_AUTH_TOKEN="your-sentry-auth-token"

# Rate Limiting
API_LIMIT="30"
```

## Deployment Methods

### Method 1: Deploy via Railway Dashboard (Recommended for Beginners)

1. **Create New Project**
   - Go to [railway.app/new](https://railway.app/new)
   - Click "Deploy from GitHub repo"
   - Select your Postiz repository
   - Choose the `railway-cloud-deploy` branch

2. **Add PostgreSQL Database**
   - In your project, click "New" → "Database" → "PostgreSQL"
   - Railway will automatically create and provision the database
   - Copy the `DATABASE_URL` connection string

3. **Add Redis**
   - Click "New" → "Database" → "Redis"
   - Railway will provision Redis
   - Copy the `REDIS_URL` connection string

4. **Configure Environment Variables**
   - Go to your service → "Variables" tab
   - Add all required environment variables from the list above
   - Use the `DATABASE_URL` and `REDIS_URL` from the previous steps
   - Update `FRONTEND_URL` and `NEXT_PUBLIC_BACKEND_URL` with your Railway domain

5. **Configure Service Settings**
   - Go to "Settings" tab
   - Set **Port**: `5000` (Nginx listens on this port)
   - Set **Health Check Path**: `/api/health`
   - Set **Health Check Timeout**: `300` seconds
   - Enable **Public Networking**

6. **Deploy**
   - Railway will automatically build and deploy
   - Monitor the build logs for any errors
   - First deployment may take 10-15 minutes

### Method 2: Deploy via Railway CLI (Recommended for Advanced Users)

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**
   ```bash
   railway login
   ```

3. **Initialize Project**
   ```bash
   # In your project directory
   railway init
   ```

4. **Add PostgreSQL**
   ```bash
   railway add --database postgresql
   ```

5. **Add Redis**
   ```bash
   railway add --database redis
   ```

6. **Set Environment Variables**
   ```bash
   # Set variables one by one
   railway variables set JWT_SECRET="your-secret-here"
   railway variables set FRONTEND_URL="https://your-app.railway.app"
   railway variables set STORAGE_PROVIDER="cloudflare"
   # ... set all other required variables
   
   # Or use a .env file
   railway variables set --from-env-file .env.production
   ```

7. **Deploy**
   ```bash
   railway up
   ```

8. **Get Your Domain**
   ```bash
   railway domain
   ```

9. **Update URLs**
   ```bash
   # Update with your actual Railway domain
   railway variables set FRONTEND_URL="https://your-actual-domain.railway.app"
   railway variables set NEXT_PUBLIC_BACKEND_URL="https://your-actual-domain.railway.app/api"
   ```

## Post-Deployment Setup

### 1. Run Database Migrations

Railway will automatically run Prisma migrations during the build process via the `postinstall` script. However, if you need to manually push the schema:

```bash
railway run pnpm run prisma-db-push
```

### 2. Verify Services

Check that all services are running:
```bash
railway logs
```

You should see logs from:
- Nginx
- Frontend (Next.js)
- Backend (NestJS)
- Workers
- Cron

### 3. Test the Application

1. Visit your Railway domain: `https://your-app.railway.app`
2. Try creating an account
3. Test connecting a social media account
4. Create and schedule a post

### 4. Set Up Custom Domain (Optional)

1. Go to your service → "Settings" → "Domains"
2. Click "Custom Domain"
3. Add your domain (e.g., `postiz.yourdomain.com`)
4. Update DNS records as instructed by Railway
5. Update environment variables:
   ```bash
   railway variables set FRONTEND_URL="https://postiz.yourdomain.com"
   railway variables set NEXT_PUBLIC_BACKEND_URL="https://postiz.yourdomain.com/api"
   ```

## Resource Requirements

### Recommended Plan: **Pro Plan** ($20/month)

**Minimum Resources:**
- **Memory**: 4GB RAM (8GB recommended for smooth operation)
- **CPU**: 2 vCPUs (4 vCPUs recommended)
- **Storage**: 10GB (for logs and temporary files)
- **Build Memory**: 6GB (configured in `railway.toml`)

**Database:**
- PostgreSQL: 2GB storage minimum (grows with usage)
- Redis: 512MB memory minimum

### Cost Estimate

- **Service**: ~$15-25/month (depending on usage)
- **PostgreSQL**: ~$5-10/month
- **Redis**: ~$5/month
- **Total**: ~$25-40/month

## Troubleshooting

### Build Fails with "JavaScript heap out of memory"

This is already handled in the configuration with `NODE_OPTIONS='--max-old-space-size=6144'`. If it still fails:

1. Check Railway build logs
2. Ensure you're on the Pro plan (Hobby plan has limited memory)
3. Contact Railway support to increase build memory

### Services Not Starting

Check the logs:
```bash
railway logs
```

Common issues:
- Missing environment variables
- Database connection issues
- Redis connection issues
- Port conflicts

### Database Connection Errors

1. Verify `DATABASE_URL` is set correctly
2. Check PostgreSQL service is running
3. Ensure database is accessible from your service
4. Try running migrations manually:
   ```bash
   railway run pnpm run prisma-db-push
   ```

### Redis Connection Errors

1. Verify `REDIS_URL` is set correctly
2. Check Redis service is running
3. Ensure Redis is accessible from your service

### Frontend Not Loading

1. Check `FRONTEND_URL` and `NEXT_PUBLIC_BACKEND_URL` are correct
2. Verify port 5000 is exposed
3. Check Nginx logs:
   ```bash
   railway logs --filter nginx
   ```

### Social Media Integration Issues

1. Verify all social media API credentials are set
2. Check callback URLs in social media app settings
3. Ensure URLs use HTTPS (required by most platforms)
4. Update OAuth redirect URIs to match your Railway domain

## Monitoring & Maintenance

### View Logs

```bash
# All logs
railway logs

# Specific service
railway logs --filter backend
railway logs --filter frontend
railway logs --filter workers
railway logs --filter cron

# Follow logs in real-time
railway logs --follow
```

### Restart Services

```bash
railway restart
```

### Update Deployment

```bash
# Push changes to GitHub
git push origin railway-cloud-deploy

# Railway will automatically redeploy
# Or manually trigger:
railway up
```

### Backup Database

```bash
# Export database
railway run pg_dump $DATABASE_URL > backup.sql

# Restore database
railway run psql $DATABASE_URL < backup.sql
```

## Scaling

### Horizontal Scaling

Railway supports horizontal scaling:

1. Go to service → "Settings" → "Scaling"
2. Increase number of replicas
3. Note: You'll need a load balancer for multiple replicas

### Vertical Scaling

1. Upgrade to a higher Railway plan
2. Increase memory/CPU limits in service settings

## Security Best Practices

1. **Use Strong Secrets**
   - Generate strong `JWT_SECRET` (at least 32 characters)
   - Use Railway's secret management
   - Never commit secrets to Git

2. **Enable HTTPS**
   - Railway provides HTTPS by default
   - Ensure `FRONTEND_URL` uses `https://`

3. **Restrict Database Access**
   - Use Railway's private networking
   - Don't expose database publicly

4. **Regular Updates**
   - Keep dependencies updated
   - Monitor security advisories
   - Apply patches promptly

5. **Rate Limiting**
   - Configure `API_LIMIT` appropriately
   - Monitor for abuse

## Support

- **Railway Documentation**: https://docs.railway.app
- **Postiz Documentation**: https://docs.postiz.com
- **Railway Community**: https://discord.gg/railway
- **Postiz Community**: Check `NEXT_PUBLIC_DISCORD_SUPPORT` in your env

## Additional Resources

- [Railway Pricing](https://railway.app/pricing)
- [Railway CLI Reference](https://docs.railway.app/develop/cli)
- [Postiz Configuration Reference](https://docs.postiz.com/configuration/reference)
- [Cloudflare R2 Setup](https://developers.cloudflare.com/r2/)

---

**Note**: This deployment uses the existing `Dockerfile.dev` which includes Nginx, PM2, and all services. For production, consider:
- Using a managed Redis service (Railway Redis or Upstash)
- Setting up automated backups
- Implementing monitoring (Sentry, LogRocket, etc.)
- Using a CDN for static assets
