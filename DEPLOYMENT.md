# 🚀 Deployment Guide - Wallet Service

This guide will help you deploy your Wallet Service to get a public URL.

## 📋 Prerequisites

Before deploying, ensure you have:
- ✅ Git installed and repository initialized
- ✅ Account on deployment platform (choose one below)
- ✅ Docker Compose files ready (you already have them!)

---

## 🎯 Recommended Deployment Platforms

### Option 1: Railway (Easiest - Recommended) ⭐

**Railway is the easiest option with free tier and automatic deployments.**

#### Steps:

1. **Sign up**: Go to https://railway.app and sign up (free tier available)

2. **Install Railway CLI** (optional, or use web interface):
   ```powershell
   winget install Railway
   ```

3. **Login**:
   ```powershell
   railway login
   ```

4. **Create new project**:
   ```powershell
   railway init
   ```

5. **Add PostgreSQL database**:
   - Go to Railway dashboard
   - Click "New" → "Database" → "PostgreSQL"
   - Copy the DATABASE_URL

6. **Add environment variables**:
   ```powershell
   railway variables set SECRET_KEY=your-secret-key-here
   railway variables set JWT_SECRET_KEY=your-jwt-secret-key-here
   railway variables set DATABASE_URL=${{Postgres.DATABASE_URL}}
   ```

7. **Deploy**:
   ```powershell
   railway up
   ```

