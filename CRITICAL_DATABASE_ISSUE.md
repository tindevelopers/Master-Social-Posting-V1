# 🚨 CRITICAL: Database Environment Variables Missing!

## ⚠️ THE PROBLEM

**Your deployment is failing because the database environment variables are NOT set!**

From the Railway CLI:
```bash
$ railway variables
No variables found
```

This is **CRITICAL** because:

### 1. The Startup Command Requires Database

Look at `package.json` line 17:
```json
"pm2-run": "pm2 delete all || true && pnpm run prisma-db-push && pnpm run --parallel pm2 && pm2 logs"
```

**This runs `prisma-db-push` which needs `DATABASE_URL`!**

### 2. What's Happening During Deployment

```
✅ Build completes (11 minutes)
✅ Container starts
❌ Runs: pnpm run pm2
   ↓
❌ Runs: pnpm run prisma-db-push
   ↓
❌ Prisma tries to connect to database
   ↓
❌ DATABASE_URL not found or invalid
   ↓
❌ Prisma fails
   ↓
❌ PM2 never starts
   ↓
❌ No services running
   ↓
❌ Health check fails (nothing listening on port 5000)
```

---

## 🔍 Why Health Check is Failing

The health check is looking for `/api/health` on port 5000, but:

1. **Nginx** needs to start (listens on port 5000)
2. **Backend** needs to start (provides `/api/health` endpoint)
3. **But startup fails at Prisma** because `DATABASE_URL` is missing
4. **So nothing ever starts!**

---

## ✅ THE SOLUTION

You need to set environment variables in Railway Dashboard!

### Step 1: Go to Railway Dashboard

https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01

### Step 2: Add PostgreSQL Service (if not already added)

1. Click "+ New" → "Database" → "Add PostgreSQL"
2. Railway will create a PostgreSQL instance
3. It will auto-generate `DATABASE_URL`

### Step 3: Add Redis Service (if not already added)

1. Click "+ New" → "Database" → "Add Redis"
2. Railway will create a Redis instance
3. It will auto-generate `REDIS_URL`

### Step 4: Set Environment Variables

Click on your service → "Variables" tab → Add these:

#### Required Variables (CRITICAL):

```bash
# ============================================
# DATABASE (Get from PostgreSQL service)
# ============================================
DATABASE_URL=${{Postgres.DATABASE_URL}}

# ============================================
# REDIS (Get from Redis service)
# ============================================
REDIS_URL=${{Redis.REDIS_URL}}

# ============================================
# JWT SECRET (Generate new one)
# ============================================
JWT_SECRET=I8E8MINMtxCvMsm//ViA0I6jy/qb0vpzA9mb7GKY4YuWtqBydRyQgeKkVGj6nBJP

# ============================================
# APPLICATION URLS
# ============================================
FRONTEND_URL=${{RAILWAY_PUBLIC_DOMAIN}}
NEXT_PUBLIC_BACKEND_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/api
BACKEND_INTERNAL_URL=http://localhost:3000

# ============================================
# GENERAL SETTINGS
# ============================================
IS_GENERAL=true
NODE_ENV=production
PORT=5000
```

#### Storage Variables (REQUIRED for file uploads):

You MUST configure storage. Choose one:

**Option A: Cloudflare R2 (Recommended)**
```bash
STORAGE_PROVIDER=cloudflare
CLOUDFLARE_ACCOUNT_ID=your_account_id
CLOUDFLARE_ACCESS_KEY=your_access_key
CLOUDFLARE_SECRET_ACCESS_KEY=your_secret_key
CLOUDFLARE_BUCKETNAME=your_bucket_name
CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com/
CLOUDFLARE_REGION=auto
```

**Option B: Local Storage (Testing only)**
```bash
STORAGE_PROVIDER=local
```

---

## 🎯 Railway Variable Reference Syntax

Railway has special syntax to reference other services:

```bash
# Reference PostgreSQL service
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Reference Redis service
REDIS_URL=${{Redis.REDIS_URL}}

# Reference your own public domain
FRONTEND_URL=${{RAILWAY_PUBLIC_DOMAIN}}
```

**Important**: Use the EXACT service names as they appear in Railway!

---

## 📋 Quick Setup Checklist

### In Railway Dashboard:

- [ ] **Add PostgreSQL service** (if not exists)
- [ ] **Add Redis service** (if not exists)
- [ ] **Go to your app service** → Variables tab
- [ ] **Add DATABASE_URL** = `${{Postgres.DATABASE_URL}}`
- [ ] **Add REDIS_URL** = `${{Redis.REDIS_URL}}`
- [ ] **Add JWT_SECRET** = (generate or use provided)
- [ ] **Add FRONTEND_URL** = `${{RAILWAY_PUBLIC_DOMAIN}}`
- [ ] **Add NEXT_PUBLIC_BACKEND_URL** = `https://${{RAILWAY_PUBLIC_DOMAIN}}/api`
- [ ] **Add BACKEND_INTERNAL_URL** = `http://localhost:3000`
- [ ] **Add IS_GENERAL** = `true`
- [ ] **Add NODE_ENV** = `production`
- [ ] **Add PORT** = `5000`
- [ ] **Add storage variables** (Cloudflare R2 or local)
- [ ] **Click "Deploy"** to trigger new deployment

