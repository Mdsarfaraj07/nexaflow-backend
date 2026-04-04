# 🚀 NexaFlow v3.0 - Complete Deployment Setup

> **Global SaaS & Digital Agency Platform** — Production-ready, multi-currency (INR + USD), international payments

---

## 📋 Quick Navigation

- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Local Development](#local-development)
- [Docker Deployment](#docker-deployment)
- [Production Deployment](#production-deployment)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## ⚡ Quick Start

### Prerequisites
- **Backend**: Java 17+, Maven 3.9+
- **Frontend**: Node.js 18+, npm/yarn
- **Database**: MySQL 8.0+ or use H2 (in-memory)
- **Docker** (optional, for containerized deployment)

### 1️⃣ First Time Setup

```bash
# Clone/navigate to project root
cd nexaflow-backend-complete

# Copy environment template
cp .env.example .env

# Edit .env with your configuration
nano .env

# On Windows: Edit manually or use notepad
notepad .env
```

### 2️⃣ Start Services

**Option A: Using PowerShell (Windows)**
```bash
# Make sure to set execution policy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Run deployment script
.\deploy.ps1 -Environment development
```

**Option B: Using Bash (Linux/macOS)**
```bash
chmod +x deploy.sh
./deploy.sh development
```

**Option C: Manual Start**
```bash
# Terminal 1: Backend
cd nexaflow-backend
mvn spring-boot:run

# Terminal 2: Frontend
cd ../nexaflow-v3-complete
npm install
npm start
```

### 3️⃣ Access Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **API Documentation**: http://localhost:8080/api

**Default Credentials:**
```
Admin: admin@nexaflow.in / Admin@123
Client: client@demo.com / Client@123
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Frontend Layer                           │
│                    (Vue.js / HTML Pages)                        │
│                    Port 3000 (Node.js)                          │
│  - Authentication, UI, Payment Forms, Dashboard, Admin Panel   │
└──────────────────────────┬──────────────────────────────────────┘
                           │ (HTTP REST API)
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                       Backend Layer                             │
│                  (Spring Boot 3.2 Service)                      │
│                    Port 8080 (Java 17)                          │
│  - Authentication, Authorization, Business Logic, Payments     │
│  - User Management, Bookings, Projects, Invoices               │
└──────────────────────────┬──────────────────────────────────────┘
                           │ (JDBC)
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                     Data Layer                                  │
│                   (MySQL Database)                              │
│                  Port 3306 (UTF8MB4)                            │
│  - Users, Bookings, Services, Projects, Payments, Invoices    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Local Development

### Setup Backend

```bash
cd nexaflow-backend

# Choose database (default is H2)
# For MySQL, update application.properties

# Build
mvn clean install

# Run
mvn spring-boot:run

# Run with specific profile
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=production"
```

### Setup Frontend

```bash
cd nexaflow-v3-complete

# Install dependencies
npm install

# Development mode (with hot reload)
npm run dev

# Production build
npm run build

# Production start
npm start
```

### Database Setup

**Using MySQL:**
```bash
# Create database
mysql -u root -p << EOF
CREATE DATABASE nexaflow_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nexaflow'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL ON nexaflow_db.* TO 'nexaflow'@'localhost';
FLUSH PRIVILEGES;
EOF

# Update application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/nexaflow_db
spring.datasource.username=nexaflow
spring.datasource.password=secure_password
```

**Using H2 (default for development):**
```properties
# Access H2 console at: http://localhost:8080/h2-console
spring.datasource.url=jdbc:h2:mem:nexaflow_db
spring.h2.console.enabled=true
```

---

## 🐳 Docker Deployment

### Build Images

```bash
# Build frontend image
cd nexaflow-v3-complete
docker build -t nexaflow-frontend:latest .

# Build backend image
cd ../nexaflow-backend
docker build -t nexaflow-backend:latest .
```

### Using Docker Compose

```bash
# Production deployment
docker-compose -f docker-compose.production.yml up -d

# Stack overview
docker-compose -f docker-compose.production.yml ps

# View logs
docker-compose -f docker-compose.production.yml logs -f backend

# Stop services
docker-compose -f docker-compose.production.yml down

# Cleanup (WARNING: removes volumes/data)
docker-compose -f docker-compose.production.yml down -v
```

### Environment Configuration

Create `.env` file before running Docker Compose:

```env
# Core Configuration
NODE_ENV=production
BACKEND_URL=http://localhost:8080

# Database
DB_HOST=localhost
DB_NAME=nexaflow_db
DB_USER=nexaflow
DB_PASSWORD=secure_password_here

# Security
JWT_SECRET=your_32_character_secret_key_here
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://yourdomain.com

# Payment Gateways
RAZORPAY_KEY_ID=rzp_live_xxxxx
RAZORPAY_KEY_SECRET=xxxxx
STRIPE_API_KEY=sk_live_xxxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxxx

# Email
SMTP_HOST=smtp.gmail.com
SMTP_USER=your@gmail.com
SMTP_PASSWORD=app_password_here
```

---

## 🌍 Production Deployment

### Option 1: Linux/VPS with Systemd

See **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** for detailed instructions on:
- Manual compilation
- Systemd service setup
- Nginx reverse proxy
- SSL/TLS configuration
- Backup strategies
- Monitoring setup

### Option 2: Cloud Platforms

#### Heroku
```bash
# Install Heroku CLI then:
heroku create nexaflow-backend
git push heroku main
```

#### AWS
- Use **AWS EC2** for compute
- Use **AWS RDS** for managed MySQL
- Use **AWS S3** for file uploads
- Use **AWS CloudFront** for CDN

#### Google Cloud
- Use **Cloud Run** for containerized services
- Use **Cloud SQL** for managed MySQL
- Use **Cloud Storage** for files
- Use **Cloud Load Balancing** for traffic

#### Azure
- Use **App Service** for hosting
- Use **Azure Database** for MySQL
- Use **Blob Storage** for files
- Use **Application Gateway** for routing

### Option 3: Kubernetes (Advanced)

```bash
# Build images for registry (e.g., DockerHub)
docker tag nexaflow-backend:latest yourusername/nexaflow-backend:latest
docker push yourusername/nexaflow-backend:latest

# Deploy Kubernetes manifests (create k8s folder)
kubectl apply -f k8s/
```

---

## ⚙️ Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NODE_ENV` | No | `production` | Node environment |
| `BACKEND_URL` | Yes | - | Backend API endpoint |
| `JWT_SECRET` | Yes | - | JWT signing key (32+ chars) |
| `DB_HOST` | Yes | `localhost` | Database host |
| `DB_PORT` | No | `3306` | Database port |
| `DB_NAME` | Yes | `nexaflow_db` | Database name |
| `DB_USER` | Yes | - | Database user |
| `DB_PASSWORD` | Yes | - | Database password |
| `CORS_ALLOWED_ORIGINS` | No | `http://localhost:3000` | Comma-separated allowed origins |
| `RAZORPAY_KEY_ID` | No | - | Razorpay live key |
| `RAZORPAY_KEY_SECRET` | No | - | Razorpay live secret |
| `STRIPE_API_KEY` | No | - | Stripe live key |
| `STRIPE_WEBHOOK_SECRET` | No | - | Stripe webhook secret |
| `SMTP_HOST` | No | `smtp.gmail.com` | Email SMTP host |
| `SMTP_USER` | No | - | Email account |
| `SMTP_PASSWORD` | No | - | Email app password |

### Payment Gateway Setup

#### Razorpay (India)
1. Sign up: https://razorpay.com
2. Get keys from: Dashboard → Settings → API Keys
3. Add to `.env`:
   ```env
   RAZORPAY_KEY_ID=rzp_live_xxxxx
   RAZORPAY_KEY_SECRET=xxxxx
   ```

#### Stripe (International)
1. Sign up: https://stripe.com
2. Get keys from: Developers → API Keys
3. Add to `.env`:
   ```env
   STRIPE_API_KEY=sk_live_xxxxx
   STRIPE_PUBLISHABLE_KEY=pk_live_xxxxx
   STRIPE_WEBHOOK_SECRET=whsec_xxxxx
   ```

### SMTP Email Configuration

#### Gmail
1. Enable 2-factor authentication
2. Create app password: https://myaccount.google.com/apppasswords
3. Add to `.env`:
   ```env
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=your@gmail.com
   SMTP_PASSWORD=your_16_char_app_password
   ```

#### SendGrid
1. Sign up: https://sendgrid.com
2. Get API key from: Settings → API Keys
3. Update frontend for SendGrid integration

---

## 🐛 Troubleshooting

### Backend Issues

**Port 8080 already in use:**
```bash
# Linux/macOS
lsof -i :8080
kill -9 <PID>

# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

**Database connection error:**
```bash
# Check MySQL is running
sudo systemctl status mysql

# Test connection
mysql -u nexaflow -p nexaflow_db -e "SELECT 1;"
```

**Compilation failure:**
```bash
# Clean and rebuild
mvn clean install -DskipTests

# Check Java version (must be 17+)
java --version
```

### Frontend Issues

**Port 3000 already in use:**
```bash
# Find and kill process
lsof -i :3000
kill -9 <PID>
```

**Module not found:**
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

**API connection error:**
```bash
# Verify backend is running
curl http://localhost:8080/actuator/health

# Check CORS configuration
curl -i -X OPTIONS http://localhost:8080
```

### Database Issues

**Cannot connect:**
```bash
# Check MySQL service
sudo systemctl status mysql

# Restart MySQL
sudo systemctl restart mysql

# Test with MySQL client
mysql -u root -p -h localhost -e "SHOW DATABASES;"
```

**Slow queries:**
```bash
# Enable slow query log
mysql -u root -p -e "SET GLOBAL slow_query_log = 'ON';"
mysql -u root -p -e "SET GLOBAL long_query_time = 2;"

# View slow queries
tail -f /var/log/mysql/slow.log
```

---

## 📊 Monitoring

### Health Checks

```bash
# Backend health
curl http://localhost:8080/actuator/health

# Database connectivity
curl http://localhost:8080/actuator/health/db

# Liveness probe
curl http://localhost:8080/actuator/health/liveness

# Readiness probe
curl http://localhost:8080/actuator/health/readiness
```

### Logs

```bash
# Backend logs
tail -f logs/nexaflow.log

# Frontend logs
tail -f logs/frontend_*.log

# System logs (Linux)
sudo journalctl -u nexaflow-backend -f
```

### Performance Metrics

```bash
# JVM metrics
curl http://localhost:8080/actuator/metrics

# Specific metrics
curl http://localhost:8080/actuator/metrics/jvm.memory.used
```

---

## 🔄 Updates & Upgrades

### Update Dependencies

```bash
# Backend
cd nexaflow-backend
mvn dependency:resolve
mvn clean package

# Frontend
cd nexaflow-v3-complete
npm update
npm audit fix
```

### Database Backups

```bash
# Backup
mysqldump -u nexaflow -p nexaflow_db > backup_$(date +%Y%m%d).sql

# Restore
mysql -u nexaflow -p nexaflow_db < backup_20240403.sql

# Automated backup with cron (Linux)
# Add to crontab (crontab -e):
# 0 2 * * * /usr/bin/mysqldump -u nexaflow -pPASSWORD nexaflow_db > /backups/nexaflow_db_$(date +\%Y\%m\%d).sql
```

---

## 🔒 Security Checklist

- [ ] Change all default passwords
- [ ] Set `JWT_SECRET` to strong random value (32+ chars)
- [ ] Enable HTTPS/SSL on production
- [ ] Configure firewall rules
- [ ] Set up regular backups
- [ ] Enable database user permissions (least privilege)
- [ ] Disable SSH password auth (use keys)
- [ ] Set up fail2ban or similar
- [ ] Enable rate limiting
- [ ] Configure CORS for known domains only
- [ ] Keep dependencies updated
- [ ] Monitor logs for suspicious activity
- [ ] Use environment variables for secrets (never hardcode)
- [ ] Enable audit logging
- [ ] Set up alerting for errors

---

## 📚 Additional Resources

- [Full Deployment Guide](./DEPLOYMENT_GUIDE.md)
- [API Documentation](http://localhost:8080/api)
- [Frontend Repository](./nexaflow-v3-complete)
- [Backend Repository](./nexaflow-backend)

---

## 💬 Support & Community

- **Issues**: GitHub Issues for bug reports
- **Discussions**: GitHub Discussions for questions
- **Documentation**: See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- **Email**: support@nexaflow.com

---

## 📄 License

MIT License - See LICENSE file for details

---

**Last Updated**: April 3, 2026 | **Version**: 3.0.0 | **Status**: ✅ Production Ready

