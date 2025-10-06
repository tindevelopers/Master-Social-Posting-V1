# 🏠 Local Deployment Guide

## Quick Start - Deploy to Localhost

This guide will help you run the Postiz application on your local machine for development.

---

## 📋 Prerequisites

### Required:
- ✅ Node.js 20.x (You have: v24.8.0 - compatible!)
- ✅ pnpm 10.6.1 (You have it!)
- ✅ Docker Desktop (You have: v28.1.1)

### What You Need to Do:
1. **Start Docker Desktop** (if not running)
2. Run the setup commands below

---

## 🚀 Quick Start (5 Steps)

### Step 1: Start Docker Desktop

```bash
# Open Docker Desktop application
# Wait for it to fully start (green icon in menu bar)
```

Or run:
```bash
open -a Docker
```

### Step 2: Start PostgreSQL & Redis

```bash
cd /Users/gene/Projects/Master-Social-Posting-V1

# Start database and cache services
pnpm run dev:docker
```

This will start:
- **PostgreSQL** on `localhost:5432`
- **Redis** on `localhost:6379`
- **pgAdmin** on `localhost:8081` (optional - for database management)
- **RedisInsight** on `localhost:5540` (optional - for Redis management)

### Step 3: Install Dependencies (if not already done)

```bash
pnpm install
```

### Step 4: Setup Database Schema

```bash
# Generate Prisma client and push schema to database
pnpm run prisma-db-push
```

### Step 5: Start the Application

```bash
# Start all services in development mode
pnpm run dev
```

This will start:
- **Frontend** (Next.js): http://localhost:4200
- **Backend** (NestJS): http://localhost:3000
- **Workers**: Background job processing
- **Cron**: Scheduled tasks

---

## 🎯 Access the Application

Once everything is running:

- **Main Application**: http://localhost:4200
- **API Docs**: http://localhost:3000/api
- **pgAdmin** (Database UI): http://localhost:8081
  - Email: `admin@admin.com`
  - Password: `admin`
- **RedisInsight** (Redis UI): http://localhost:5540

---

## 📊 What's Running?

### Docker Services:
```
postiz-postgres    → localhost:5432
postiz-redis       → localhost:6379
postiz-pg-admin    → localhost:8081
postiz-redisinsight → localhost:5540
```

### Application Services:
```
Frontend (Next.js)  → localhost:4200
Backend (NestJS)    → localhost:3000
Workers             → Background
Cron                → Background
```

---

## 🔧 Environment Variables

A `.env` file has been created with local development settings:

```bash
DATABASE_URL=postgresql://postiz-local:postiz-local-pwd@localhost:5432/postiz-db-local
REDIS_URL=redis://localhost:6379
JWT_SECRET=local-development-jwt-secret-change-in-production
FRONTEND_URL=http://localhost:4200
NEXT_PUBLIC_BACKEND_URL=http://localhost:3000/api
BACKEND_INTERNAL_URL=http://localhost:3000
STORAGE_PROVIDER=local
IS_GENERAL=true
NODE_ENV=development
API_LIMIT=30
```

---

## 🛠️ Useful Commands

### Start Everything:
```bash
pnpm run dev
```

### Start Individual Services:
```bash
pnpm run dev:frontend   # Just the frontend
pnpm run dev:backend    # Just the backend
pnpm run dev:workers    # Just the workers
pnpm run dev:cron       # Just the cron jobs
```

### Database Commands:
```bash
pnpm run prisma-generate    # Generate Prisma client
pnpm run prisma-db-push     # Push schema to database
pnpm run prisma-reset       # Reset database (WARNING: deletes all data!)
```

### Docker Commands:
```bash
pnpm run dev:docker         # Start Docker services
docker-compose -f docker-compose.dev.yaml down    # Stop Docker services
docker-compose -f docker-compose.dev.yaml logs    # View Docker logs
```

---

## 🐛 Troubleshooting

### Issue 1: Docker Not Running

**Error**: `Cannot connect to the Docker daemon`

**Solution**:
```bash
# Start Docker Desktop
open -a Docker

# Wait for Docker to fully start (green icon in menu bar)
# Then retry: pnpm run dev:docker
```

### Issue 2: Port Already in Use

**Error**: `Port 5432 is already allocated` or similar