---

## 🔧 How to Add Variables in Railway

### Method 1: Raw Editor (Fastest)

1. Go to service → Variables tab
2. Click "Raw Editor"
3. Paste all variables at once:

```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
JWT_SECRET=I8E8MINMtxCvMsm//ViA0I6jy/qb0vpzA9mb7GKY4YuWtqBydRyQgeKkVGj6nBJP
FRONTEND_URL=${{RAILWAY_PUBLIC_DOMAIN}}
NEXT_PUBLIC_BACKEND_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/api
BACKEND_INTERNAL_URL=http://localhost:3000
IS_GENERAL=true
NODE_ENV=production
PORT=5000
STORAGE_PROVIDER=local
```

4. Click "Save"

### Method 2: One by One

1. Go to service → Variables tab
2. Click "+ New Variable"
3. Add each variable individually
4. Click "Save"

---

## 🚀 After Adding Variables

### What Will Happen:

```
✅ Railway detects variable changes
✅ Triggers automatic redeploy
✅ Build completes (11 minutes)
✅ Container starts
✅ Runs: pnpm run pm2
✅ Runs: prisma-db-push
✅ Prisma connects to DATABASE_URL ← NOW WORKS!
✅ Database schema pushed
✅ PM2 starts all services:
   ✅ Nginx (port 5000)
   ✅ Backend (port 3000)
   ✅ Frontend (port 4200)
   ✅ Workers
   ✅ Cron
✅ Health check hits /api/health
✅ Health check passes! ✅
✅ Deployment successful! 🎉
```

---

## 🔍 Verify Variables Are Set

### Using Railway CLI:

```bash
cd /Users/gene/Projects/Master-Social-Posting-V1
railway variables
```

Should show:
```
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
JWT_SECRET=...
FRONTEND_URL=...
...
```

### In Railway Dashboard:

1. Go to service → Variables tab
2. Should see all variables listed
3. Values with `${{...}}` will show resolved values

---

## 🐛 Common Issues

### Issue 1: "No Postgres service found"

**Error**: `${{Postgres.DATABASE_URL}}` doesn't resolve

**Fix**: 
1. Check the exact name of your PostgreSQL service in Railway
2. Use that exact name: `${{YourServiceName.DATABASE_URL}}`
3. Or add PostgreSQL service if it doesn't exist

### Issue 2: "Prisma migration failed"

**Error**: Database schema doesn't match

**Fix**: The `prisma-db-push` command will handle this automatically!

### Issue 3: "Redis connection failed"

**Error**: Can't connect to Redis

**Fix**:
1. Make sure Redis service exists
2. Check `REDIS_URL` is set correctly
3. Use: `${{Redis.REDIS_URL}}`

---

## 📊 Environment Variables Priority

Railway loads variables in this order:

1. **Service Variables** (highest priority) ← Set these!
2. **Shared Variables** (project-wide)
3. **Environment Variables** (dev/prod)
4. **.env file** (lowest priority, not recommended for Railway)

**Always set variables in Service Variables tab!**

---

## 🎯 Minimal Working Configuration

If you just want to test deployment, here's the absolute minimum:

```bash
# Required for startup
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
JWT_SECRET=any-random-string-here
IS_GENERAL=true
NODE_ENV=production

# Required for file uploads
STORAGE_PROVIDER=local

# Required for URLs
FRONTEND_URL=${{RAILWAY_PUBLIC_DOMAIN}}
NEXT_PUBLIC_BACKEND_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/api
BACKEND_INTERNAL_URL=http://localhost:3000
```

This will get the app running. You can add other features later!

---

## 📝 Summary

### The Problem:
- ❌ No environment variables set
- ❌ `DATABASE_URL` missing
- ❌ Prisma can't connect
- ❌ Startup fails
- ❌ Health check fails

### The Solution:
- ✅ Add PostgreSQL service
- ✅ Add Redis service
- ✅ Set all required environment variables
- ✅ Redeploy
- ✅ Everything works!

---

## 🚨 ACTION REQUIRED

**You MUST set environment variables before the deployment can succeed!**

1. **Go to Railway Dashboard NOW**
2. **Add PostgreSQL and Redis services**
3. **Set environment variables in your app service**
4. **Redeploy**

Without these variables, the deployment will continue to fail at the same point (health check timeout) because the services can't start without database access!

---

**See also**:
- `env.railway.example` - Complete environment variables template
- `RAILWAY_SETUP_GUIDE.md` - Step-by-step setup instructions
- `RAILWAY_CREDENTIALS.md` - Generated secrets and templates
