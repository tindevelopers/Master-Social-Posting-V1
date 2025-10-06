# Railway Deployment Troubleshooting

## Current Issue: Health Check Failure

**Status**: Deployment failed during network process (health check)

### What This Means:
- ✅ Build succeeded (11:18)
- ✅ Deploy succeeded (1:06)
- ❌ Health check failed (17:12)

The application built and started, but the health check endpoint isn't responding.

## Immediate Actions to Take

### 1. Check the Deployment Logs

Click **"View logs"** in the Railway dashboard to see:
- What errors occurred during startup
- Which services failed to start
- Any connection errors

### 2. Verify Environment Variables

Go to **Variables** tab and ensure these are set:

**Critical Variables:**
```bash
DATABASE_URL=postgresql://...  # From PostgreSQL service
REDIS_URL=redis://...          # From Redis service
JWT_SECRET=your-secret-here
FRONTEND_URL=https://your-domain.railway.app
NEXT_PUBLIC_BACKEND_URL=https://your-domain.railway.app/api
BACKEND_INTERNAL_URL=http://localhost:3000
IS_GENERAL=true
NODE_ENV=production
```

**Storage Variables (Required):**
```bash
STORAGE_PROVIDER=cloudflare
CLOUDFLARE_ACCOUNT_ID=your-id
CLOUDFLARE_ACCESS_KEY=your-key
CLOUDFLARE_SECRET_ACCESS_KEY=your-secret
CLOUDFLARE_BUCKETNAME=your-bucket
CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com/
CLOUDFLARE_REGION=auto
```

### 3. Check Service Settings

Go to **Settings** tab and verify:

- **Port**: Should be `5000` (Nginx port)
- **Health Check Path**: Should be `/api/health`
- **Health Check Timeout**: Increase to `600` seconds (10 minutes)
- **Start Command**: Should be `pnpm run pm2` or auto-detected from Dockerfile

### 4. Verify Branch

Go to **Settings** → **Source**:
- Ensure branch is `railway-cloud-deploy` (not `main`)
- If it's `main`, change it to `railway-cloud-deploy`

## Common Issues and Solutions

### Issue 1: Health Check Path Not Responding

**Symptoms:**
- Build succeeds
- Deploy succeeds
- Health check fails

**Solutions:**

A. **Increase Health Check Timeout**
   - Go to Settings → Health Check Timeout
   - Change from 300 to 600 seconds
   - First boot takes longer due to Prisma migrations

B. **Verify Health Check Path**
   - The path should be `/api/health`
   - This is handled by Nginx → Backend
   - Check if backend is actually starting

C. **Check Port Configuration**
   - Port should be `5000` (Nginx)
   - Nginx proxies `/api/*` to backend on port 3000
   - Frontend runs on port 4200

### Issue 2: Missing Environment Variables

**Symptoms:**
- Services crash on startup
- Database connection errors
- Redis connection errors

**Solutions:**

1. **Copy DATABASE_URL from PostgreSQL service:**
   - Click on PostgreSQL service
   - Go to Variables tab
   - Copy the `DATABASE_URL` value
   - Paste into your main service variables

2. **Copy REDIS_URL from Redis service:**
   - Click on Redis service
   - Go to Variables tab
   - Copy the `REDIS_URL` value
   - Paste into your main service variables

3. **Set all required variables from RAILWAY_CREDENTIALS.md**

### Issue 3: Database Not Ready

**Symptoms:**
- Backend fails to start
- Prisma connection errors
- "Can't reach database server" errors

**Solutions:**

1. **Verify PostgreSQL is running:**
   - Check PostgreSQL service status
   - Should show green/healthy

2. **Check DATABASE_URL format:**
   ```
   postgresql://postgres:password@postgres.railway.internal:5432/railway
   ```

3. **Wait for database to be ready:**
   - First deployment might take longer
   - Database needs to initialize

### Issue 4: Redis Connection Issues

**Symptoms:**
- Workers fail to start
- Queue errors
- BullMQ connection errors

**Solutions:**

1. **Verify Redis is running:**
   - Check Redis service status
   - Should show green/healthy

2. **Check REDIS_URL format:**
   ```
   redis://default:password@redis.railway.internal:6379
   ```

### Issue 5: Cloudflare R2 Not Configured

**Symptoms:**
- Application starts but crashes when uploading
- Storage errors
- Missing file errors

**Solutions:**

1. **Set up Cloudflare R2:**
   - Go to https://dash.cloudflare.com/
   - Create R2 bucket
   - Generate API token
   - Add all CLOUDFLARE_* variables

