# 🔄 How Railway Detects GitHub Changes

## Overview

Railway automatically detects changes to your GitHub repository using **GitHub Webhooks**. Here's exactly how it works:

---

## 🎯 The Process

### 1. Initial Setup (Done Once)

When you first connected your GitHub repository to Railway:

```
You → Railway Dashboard → "Connect GitHub Repo"
                ↓
Railway → GitHub → "Install Railway App"
                ↓
GitHub → Creates Webhook → Points to Railway
                ↓
Railway → Subscribes to push events
```

**What Railway installed:**
- GitHub App integration
- Webhook URL: `https://backboard.railway.app/webhooks/github`
- Permissions: Read repository, receive push events

---

### 2. Automatic Detection (Every Push)

```
┌─────────────────────────────────────────────────────────────┐
│  You Push Code to GitHub                                    │
│  $ git push origin main                                     │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  GitHub Sends Webhook                                        │
│  POST https://backboard.railway.app/webhooks/github         │
│  {                                                           │
│    "ref": "refs/heads/main",                                │
│    "repository": "tindevelopers/Master-Social-Posting-V1",  │
│    "commits": [...],                                        │
│    "pusher": {...}                                          │
│  }                                                           │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Railway Receives Webhook                                    │
│  1. Checks: Is this the configured branch?                  │
│  2. Checks: Are auto-deploys enabled?                       │
│  3. Checks: Any deployment restrictions?                    │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Railway Triggers Deployment                                 │
│  ✅ Pulls latest code from GitHub                           │
│  ✅ Reads railway.toml / railway.yaml                       │
│  ✅ Starts build process                                    │
│  ✅ Deploys when build succeeds                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚡ Real-Time Detection

**Speed**: Near-instant (typically 1-5 seconds)

```
0:00 - You: git push origin main
0:02 - GitHub: Webhook sent to Railway
0:03 - Railway: Webhook received
0:04 - Railway: Deployment queued
0:05 - Railway: Build started
```

---

## 🔧 How Railway Knows Which Branch to Deploy

Railway checks in this order:

### 1. Service Settings (Highest Priority)
```
Railway Dashboard → Service → Settings → Source → Branch
```
**Current**: `railway-cloud-deploy` (you need to change this to `main`)

### 2. Railway Configuration Files
```yaml
# railway.yaml (optional)
$schema: https://railway.app/railway.schema.json
# No branch specified here - uses service settings
```

### 3. Default Behavior
If no branch is specified, Railway uses the repository's default branch (usually `main` or `master`)

---

## 📊 Your Current Setup

### Repository
- **GitHub**: `tindevelopers/Master-Social-Posting-V1`
- **Owner**: tindevelopers
- **Webhook**: ✅ Installed by Railway

### Railway Service
- **Project**: postiz-master-social
- **Service**: remarkable-reprieve
- **Current Branch**: `railway-cloud-deploy` ⚠️ (needs change to `main`)
- **Auto-Deploy**: ✅ Enabled (default)

### What Happens Now

**When you push to `main`:**
```
✅ GitHub webhook fires
✅ Railway receives it
❌ Railway ignores it (wrong branch)
   → Configured branch: railway-cloud-deploy
   → Push was to: main
   → No deployment triggered
