#!/bin/bash

# Postiz Google Cloud Run Deployment Script
# This script deploys the Postiz application to Google Cloud Run

set -e

# Configuration
PROJECT_ID="postiz-production"
REGION="us-central1"
SERVICE_ACCOUNT="postiz-deploy@${PROJECT_ID}.iam.gserviceaccount.com"

echo "🚀 Starting Postiz deployment to Google Cloud Run..."

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Google Cloud CLI is not installed. Please install it first."
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Not authenticated with Google Cloud. Please run 'gcloud auth login'"
    exit 1
fi

# Set the project
echo "📋 Setting project to ${PROJECT_ID}..."
gcloud config set project ${PROJECT_ID}

# Enable required APIs
echo "🔧 Enabling required Google Cloud APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable redis.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable secretmanager.googleapis.com

# Create Cloud SQL PostgreSQL instance
echo "🗄️ Creating Cloud SQL PostgreSQL instance..."
gcloud sql instances create postiz-db \
    --database-version=POSTGRES_15 \
    --tier=db-f1-micro \
    --region=${REGION} \
    --storage-type=SSD \
    --storage-size=10GB \
    --backup \
    --enable-ip-alias \
    --authorized-networks=0.0.0.0/0 \
    --quiet || echo "Database instance may already exist"

# Create database
echo "📊 Creating database..."
gcloud sql databases create postiz_production \
    --instance=postiz-db \
    --quiet || echo "Database may already exist"

# Create database user
echo "👤 Creating database user..."
gcloud sql users create postiz \
    --instance=postiz-db \
    --password=$(openssl rand -base64 32) \
    --quiet || echo "User may already exist"

# Create Memorystore Redis instance
echo "🔴 Creating Memorystore Redis instance..."
gcloud redis instances create postiz-redis \
    --size=1 \
    --region=${REGION} \
    --redis-version=redis_7_0 \
    --tier=basic \
    --quiet || echo "Redis instance may already exist"

# Create Cloud Storage bucket
echo "🪣 Creating Cloud Storage bucket..."
gsutil mb gs://${PROJECT_ID}-postiz-storage || echo "Bucket may already exist"

# Build and push containers
echo "🏗️ Building and pushing containers..."
gcloud builds submit --config cloudbuild.yaml .

# Get database connection details
DB_HOST=$(gcloud sql instances describe postiz-db --format="value(ipAddresses[0].ipAddress)")
REDIS_HOST=$(gcloud redis instances describe postiz-redis --region=${REGION} --format="value(host)")

echo "✅ Deployment completed successfully!"
echo ""
echo "📋 Service URLs:"
echo "Frontend: https://postiz-frontend-uc.a.run.app"
echo "Backend: https://postiz-backend-uc.a.run.app"
echo "Workers: https://postiz-workers-uc.a.run.app"
echo ""
echo "🔧 Next steps:"
echo "1. Set up environment variables in Google Cloud Secret Manager"
echo "2. Configure domain and SSL certificates"
echo "3. Set up monitoring and logging"
echo "4. Configure CI/CD pipeline"
echo ""
echo "Database Host: ${DB_HOST}"
echo "Redis Host: ${REDIS_HOST}"
