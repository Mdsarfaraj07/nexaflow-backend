# 🚀 NexaFlow v3.0 - Complete Deployment Guide

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (Node.js)                   │
│              Port 3000 - Vue.js / HTML Pages            │
│          Handles UI, Auth, Payment Integration          │
└────────────────────┬────────────────────────────────────┘
                     │ (HTTP/API Calls)
                     │
┌────────────────────▼────────────────────────────────────┐
│                Backend (Spring Boot)                    │
│              Port 8080 - REST API                       │
│      JWT Auth, Database, Payment Processing             │
└────────────────────┬────────────────────────────────────┘
                     │ (JDBC/MySQL)
                     │
┌────────────────────▼────────────────────────────────────┐
│                 MySQL Database                          │
│              Port 3306 - Persistence                    │
│      Users, Bookings, Payments, Projects, etc.          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Start (Development)

### 1. Environment Setup

#### Frontend (.env)
```bash
cd nexaflow-v3-complete
cp .env .env.local

# Edit .env.local with your development values
PORT=3000
NODE_ENV=development
BACKEND_URL=http://localhost:8080
RAZORPAY_KEY_ID=rzp_test_xxxxx
# ... other keys
```

#### Backend (application.properties)
```bash
cd nexaflow-backend

# The development profile is default (H2 in-memory database)
# To use MySQL:
# 1. Update application.properties database config
# 2. Create database: mysql -u root -p
#    > CREATE DATABASE nexaflow_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. Run Services Individually

#### Start Backend
```bash
cd nexaflow-backend
mvn clean spring-boot:run
# Backend runs on http://localhost:8080
```

#### Start Frontend
```bash
cd nexaflow-v3-complete
npm install
npm start
# Frontend runs on http://localhost:3000
```

---

## Docker Deployment (Production)

### 1. Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ RAM
- 10GB+ disk space

### 2. Environment Configuration

Copy and configure the environment variables:

```bash
# From project root
cp .env.example .env

# Edit .env with production values
nano .env
```

**Key variables to set:**

```env
# Database
DB_HOST=mysql
DB_PORT=3306
DB_NAME=nexaflow_db
DB_USER=nexaflow
DB_PASSWORD=<strong_secure_password>
DB_ROOT_PASSWORD=<strong_root_password>

# Backend Security
JWT_SECRET=<generate_32_char_random_string>
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Payment Gateways
RAZORPAY_KEY_ID=rzp_live_xxxxx
RAZORPAY_KEY_SECRET=xxxxx
STRIPE_API_KEY=sk_live_xxxxx
STRIPE_PUBLISHABLE_KEY=pk_live_xxxxx

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
MAIL_FROM=NexaFlow <noreply@yourdomain.com>

# Frontend URLs
APP_URL=https://yourdomain.com
BACKEND_URL=https://api.yourdomain.com
```

### 3. Build and Deploy

```bash
# Build images
docker-compose -f docker-compose.production.yml build

# Start services
docker-compose -f docker-compose.production.yml up -d

# View logs
docker-compose -f docker-compose.production.yml logs -f

# Stop services
docker-compose -f docker-compose.production.yml down
```

### 4. Health Checks

```bash
# Check backend health
curl http://localhost:8080/actuator/health

# Check frontend
curl http://localhost:3000

# Check MySQL
docker exec nexaflow-mysql mysqladmin ping
```

---

## Manual Deployment (Linux/VPS)

### 1. Server Preparation

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java 17
sudo apt install openjdk-17-jdk -y

# Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

# Install MySQL 8
sudo apt install mysql-server -y

# Install Nginx (reverse proxy)
sudo apt install nginx -y

# Install PM2 (process manager)
sudo npm install -g pm2
```

### 2. Database Setup

```bash
sudo mysql -u root -p

# Create database
CREATE DATABASE nexaflow_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Create user
CREATE USER 'nexaflow'@'localhost' IDENTIFIED BY 'SecurePassword123!';

# Grant privileges
GRANT ALL PRIVILEGES ON nexaflow_db.* TO 'nexaflow'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3. Deploy Backend

```bash
# Clone/pull backend code
cd /opt/nexaflow-backend

# Update application-production.properties
nano nexaflow-backend/src/main/resources/application-production.properties

# Build JAR
mvn clean package -DskipTests -Pproduction

# Create systemd service
sudo nano /etc/systemd/system/nexaflow-backend.service
```

**Systemd Service File:**
```ini
[Unit]
Description=NexaFlow Backend
After=network.target

[Service]
Type=simple
User=nexaflow
WorkingDirectory=/opt/nexaflow-backend
ExecStart=/usr/bin/java \
  -Dspring.profiles.active=production \
  -Dspring.config.location=classpath:application.properties,classpath:application-production.properties \
  -jar nexaflow-backend/target/nexaflow-backend-3.0.0.jar
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable nexaflow-backend
sudo systemctl start nexaflow-backend
sudo journalctl -u nexaflow-backend -f
```

### 4. Deploy Frontend

```bash
# Clone/pull frontend code
cd /opt/nexaflow-frontend