**Railway automatically:**
- Detects Dockerfile
- Builds and deploys your app
- Provides public URL (like: https://your-app.railway.app)

---

### Option 2: Render (Free Tier Available)

**Good alternative with free tier for PostgreSQL.**

#### Steps:

1. **Sign up**: Go to https://render.com (free tier available)

2. **Create Web Service**:
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Or use "Public Git Repository" to connect directly

3. **Configure Service**:
   - **Name**: wallet-service
   - **Environment**: Docker
   - **Build Command**: (leave empty, Render uses Dockerfile)
   - **Start Command**: (leave empty)

4. **Create PostgreSQL Database**:
   - Click "New +" → "PostgreSQL"
   - Choose free tier
   - Copy "Internal Database URL"

5. **Add Environment Variables** in Web Service settings:
   ```
   SECRET_KEY=your-secret-key-here
   JWT_SECRET_KEY=your-jwt-secret-key-here
   DATABASE_URL=<Internal Database URL from PostgreSQL>
   ```

6. **Deploy**: Click "Create Web Service"
   - Render will automatically build and deploy
   - Get public URL (like: https://wallet-service.onrender.com)

---

### Option 3: Fly.io (Docker-Optimized)

**Great for Docker applications with global deployment.**

#### Steps:

1. **Sign up**: Go to https://fly.io (free tier available)

2. **Install Fly CLI**:
   ```powershell
   powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
   ```

3. **Login**:
   ```powershell
   fly auth login
   ```

4. **Create app**:
   ```powershell
   fly launch --name wallet-service
   ```

5. **Create PostgreSQL database**:
   ```powershell
   fly postgres create --name wallet-db
   fly postgres attach wallet-db --app wallet-service
   ```

6. **Set secrets**:
   ```powershell
   fly secrets set SECRET_KEY=your-secret-key-here
   fly secrets set JWT_SECRET_KEY=your-jwt-secret-key-here
   ```

7. **Deploy**:
   ```powershell
   fly deploy
   ```

**Get URL**: `https://wallet-service.fly.dev`

---

### Option 4: Heroku (Traditional, Requires Credit Card)

**Classic option but requires payment now.**

#### Steps:

1. **Sign up**: https://heroku.com

2. **Install Heroku CLI**:
   ```powershell
   winget install Heroku.HerokuCLI
   ```

3. **Login**:
   ```powershell
   heroku login
   ```

4. **Create app**:
   ```powershell
   heroku create wallet-service
   ```

5. **Create PostgreSQL addon**:
   ```powershell
   heroku addons:create heroku-postgresql:mini
   ```

6. **Set config vars**:
   ```powershell
   heroku config:set SECRET_KEY=your-secret-key
   heroku config:set JWT_SECRET_KEY=your-jwt-secret
   ```

7. **Deploy**:
   ```powershell
   git push heroku main
   ```

**Get URL**: `https://wallet-service.herokuapp.com`

---

## 🐳 Docker Deployment (Any Platform)

Since you already have Docker, you can deploy anywhere that supports Docker.

### Quick Docker Deployment Steps:

1. **Build Docker image** (already done):
   ```powershell
   docker build -t wallet-service .
   ```

2. **Tag for deployment** (example for Docker Hub):
   ```powershell
   docker tag wallet-service yourusername/wallet-service:latest
   ```

3. **Push to Docker Hub**:
   ```powershell
   docker login
   docker push yourusername/wallet-service:latest
   ```

4. **Deploy on platform** that supports Docker images

---

## 📝 Pre-Deployment Checklist

Before deploying, update these:

### 1. Update docker-compose.yml for Production

Create `docker-compose.prod.yml`:

```yaml
version: "3.8"

services:
  app:
    build: .
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - SECRET_KEY=${SECRET_KEY}
      - JWT_SECRET_KEY=${JWT_SECRET_KEY}
    ports:
      - "5000:5000"
    restart: always
```

### 2. Update Configuration

Update `app/config.py` to handle production database URLs:

```python
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv("SECRET_KEY")
    # Support both local and production DATABASE_URL formats
    DATABASE_URL = os.getenv("DATABASE_URL")
    if DATABASE_URL and DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)
    SQLALCHEMY_DATABASE_URI = DATABASE_URL or "postgresql://postgres:postgres@localhost:5432/walletdb"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
    JWT_ACCESS_TOKEN_EXPIRES = False
```

### 3. Update Frontend API URL

Update `login.html` and `dashboard.html` to use production URL:

```javascript
// Change from:
const API_BASE = 'http://localhost:5000/api/v1';

// To (for Railway example):
const API_BASE = 'https://wallet-service.railway.app/api/v1';
```

Or use environment-based detection:
```javascript
const API_BASE = window.location.origin + '/api/v1';
```

---

## 🚀 Quick Start - Railway (Recommended)

I'll create a ready-to-deploy setup for Railway.

### Step 1: Create Railway Account
- Visit: https://railway.app
- Sign up with GitHub (recommended)

### Step 2: Initialize Git Repository

```powershell
git init
git add .
git commit -m "Initial commit - Wallet Service"
```

### Step 3: Connect to Railway
- Go to Railway dashboard
- Click "New Project"
- Select "Deploy from GitHub repo" (or "Empty Project")

### Step 4: Add PostgreSQL
- Click "New" → "Database" → "PostgreSQL"
- Railway automatically creates DATABASE_URL

### Step 5: Set Environment Variables
In Railway project settings → Variables:
```
SECRET_KEY=generate-random-string-here
JWT_SECRET_KEY=generate-another-random-string-here
DATABASE_URL=${{Postgres.DATABASE_URL}}
```

### Step 6: Deploy!
- Railway auto-detects Dockerfile
- Builds and deploys automatically
- Get your public URL!

---

## 📊 Platform Comparison

| Platform | Free Tier | Docker Support | PostgreSQL | Ease of Use | Recommended |
|----------|-----------|----------------|------------|-------------|-------------|
| **Railway** | ✅ Yes | ✅ Yes | ✅ Yes | ⭐⭐⭐⭐⭐ | ⭐ Best |
| **Render** | ✅ Yes | ✅ Yes | ✅ Yes | ⭐⭐⭐⭐ | ⭐⭐ Good |
| **Fly.io** | ✅ Yes | ✅ Yes | ✅ Yes | ⭐⭐⭐ | ⭐⭐ Good |
| **Heroku** | ❌ Paid | ✅ Yes | ✅ Yes | ⭐⭐⭐⭐ | ⭐ Okay |

---

## 🔗 After Deployment

Once deployed, you'll get a URL like:
- Railway: `https://your-app.railway.app`
- Render: `https://wallet-service.onrender.com`
- Fly.io: `https://wallet-service.fly.dev`

**Access your application:**
- Frontend: `https://your-url.com` (Login page)
- API: `https://your-url.com/api/v1` (API endpoints)

---

## 🛠️ Need Help?

If you need help with deployment:
1. Check platform-specific documentation
2. Check deployment logs for errors
3. Verify environment variables are set correctly
4. Ensure DATABASE_URL is properly formatted

**Recommended Next Step:** Start with **Railway** - it's the easiest! 🚀