2. **Or use local storage for testing:**
   ```bash
   STORAGE_PROVIDER=local
   UPLOAD_DIRECTORY=/app/uploads
   ```

### Issue 6: PM2 Process Failures

**Symptoms:**
- Some services start, others don't
- Partial functionality
- Logs show process crashes

**Solutions:**

1. **Check logs for specific service errors:**
   - Look for "backend", "frontend", "workers", "cron" in logs
   - Identify which service is failing

2. **Common PM2 issues:**
   - Memory limits too low (increase to 4GB+)
   - CPU limits too low (increase to 2+ vCPUs)
   - Missing dependencies

## How to View Detailed Logs

### In Railway Dashboard:

1. Click on your service (remarkable-reprieve)
2. Click **"View logs"** button
3. Look for:
   - Red error messages
   - Connection failures
   - Process crashes
   - Port binding issues

### Key Log Patterns to Look For:

**Good Signs:**
```
✓ Nginx started
✓ Backend started on port 3000
✓ Frontend started on port 4200
✓ Workers started
✓ Cron started
✓ Database connected
✓ Redis connected
```

**Bad Signs:**
```
✗ Error: connect ECONNREFUSED (database)
✗ Error: Redis connection failed
✗ Error: Cannot find module
✗ Error: Port already in use
✗ Process exited with code 1
✗ FATAL ERROR: JavaScript heap out of memory
```

## Step-by-Step Fix Process

### Step 1: View Logs
1. Click **"View logs"** in Railway dashboard
2. Copy all error messages
3. Look for the first error (root cause)

### Step 2: Fix Missing Variables
1. Go to **Variables** tab
2. Compare with `RAILWAY_CREDENTIALS.md`
3. Add any missing required variables
4. Save (will trigger redeploy)

### Step 3: Adjust Settings
1. Go to **Settings** tab
2. Increase **Health Check Timeout** to 600
3. Verify **Port** is 5000
4. Verify **Health Check Path** is `/api/health`
5. Save changes

### Step 4: Check Database Services
1. Click on **PostgreSQL** service
2. Verify it's running (green status)
3. Click on **Redis** service
4. Verify it's running (green status)

### Step 5: Redeploy
1. After fixing issues, click **"Redeploy"**
2. Watch the logs in real-time
3. Wait for health check to pass

## Quick Fixes to Try First

### Fix 1: Increase Health Check Timeout
```
Settings → Health Check Timeout → 600 seconds
```

### Fix 2: Add Missing Environment Variables
```
Variables → Raw Editor → Paste from RAILWAY_CREDENTIALS.md
```

### Fix 3: Increase Memory
```
Settings → Memory → 4096 MB (4GB)
Settings → vCPU → 2
```

### Fix 4: Disable Health Check Temporarily
```
Settings → Health Check → Disable
(Just to see if app starts without health check)
```

## What to Check in Logs

When you click "View logs", look for these specific things:

1. **Prisma Migrations:**
   ```
   ✓ Prisma schema loaded
   ✓ Database migrations applied
   ```

2. **Service Startup:**
   ```
   ✓ Nginx listening on port 5000
   ✓ NestJS application started
   ✓ Next.js ready on port 4200
   ```

3. **Database Connection:**
   ```
   ✓ PostgreSQL connected
   ✓ Redis connected
   ```

4. **PM2 Processes:**
   ```
   ✓ backend started
   ✓ frontend started
   ✓ workers started
   ✓ cron started
   ```

## If All Else Fails

### Option 1: Deploy to Main Branch First
1. Merge railway-cloud-deploy to main
2. Deploy from main branch
3. See if issue persists

### Option 2: Simplify Configuration
1. Remove health check temporarily
2. Deploy with minimal env vars
3. Add variables one by one

### Option 3: Check Dockerfile
1. Test Docker build locally:
   ```bash
   docker build -f Dockerfile.dev -t postiz-test .
   docker run -p 5000:5000 postiz-test
   ```

### Option 4: Contact Support
- Railway Discord: https://discord.gg/railway
- Include: deployment logs, error messages, configuration

## Next Steps

1. **Click "View logs"** in the Railway dashboard
2. **Copy the error messages** you see
3. **Check which specific service is failing**
4. **Apply the relevant fix from above**
5. **Redeploy and monitor**

---

**Current Status:**
- Service: remarkable-reprieve
- Status: Failed (health check)
- Build Time: 11:18 (successful)
- Deploy Time: 1:06 (successful)
- Health Check: Failed after 17:12

**Most Likely Fix:**
1. Increase health check timeout to 600 seconds
2. Verify all environment variables are set
3. Check logs for specific error messages