# Install dependencies
npm ci --only=production

# Create PM2 ecosystem file
nano ecosystem.config.js
```

**PM2 Ecosystem File:**
```javascript
module.exports = {
  apps: [
    {
      name: 'nexaflow-frontend',
      script: './server.js',
      instances: 'max',
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
        BACKEND_URL: 'https://api.yourdomain.com'
      },
      error_file: './logs/err.log',
      out_file: './logs/out.log'
    }
  ]
};
```

```bash
# Start with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### 5. Nginx Reverse Proxy

```bash
sudo nano /etc/nginx/sites-available/nexaflow
```

**Nginx Configuration:**
```nginx
# ═══════════════════════════════════════════════════════════
#  Frontend Proxy
# ═══════════════════════════════════════════════════════════
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;
    
    ssl_certificate /etc/ssl/certs/yourdomain.crt;
    ssl_certificate_key /etc/ssl/private/yourdomain.key;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Frontend proxy
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# ═══════════════════════════════════════════════════════════
#  API Proxy (Optional separate domain)
# ═══════════════════════════════════════════════════════════
server {
    listen 443 ssl http2;
    server_name api.yourdomain.com;
    
    ssl_certificate /etc/ssl/certs/yourdomain.crt;
    ssl_certificate_key /etc/ssl/private/yourdomain.key;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/nexaflow /etc/nginx/sites-enabled/

# Test config
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

### 6. SSL Certificate (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx -y

# Get certificate
sudo certbot certonly --nginx -d yourdomain.com -d www.yourdomain.com -d api.yourdomain.com

# Auto-renew
sudo certbot renew --dry-run
```

---

## Monitoring & Maintenance

### Check Service Status
```bash
# Backend
sudo systemctl status nexaflow-backend

# Frontend
pm2 status

# Services resource usage
pm2 monit
```

### View Logs
```bash
# Backend logs
sudo journalctl -u nexaflow-backend -f --lines=100

# Frontend logs
pm2 logs nexaflow-frontend

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Database Maintenance
```bash
# Backup database
mysqldump -u nexaflow -p nexaflow_db > /backups/nexaflow_db_$(date +%Y%m%d).sql

# Optimize tables
mysql -u root -p -e "OPTIMIZE TABLE nexaflow_db.*;"

# Check database size
mysql -u root -p -e "SELECT table_name, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS Size_MB FROM information_schema.TABLES WHERE table_schema = 'nexaflow_db';"
```

### Updates & Upgrades

```bash
# Update backend
cd /opt/nexaflow-backend
git pull origin main
mvn clean package -DskipTests -Pproduction
sudo systemctl restart nexaflow-backend

# Update frontend
cd /opt/nexaflow-frontend
git pull origin main
npm ci --only=production
pm2 restart nexaflow-frontend

# Check services
sudo systemctl status nexaflow-backend
pm2 list
```

---

## Security Checklist

- [ ] Change all default passwords
- [ ] Set strong JWT_SECRET (32+ characters)
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Set up regular backups
- [ ] Enable database user permissions (least privilege)
- [ ] Disable SSH password login (use keys)
- [ ] Set up fail2ban for brute-force protection
- [ ] Configure rate limiting
- [ ] Enable CORS only for known domains
- [ ] Regularly update packages and dependencies
- [ ] Monitor logs for suspicious activity
- [ ] Set up alerting for errors

---

## Troubleshooting

### Backend won't start
```bash
# Check logs
sudo journalctl -u nexaflow-backend -n 50

# Check port is free
sudo lsof -i :8080

# Check database connection
mysql -h localhost -u nexaflow -p nexaflow_db -e "SELECT 1;"
```

### Frontend connection issues
```bash
# Test API connectivity
curl -i http://localhost:8080/actuator/health

# Check CORS headers
curl -i -X OPTIONS http://localhost:8080

# Verify environment variables
pm2 show nexaflow-frontend
```

### Database issues
```bash
# Repair tables
mysql -u root -p -e "CHECK TABLE nexaflow_db.*; REPAIR TABLE nexaflow_db.*;"

# Increase max connections if needed (temporary)
mysql -u root -p -e "SET GLOBAL max_connections = 1000;"

# Check slow queries
mysql -u root -p -e "SET GLOBAL slow_query_log = 'ON';"
```

---

## Support & Resources

- **Documentation**: Add to your GitHub wiki or docs
- **Issues**: Create GitHub Issues for feature requests/bugs
- **Community**: Set up Discord/Slack channel
- **Status Page**: Consider StatusPage.io for uptime monitoring

---

Generated: 2026-04-03
Version: NexaFlow v3.0
