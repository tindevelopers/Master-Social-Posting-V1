# Postiz Google Cloud Run Deployment Guide

## 🚀 Quick Start

Your Postiz application is ready to deploy to Google Cloud Run! Here's what we've set up and what you need to do next.

## ✅ What's Already Done

1. **Google Cloud Project Created**: `postiz-master-social-v1`
2. **Docker Configuration**: Multi-stage Dockerfiles for frontend, backend, and workers
3. **Cloud Build Configuration**: `cloudbuild.yaml` for automated builds
4. **Deployment Script**: `deploy.sh` for easy deployment
5. **Development Branch**: Ready for testing

## 🔧 Next Steps Required

### 1. Enable Billing (Required)
```bash
# Open the Google Cloud Console and enable billing
open https://console.cloud.google.com/billing/linkedaccount?project=postiz-master-social-v1
```

### 2. Run the Deployment Script
```bash
# Make sure you're in the project directory
cd /Users/foo/projects/postiz-app

# Run the deployment script
./deploy.sh
```

## 📋 Manual Deployment Steps (Alternative)

If you prefer to run the commands manually:

### 1. Enable APIs
```bash
gcloud services enable cloudbuild.googleapis.com run.googleapis.com sqladmin.googleapis.com redis.googleapis.com storage.googleapis.com secretmanager.googleapis.com
```

### 2. Create Database
```bash
# Create Cloud SQL PostgreSQL instance
gcloud sql instances create postiz-db \
    --database-version=POSTGRES_15 \
    --tier=db-f1-micro \
    --region=us-central1 \
    --storage-type=SSD \
    --storage-size=10GB \
    --backup \
    --enable-ip-alias \
    --authorized-networks=0.0.0.0/0

# Create database
gcloud sql databases create postiz_production --instance=postiz-db

# Create database user
gcloud sql users create postiz --instance=postiz-db --password=$(openssl rand -base64 32)
```

### 3. Create Redis
```bash
gcloud redis instances create postiz-redis \
    --size=1 \
    --region=us-central1 \
    --redis-version=redis_7_0 \
    --tier=basic
```

### 4. Create Storage Bucket
```bash
gsutil mb gs://postiz-master-social-v1-postiz-storage
```

### 5. Build and Deploy
```bash
# Build and push containers
gcloud builds submit --config cloudbuild.yaml .

# Or deploy individual services
gcloud run deploy postiz-frontend \
    --image gcr.io/postiz-master-social-v1/postiz-frontend:latest \
    --region us-central1 \
    --platform managed \
    --allow-unauthenticated \
    --port 5000 \
    --memory 2Gi \
    --cpu 2
```

## 🔐 Environment Variables Setup

After deployment, you'll need to configure these environment variables in Google Cloud Secret Manager:

### Required Secrets
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `JWT_SECRET` - JWT signing secret
- `NEXTAUTH_SECRET` - NextAuth.js secret
- `OPENAI_API_KEY` - OpenAI API key
- `STRIPE_SECRET_KEY` - Stripe secret key
- Social media API keys (Twitter, LinkedIn, Facebook)

### Set Secrets
```bash
# Example: Set JWT secret
echo -n "your-jwt-secret-here" | gcloud secrets create jwt-secret --data-file=-
```

## 🌐 Service URLs

After deployment, your services will be available at:
- **Frontend**: `https://postiz-frontend-uc.a.run.app`
- **Backend**: `https://postiz-backend-uc.a.run.app`
- **Workers**: `https://postiz-workers-uc.a.run.app`

## 📊 Monitoring and Logging

- **Cloud Run Console**: https://console.cloud.google.com/run?project=postiz-master-social-v1
- **Cloud SQL Console**: https://console.cloud.google.com/sql?project=postiz-master-social-v1
- **Cloud Build Console**: https://console.cloud.google.com/cloud-build?project=postiz-master-social-v1

## 🔄 CI/CD Setup

To set up automatic deployments from your GitHub repository:

1. Connect your GitHub repository to Cloud Build
2. Create a trigger for the `development` branch
3. Configure the trigger to use `cloudbuild.yaml`

## 💰 Cost Estimation

**Free Tier Usage:**
- Cloud Run: 2 million requests/month free
- Cloud SQL: 1 instance with 1GB RAM free
- Cloud Storage: 5GB free
- Cloud Build: 120 build-minutes/day free

**Estimated Monthly Cost (beyond free tier):**
- Cloud Run: ~$10-50/month (depending on traffic)
- Cloud SQL: ~$25/month (db-f1-micro)
- Redis: ~$30/month (basic tier)
- Storage: ~$1-5/month

## 🆘 Troubleshooting

### Common Issues

1. **Billing Not Enabled**: Enable billing in Google Cloud Console
2. **API Not Enabled**: Run `gcloud services enable [API_NAME]`
3. **Permission Denied**: Check IAM roles and permissions
4. **Build Fails**: Check Dockerfile syntax and dependencies

### Useful Commands

```bash
# Check project status
gcloud config get-value project

# List services
gcloud run services list

# View logs
gcloud logging read "resource.type=cloud_run_revision"

# Check build status
gcloud builds list --limit=5
```

## 📞 Support

If you encounter any issues:
1. Check the Google Cloud Console for error messages
2. Review the Cloud Build logs
3. Check the Cloud Run service logs
4. Verify all environment variables are set correctly

---

**Ready to deploy?** Just enable billing and run `./deploy.sh`! 🚀
