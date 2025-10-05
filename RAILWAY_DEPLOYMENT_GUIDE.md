# Postiz Railway Deployment Guide

## 🚀 Quick Start with Railway

Railway is perfect for your Postiz monorepo! It automatically detects your pnpm workspace and can deploy all services.

## ✅ What Railway Provides

- **Automatic Monorepo Detection** - Handles pnpm workspaces natively
- **Built-in PostgreSQL** - Managed database with automatic backups
- **Built-in Redis** - Managed Redis instance
- **Automatic Deployments** - Deploys from your GitHub repository
- **Environment Variables** - Easy secret management
- **Custom Domains** - Free SSL certificates
- **Scaling** - Automatic scaling based on demand

## 🎯 Deployment Steps

### 1. Create Railway Account
```bash
# Visit Railway and sign up with GitHub
open https://railway.app
```

### 2. Connect Your Repository
1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Choose `tindevelopers/Master-Social-Posting-V1`
4. Select the `development` branch

### 3. Add Services
Railway will automatically detect your monorepo structure. You'll need to add:

#### **Main Application Service**
- **Source**: Your GitHub repository
- **Branch**: `development`
- **Root Directory**: `/` (root)
- **Build Command**: `pnpm run build`
- **Start Command**: `pnpm run pm2`

#### **PostgreSQL Database**
- Click "New" → "Database" → "PostgreSQL"
- Railway will automatically create and configure

#### **Redis Cache**
- Click "New" → "Database" → "Redis"
- Railway will automatically create and configure

## 🔧 Environment Variables Setup

Set these in Railway's environment variables section:

### **Database Configuration**
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

### **Application Configuration**
```
NODE_ENV=production
NEXTAUTH_URL=https://your-app.railway.app
NEXTAUTH_SECRET=your-nextauth-secret
JWT_SECRET=your-jwt-secret
```

### **Social Media APIs**
```
TWITTER_API_KEY=your-twitter-api-key
TWITTER_API_SECRET=your-twitter-api-secret
LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
```

### **Other Services**
```
OPENAI_API_KEY=your-openai-api-key
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key
```

## 📊 Railway vs Google Cloud Run

| Feature | Railway | Google Cloud Run | Winner |
|---------|---------|------------------|---------|
| **Monorepo Support** | ✅ Native | ⚠️ Complex setup | **Railway** |
| **Database Setup** | ✅ One-click | ⚠️ Manual configuration | **Railway** |
| **Deployment Speed** | ✅ 2-3 minutes | ⚠️ 10-15 minutes | **Railway** |
| **Environment Variables** | ✅ UI-based | ⚠️ CLI/Secret Manager | **Railway** |
| **Custom Domains** | ✅ Free SSL | ✅ Free SSL | **Tie** |
| **Scaling** | ✅ Automatic | ✅ Automatic | **Tie** |
| **Cost** | $5-20/month | $60-120/month | **Railway** |
| **Complexity** | ⭐⭐ | ⭐⭐⭐⭐ | **Railway** |

## 💰 Cost Comparison

### **Railway Pricing**
- **Hobby Plan**: $5/month (includes $5 credit)
- **Pro Plan**: $20/month (includes $20 credit)
- **Database**: $5/month for PostgreSQL + Redis
- **Total**: ~$10-25/month

### **Google Cloud Run Pricing**
- **Cloud Run**: $10-50/month
- **Cloud SQL**: $25/month
- **Redis**: $30/month
- **Total**: ~$65-105/month

## 🚀 Deployment Process

### **Automatic Deployment**
1. Railway detects your monorepo structure
2. Automatically installs dependencies with pnpm
3. Runs your build process
4. Deploys all services
5. Sets up database connections

### **Manual Configuration** (if needed)
If Railway doesn't auto-detect correctly:

1. **Set Build Command**: `pnpm run build`
2. **Set Start Command**: `pnpm run pm2`
3. **Set Node Version**: `20`
4. **Set Port**: `5000` (or let Railway auto-detect)

## 🔍 Monitoring & Logs

Railway provides:
- **Real-time logs** in the dashboard
- **Metrics** for CPU, memory, and requests
- **Deployment history** with rollback capability
- **Health checks** and automatic restarts

## 🌐 Custom Domain Setup

1. Go to your service settings
2. Click "Domains"
3. Add your custom domain
4. Railway automatically provisions SSL certificates

## 🔄 CI/CD Integration

Railway automatically deploys when you:
- Push to the `development` branch (for testing)
- Push to the `main` branch (for production)
- Create pull requests (for preview deployments)

## 🆘 Troubleshooting

### **Common Issues**

1. **Build Fails**: Check the build logs in Railway dashboard
2. **Database Connection**: Ensure `DATABASE_URL` is set correctly
3. **Memory Issues**: Railway automatically scales, but you can adjust in settings
4. **Port Issues**: Railway auto-detects ports, but you can set `PORT` environment variable

### **Useful Commands**

```bash
# Install Railway CLI (optional)
npm install -g @railway/cli

# Login to Railway
railway login

# Link to your project
railway link

# View logs
railway logs

# Deploy manually
railway up
```

## 📞 Support

- **Railway Docs**: https://docs.railway.app
- **Community**: https://discord.gg/railway
- **Status**: https://status.railway.app

---

## 🎯 Next Steps

1. **Sign up for Railway**: https://railway.app
2. **Connect your GitHub repository**
3. **Add PostgreSQL and Redis databases**
4. **Configure environment variables**
5. **Deploy and test!**

Railway will handle all the complex Docker and deployment configuration automatically! 🚀
