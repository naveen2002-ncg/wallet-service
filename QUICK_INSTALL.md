# Quick Installation Guide

## 🚀 Fastest Method (Recommended)

### Step 1: Install Docker Desktop

**Open PowerShell as Administrator** (Right-click PowerShell → "Run as Administrator"):

```powershell
winget install Docker.DockerDesktop
```

After installation:
- **RESTART your computer** (required!)
- Launch Docker Desktop from Start Menu
- Wait for Docker to start (whale icon in system tray)

### Step 2: Verify Docker

Open PowerShell:
```powershell
docker --version
docker-compose --version
```

### Step 3: Start the Application

```powershell
cd d:\wallet-service
docker-compose up --build
```

**That's it!** Docker will automatically:
- Download PostgreSQL 15
- Start PostgreSQL container
- Build your Flask app
- Start the API on http://localhost:5000

---

## 🐘 Alternative: Install PostgreSQL Locally

If you prefer PostgreSQL locally instead of Docker:

**Open PowerShell as Administrator:**

```powershell
winget install PostgreSQL.PostgreSQL
```

During installation:
- Password for `postgres` user: `postgres`
- Port: `5432` (default)

Then start the app:
```powershell
python app/main.py
```

---

## ✅ Quick Test After Installation

Once Docker Desktop is running:

```powershell
cd d:\wallet-service
docker-compose up --build
```

You should see:
- PostgreSQL starting
- Flask application building
- Server running on port 5000

Access the API at: `http://localhost:5000/api/v1/`

---

## 📝 Installation Notes

- **Docker Desktop includes WSL 2** - it will install automatically if needed
- **No separate PostgreSQL needed** - Docker Compose handles it
- **Everything runs in containers** - clean and isolated

See `INSTALLATION.md` for detailed troubleshooting.
