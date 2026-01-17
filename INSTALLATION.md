# Installation Guide - PostgreSQL & Docker

This guide will help you install PostgreSQL and Docker Desktop on Windows.

## 🐳 Docker Desktop Installation

### Option 1: Using winget (Recommended - Fastest)

1. **Open PowerShell as Administrator** (Right-click PowerShell → Run as Administrator)

2. **Install Docker Desktop:**
   ```powershell
   winget install Docker.DockerDesktop
   ```

3. **After installation:**
   - Restart your computer (required for WSL 2)
   - Launch Docker Desktop from Start Menu
   - Wait for Docker to start (whale icon in system tray should be steady)

### Option 2: Manual Download

1. **Download Docker Desktop:**
   - Visit: https://www.docker.com/products/docker-desktop/
   - Download "Docker Desktop for Windows"
   - Run the installer

2. **Follow the installation wizard:**
   - Check "Use WSL 2 instead of Hyper-V" (recommended)
   - Complete the installation
   - **Restart your computer**

3. **Launch Docker Desktop:**
   - Start Docker Desktop from Start Menu
   - Wait for Docker to fully start (may take 1-2 minutes on first launch)

### Verify Docker Installation

Open PowerShell and run:
```powershell
docker --version
docker-compose --version
```

You should see version numbers.

---

## 🐘 PostgreSQL Installation

### Option 1: Using winget (Recommended)

1. **Open PowerShell as Administrator**

2. **Install PostgreSQL:**
   ```powershell
   winget install PostgreSQL.PostgreSQL
   ```

3. **During installation, remember:**
   - Set password for `postgres` user (use: `postgres` for this project)
   - Note the port (default: 5432)
   - Note the installation path

### Option 2: Manual Download

1. **Download PostgreSQL:**
   - Visit: https://www.postgresql.org/download/windows/
   - Click "Download the installer"
   - Download PostgreSQL 15 or 16

2. **Run the installer:**
   - Click "Next" through the wizard
   - **Set a password** for the `postgres` superuser (use: `postgres` for this project)
   - Port: Keep default `5432`
   - Locale: Keep default
   - Complete installation

3. **Verify PostgreSQL is running:**
   - Check Windows Services (services.msc)
   - Look for "postgresql-x64-15" service
   - Ensure it's set to "Automatic" startup

### Option 3: Use PostgreSQL via Docker (No Local Install Needed)

If you install Docker Desktop first, you can use PostgreSQL in Docker without installing it locally. The `docker-compose.yml` already includes PostgreSQL!

---

## 🚀 Quick Start (After Installing Docker)

Once Docker Desktop is installed and running:

1. **Navigate to project directory:**
   ```powershell
   cd d:\wallet-service
   ```

2. **Update .env file** (already created, just verify):
   ```powershell
   Get-Content .env
   ```

3. **Start everything with Docker Compose:**
   ```powershell
   docker-compose up --build
   ```

This will:
- Download PostgreSQL 15 image
- Create and start PostgreSQL container
- Build your Flask application
- Start your Flask API on http://localhost:5000

---

## ✅ Post-Installation Verification

### Test Docker:
```powershell
docker ps
docker-compose --version
```

### Test PostgreSQL (if installed locally):
```powershell
psql --version
psql -U postgres -c "SELECT version();"
```
(Password: `postgres`)

### Test Application:
```powershell
python app/main.py
```
Should start without database connection errors if PostgreSQL is running.

---

## 🔧 Troubleshooting

### Docker Issues:

**Docker won't start:**
- Ensure WSL 2 is installed: `wsl --install`
- Restart computer after WSL 2 installation
- Check if virtualization is enabled in BIOS

**"docker-compose" command not found:**
- Docker Desktop includes docker-compose, but newer versions use: `docker compose` (without hyphen)
- Update your commands or create an alias

### PostgreSQL Issues:

**"password authentication failed":**
- Check `.env` file has correct password
- Reset postgres password: `psql -U postgres` then `ALTER USER postgres PASSWORD 'postgres';`

**PostgreSQL service not running:**
- Open Services (Win+R → `services.msc`)
- Find PostgreSQL service → Right-click → Start
- Set startup type to "Automatic"

**Port 5432 already in use:**
- Another PostgreSQL instance may be running
- Change port in `.env` or stop the other instance

---

## 📝 Recommended Installation Order

1. **Install Docker Desktop first** (includes PostgreSQL option via Docker)
2. **OR** Install PostgreSQL locally if you prefer
3. **Then** start the application with `docker-compose up --build`

---

## 💡 Pro Tip

If you install Docker Desktop, you don't need to install PostgreSQL separately! The `docker-compose.yml` file will handle PostgreSQL automatically.