```

**When you push to `railway-cloud-deploy`:**
```
✅ GitHub webhook fires
✅ Railway receives it
✅ Railway checks: branch matches!
✅ Deployment triggered automatically
```

---

## 🎯 After You Change to Main Branch

**When you push to `main`:**
```
✅ GitHub webhook fires
✅ Railway receives it
✅ Railway checks: branch matches!
✅ Deployment triggered automatically
🚀 Build starts → Deploy → Services start
```

---

## 🔍 Verify Webhook Exists

### In GitHub:

1. Go to: https://github.com/tindevelopers/Master-Social-Posting-V1/settings/hooks

2. Look for Railway webhook:
   ```
   Payload URL: https://backboard.railway.app/webhooks/github
   Content type: application/json
   Events: Just the push event
   Status: ✓ Active
   ```

3. Recent Deliveries:
   - Should show successful webhook deliveries
   - Status: 200 OK

### In Railway:

1. Go to: https://railway.com/project/2195e52e-cb35-474d-b236-ee0db7572e01

2. Click on service → Deployments tab

3. You should see:
   - Triggered by: GitHub Push
   - Branch: railway-cloud-deploy (currently)
   - Commit: [hash]

---

## 🚀 Deployment Triggers

Railway can trigger deployments in 3 ways:

### 1. Automatic (Webhook) - Default ✅
```
git push → GitHub webhook → Railway auto-deploys
```
**Fastest**: 1-5 seconds after push

### 2. Manual (Dashboard)
```
Railway Dashboard → Service → Click "Deploy"
```
**Use when**: You want to redeploy without new code

### 3. CLI
```bash
railway up
```
**Use when**: Deploying from local machine

### 4. API
```bash
curl -X POST https://backboard.railway.app/project/[id]/service/[id]/deploy
```
**Use when**: CI/CD pipeline integration

---

## ⚙️ Auto-Deploy Settings

### Check if Auto-Deploy is Enabled:

1. Railway Dashboard → Service → Settings
2. Look for "Auto Deploy" or "Deployment Triggers"
3. Should be: ✅ Enabled (default)

### Disable Auto-Deploy (if needed):
```
Settings → Deployment Triggers → Toggle off
```
Then deployments only happen manually.

---

## 🔔 Webhook Events Railway Listens To

Railway subscribes to these GitHub events:

| Event | What Triggers It | Railway Action |
|-------|------------------|----------------|
| `push` | `git push` to branch | ✅ Deploy if branch matches |
| `pull_request` | PR opened/updated | ⚠️ Optional PR previews |
| `release` | GitHub release created | ⚠️ Optional |

**Default**: Only `push` events trigger deployments

---

## 🐛 Troubleshooting

### Webhook Not Working?

**Check 1: Webhook Exists**
```
GitHub Repo → Settings → Webhooks
Should see: Railway webhook with ✓ Active
```

**Check 2: Recent Deliveries**
```
Click on webhook → Recent Deliveries
Should show: 200 OK responses
If 4xx/5xx: Webhook is failing
```

**Check 3: Railway Connection**
```
Railway Dashboard → Service → Settings → Source
Should show: Connected to GitHub
If not: Reconnect repository
```

### Pushes Not Triggering Deployment?

**Reason 1: Wrong Branch**
```
✅ Fix: Change branch in Railway service settings
```

**Reason 2: Auto-Deploy Disabled**
```
✅ Fix: Enable in service settings
```

**Reason 3: Webhook Deleted**
```
✅ Fix: Disconnect and reconnect GitHub repo in Railway
```

**Reason 4: GitHub App Uninstalled**
```
✅ Fix: Reinstall Railway GitHub App
```

---

## 📝 Summary

### How It Works:
1. **You push code** → `git push origin main`
2. **GitHub fires webhook** → Sends event to Railway
3. **Railway receives webhook** → Checks branch and settings
4. **Railway triggers deployment** → If branch matches
5. **Build and deploy** → Automatic process

### Current State:
- ✅ Webhook installed and working
- ✅ Auto-deploy enabled
- ⚠️ Branch set to `railway-cloud-deploy` (needs change to `main`)

### After Changing to Main:
- ✅ Push to main → Auto-deploy
- ✅ Near-instant detection (1-5 seconds)
- ✅ No manual intervention needed
- ✅ Standard CI/CD workflow

---

## 🎯 Next Steps

1. **Change branch in Railway Dashboard**:
   - Service → Settings → Source → Branch → Change to `main`

2. **Push to main**:
   ```bash
   git push origin main
   ```

3. **Watch automatic deployment**:
   - Railway Dashboard → Deployments
   - Should see: "Triggered by GitHub Push"
   - Branch: main
   - Status: Building → Deploying → Success ✅

4. **Future pushes**:
   - Just `git push origin main`
   - Railway handles the rest automatically!

---

**TL;DR**: Railway uses GitHub webhooks to detect pushes in real-time (1-5 seconds). When you push to the configured branch, Railway automatically pulls the code and deploys. You just need to change the branch from `railway-cloud-deploy` to `main` in the service settings!