**Solution**:
```bash
# Check what's using the port
lsof -i :5432

# Stop the Docker services
docker-compose -f docker-compose.dev.yaml down

# Start again
pnpm run dev:docker
```

### Issue 3: Database Connection Failed

**Error**: `Can't reach database server at localhost:5432`

**Solution**:
```bash
# Make sure Docker services are running
docker ps

# Should see: postiz-postgres and postiz-redis

# If not running:
pnpm run dev:docker
```

### Issue 4: Prisma Schema Issues

**Error**: `Prisma schema not found` or `Client not generated`

**Solution**:
```bash
# Regenerate Prisma client
pnpm run prisma-generate

# Push schema to database
pnpm run prisma-db-push
```

### Issue 5: Build Errors

**Error**: Various build/compilation errors

**Solution**:
```bash
# Clean install
rm -rf node_modules
pnpm install

# Rebuild
pnpm run build
```

---

## 🔄 Starting Fresh

If you want to completely reset everything:

```bash
# Stop all services
docker-compose -f docker-compose.dev.yaml down -v

# Remove node_modules
rm -rf node_modules

# Clean install
pnpm install

# Start Docker services
pnpm run dev:docker

# Setup database
pnpm run prisma-db-push

# Start application
pnpm run dev
```

---

## 📝 Development Workflow

### Typical Development Session:

1. **Start Docker** (once per session):
   ```bash
   pnpm run dev:docker
   ```

2. **Start Application** (in a new terminal):
   ```bash
   pnpm run dev
   ```

3. **Make Changes** to code - Hot reload is enabled!

4. **Stop Application** (when done):
   - Press `Ctrl+C` in the terminal

5. **Stop Docker** (optional - can leave running):
   ```bash
   docker-compose -f docker-compose.dev.yaml down
   ```

---

## 🎨 Development Features

### Hot Reload:
- ✅ Frontend changes reload automatically
- ✅ Backend restarts on code changes
- ✅ No need to manually restart

### Database Management:
- Access pgAdmin at http://localhost:8081
- View/edit data directly
- Run SQL queries

### Redis Management:
- Access RedisInsight at http://localhost:5540
- View cached data
- Monitor Redis performance

---

## 📊 Monitoring

### View Logs:

**All services:**
```bash
# In the terminal running pnpm run dev
# Logs will stream automatically
```

**Docker services:**
```bash
docker-compose -f docker-compose.dev.yaml logs -f
```

**Specific service:**
```bash
docker logs postiz-postgres -f
docker logs postiz-redis -f
```

---

## 🧪 Testing

### Run Tests:
```bash
pnpm test
```

### Run Tests with Coverage:
```bash
pnpm test -- --coverage
```

---

## 🔐 Adding Social Media Integrations

To test social media integrations locally, add API keys to `.env`:

```bash
# Twitter/X
X_API_KEY=your_key_here

# Facebook
FACEBOOK_APP_ID=your_app_id
FACEBOOK_APP_SECRET=your_secret

# Instagram
INSTAGRAM_APP_ID=your_app_id
INSTAGRAM_APP_SECRET=your_secret

# LinkedIn
LINKEDIN_CLIENT_ID=your_client_id
LINKEDIN_CLIENT_SECRET=your_secret

# YouTube
YOUTUBE_CLIENT_ID=your_client_id
YOUTUBE_CLIENT_SECRET=your_secret

# TikTok
TIKTOK_CLIENT_KEY=your_key
TIKTOK_CLIENT_SECRET=your_secret
```

---

## 🎯 Next Steps

1. **Start Docker Desktop** ✅
2. **Run**: `pnpm run dev:docker` ✅
3. **Run**: `pnpm run prisma-db-push` ✅
4. **Run**: `pnpm run dev` ✅
5. **Open**: http://localhost:4200 ✅

---

## 📚 Additional Resources

- **Prisma Docs**: https://www.prisma.io/docs
- **Next.js Docs**: https://nextjs.org/docs
- **NestJS Docs**: https://docs.nestjs.com
- **Postiz Docs**: https://docs.postiz.com

---

## 🆘 Need Help?

If you encounter issues:
1. Check the troubleshooting section above
2. View logs: `pnpm run dev` (in terminal)
3. Check Docker: `docker ps`
4. Verify .env file exists and has correct values

---

**Happy Coding! 🚀**
