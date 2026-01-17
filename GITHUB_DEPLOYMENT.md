# 🚀 GitHub Deployment Guide

## Step-by-Step: Push to GitHub and Deploy

### ✅ Step 1: Prepare Repository (Already Done)
- ✅ `.gitignore` file created (excludes `.env` and sensitive files)
- ✅ Git repository initialized
- ✅ All project files ready

---

### 📝 Step 2: Configure Git (Required)

Before committing, set your Git identity:

```powershell
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

**Replace with your actual name and email.**

---

### 📦 Step 3: Add Files and Commit

```powershell
# Add all files (except those in .gitignore)
git add .

# Check what will be committed (verify .env is NOT included)
git status

# Create initial commit
git commit -m "Initial commit: Wallet Service backend API with frontend"
```

---

### 🔗 Step 4: Create GitHub Repository

1. **Go to GitHub**: https://github.com
2. **Sign in** or create account
3. **Click** "+" icon → "New repository"
4. **Repository name**: `wallet-service` (or your preferred name)
5. **Visibility**: Choose Public or Private
6. **DO NOT** initialize with README, .gitignore, or license (we already have them)
7. **Click** "Create repository"

---

### 🚀 Step 5: Push to GitHub

After creating the repository, GitHub will show you commands. Use these:

```powershell
# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/wallet-service.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

**Or if using SSH:**
```powershell
git remote add origin git@github.com:YOUR_USERNAME/wallet-service.git
git branch -M main
git push -u origin main
```

---

### 🔐 Step 6: Verify .env is NOT in Repository

**IMPORTANT:** Ensure `.env` is NOT pushed to GitHub:

```powershell
# Check if .env is being tracked (should show nothing)
git ls-files | Select-String "\.env"
```

If `.env` appears in the output, remove it:
```powershell
git rm --cached .env
git commit -m "Remove .env from repository"
git push
```

---

### ✅ Step 7: Deploy to Railway (After GitHub Push)

Once your code is on GitHub:

1. **Go to Railway**: https://railway.app
2. **Sign in** with GitHub
3. **Click** "New Project"
4. **Select** "Deploy from GitHub repo"
5. **Choose** your `wallet-service` repository
6. **Railway will automatically:**
   - Detect Dockerfile
   - Start building

7. **Add PostgreSQL Database:**
   - Click "New" → "Database" → "PostgreSQL"

8. **Set Environment Variables:**
   - Go to your app service → Variables tab
   - Add:
     ```
     SECRET_KEY=your-random-secret-key-here
     JWT_SECRET_KEY=your-random-jwt-secret-here
     DATABASE_URL=${{Postgres.DATABASE_URL}}
     ```

9. **Deploy:**
   - Railway will automatically deploy
   - Get your public URL: `https://your-app.railway.app`

---

## 🔒 Security Checklist

Before pushing to GitHub, verify:

- ✅ `.env` is in `.gitignore`
- ✅ `.env` file exists locally but is NOT committed
- ✅ No secrets/keys in code files
- ✅ `.env.example` exists (safe to commit)

---

## 📋 Quick Commands Summary

```powershell
# 1. Configure Git (one time)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 2. Add and commit
git add .
git commit -m "Initial commit: Wallet Service"

# 3. Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/wallet-service.git

# 4. Push to GitHub
git branch -M main
git push -u origin main
```

---

## 🎯 After Pushing to GitHub

Your repository will be at:
```
https://github.com/YOUR_USERNAME/wallet-service
```

Then deploy to Railway using the GitHub repository!

---

## ❓ Troubleshooting

### Git Authentication Issue:
If push fails, you may need to authenticate:
- Use GitHub Personal Access Token instead of password
- Or set up SSH keys

### File Already Committed Error:
If `.env` was accidentally committed:
```powershell
git rm --cached .env
git commit -m "Remove .env"
git push
```

---

**Ready to push?** Follow the steps above! 🚀
