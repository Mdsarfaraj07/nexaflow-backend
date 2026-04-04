# 🚀 NexaFlow v3.0 - Deployment Checklist

## Pre-Deployment Phase

### 1. Local Development ✅
- [ ] Backend runs successfully: `mvn spring-boot:run` (http://localhost:8080)
- [ ] Frontend runs successfully: `npm start` (http://localhost:3000)
- [ ] Can access both services without errors
- [ ] Backend and frontend can communicate
- [ ] Test login with default credentials
  - Admin: `admin@nexaflow.in` / `Admin@123`
  - Client: `client@demo.com` / `Client@123`

### 2. Code Review & Quality
- [ ] All compilation warnings resolved
- [ ] No security vulnerabilities in dependencies
- [ ] Code follows project conventions
- [ ] Tests pass (if applicable)
- [ ] Environment-specific configs separated

### 3. Environment Configuration
- [ ] `.env` file created from `.env.example`
- [ ] All required variables filled:
  - [ ] `JWT_SECRET` (32+ characters)
  - [ ] `RAZORPAY_KEY_ID` and `RAZORPAY_KEY_SECRET`
  - [ ] `STRIPE_API_KEY` and `STRIPE_PUBLISHABLE_KEY`
  - [ ] `SMTP_*` values for email
  - [ ] `CORS_ALLOWED_ORIGINS` for your domain
- [ ] Sensitive values never committed to version control
- [ ] Separate `.env.production` for production values

---

## Database Preparation

### 4. MySQL Setup (if using MySQL)
- [ ] MySQL 8.0+ installed
- [ ] Database `nexaflow_db` created
- [ ] Application user `nexaflow` created with secure password
- [ ] Proper permissions granted
- [ ] Backup strategy planned
- [ ] Database user uses strong password (12+ chars, mixed case, numbers, symbols)

### 5. Database Schema
- [ ] Run `init.sql` to initialize database
- [ ] Verify all tables created successfully
- [ ] Check foreign key relationships
- [ ] Test data inserted correctly

```bash
# Initialize database
mysql -u root -p < init.sql

# Verify tables
mysql -u nexaflow -p -e "SHOW TABLES;" nexaflow_db
```

---

## Backend Setup

### 6. Build Configuration
- [ ] `pom.xml` updated with correct versions
- [ ] `application.properties` configured for development
- [ ] `application-production.properties` created and configured
- [ ] Security settings updated
- [ ] CORS configured for production domain

### 7. Backend Build (Production)
- [ ] Maven 3.9+ installed
- [ ] Java 17+ installed
- [ ] Build succeeds without errors: `mvn clean package -DskipTests`
- [ ] JAR file generated in `target/` directory
- [ ] Docker image builds successfully (if using Docker)

### 8. Backend Testing
- [ ] Backend health check passes: `curl http://localhost:8080/actuator/health`
- [ ] API docs accessible: `http://localhost:8080/api`
- [ ] Authentication endpoints working
- [ ] Database connectivity confirmed
- [ ] Payment gateway APIs configured (test keys initially)

---

## Frontend Setup

### 9. Frontend Build
- [ ] Node.js 18+ and npm installed
- [ ] Dependencies install without warnings: `npm install`
- [ ] Build completes successfully: `npm build` (if applicable)
- [ ] No console errors when running: `npm start`
- [ ] All pages load correctly

### 10. Frontend Configuration
- [ ] Correct `BACKEND_URL` set: `http://localhost:8080`
- [ ] API endpoints configured correctly
- [ ] Environment variables in `.env` match backend
- [ ] SMTP configuration for email features
- [ ] Payment gateway keys configured

### 11. Frontend Testing
- [ ] Can access login page (http://localhost:3000)
- [ ] Can login with provided credentials
- [ ] Can access all main pages
- [ ] API calls return correct responses
- [ ] No CORS errors in console
- [ ] Responsive design works on mobile/tablet

---

## Docker Deployment (if applicable)

### 12. Docker Build & Test
- [ ] Docker Engine running
- [ ] Docker Compose 2.0+ installed
- [ ] Backend Dockerfile builds correctly
- [ ] Frontend Dockerfile builds correctly
- [ ] `docker-compose.production.yml` configured correctly
- [ ] All required environment variables in `.env`

### 13. Local Docker Test
- [ ] Run: `docker-compose -f docker-compose.production.yml up`
- [ ] All services start successfully
- [ ] Backend health check passes
- [ ] Frontend is accessible
- [ ] Database initializes properly
- [ ] No errors in logs

```bash
# Test Docker deployment
docker-compose -f docker-compose.production.yml up -d
docker-compose -f docker-compose.production.yml ps
docker-compose -f docker-compose.production.yml logs
```

---

## Production Environment

### 14. Server Preparation (Linux/VPS)
- [ ] Ubuntu 22.04 LTS or similar OS
- [ ] 4GB+ RAM allocated
- [ ] 20GB+ disk space available
- [ ] Internet connection stable
- [ ] SSH access configured
- [ ] Firewall rules configured (allow 80, 443, 3306)

### 15. Software Installation
- [ ] Java 17+ installed and configured
- [ ] Maven 3.9+ installed (or skip if using Docker)
- [ ] Node.js 18+ installed (for frontend)
- [ ] MySQL 8.0+ installed and running
- [ ] Nginx installed (for reverse proxy)
- [ ] Docker & Docker Compose (if using containers)

### 16. System Configuration
- [ ] Hostname configured
- [ ] Time synchronized (NTP)
- [ ] Disk permissions correct
- [ ] Swap space configured (2GB minimum)
- [ ] Log rotation configured

---

## Security Hardening

### 17. Access Control
- [ ] SSH keys configured (disable password auth)
- [ ] Firewall rules set (UFW or iptables)
- [ ] fail2ban installed and configured
- [ ] Database user has least privilege permissions
- [ ] Backend application runs as non-root user

### 18. SSL/TLS Certificates
- [ ] Domain name registered
- [ ] DNS configured to point to server
- [ ] Let's Encrypt certificate obtained
- [ ] Certificate auto-renewal configured
- [ ] Nginx SSL configuration complete
- [ ] HTTPS enabled and enforced

### 19. Application Secrets
- [ ] `JWT_SECRET` set to strong random value
- [ ] All API keys stored securely:
  - [ ] Razorpay keys
  - [ ] Stripe keys
  - [ ] Email credentials
- [ ] No secrets in code or logs
- [ ] `.env` file permissions restricted (600)
- [ ] Secrets manager considered (AWS Secrets, HashiCorp Vault)

---

## Monitoring & Logging

### 20. Monitoring Setup
- [ ] Health checks configured
- [ ] Application metrics collection enabled
- [ ] Error tracking (Sentry or similar) configured
- [ ] Uptime monitoring service (StatusPage.io) set up
- [ ] Alerts configured for critical events

### 21. Logging Configuration
- [ ] Application logs written to `/var/log/nexaflow/`
- [ ] Log rotation configured
- [ ] Log aggregation service considered (ELK, CloudWatch)
- [ ] Database query logging enabled (initially, can disable later)
- [ ] Access logs from Nginx configured

```bash
# Test logging
tail -f /var/log/nexaflow/app.log
tail -f /var/log/nginx/access.log
```

---

## Backup & Disaster Recovery

### 22. Backup Strategy
- [ ] Daily automated backups configured
- [ ] Backup script tested and verified
- [ ] Backups stored:
  - [ ] Local copy (for quick restore)
  - [ ] Remote copy (AWS S3, Google Cloud, etc.)
- [ ] Backup retention policy set (30 days minimum)
- [ ] Test restore process (monthly)

```bash
# Backup script example
0 2 * * * /usr/local/bin/backup-nexaflow.sh
```

### 23. Disaster Recovery
- [ ] Documented recovery procedures
- [ ] Recovery point objective (RPO): <4 hours
- [ ] Recovery time objective (RTO): <1 hour
- [ ] Tested recovery process (monthly drill)
- [ ] Contact list for emergencies

---

## Payment Gateway Integration

### 24. Razorpay Setup (India)
- [ ] Live account created
- [ ] Live API key and secret obtained
- [ ] Webhook secrets configured
- [ ] Test payment completed successfully
- [ ] Invoice/payment emails configured

### 25. Stripe Setup (International)
- [ ] Live account created
- [ ] Live API keys obtained
- [ ] Webhook endpoints configured
- [ ] Test payment completed successfully
- [ ] 3D Secure enabled (if required)

---

## DNS & Subdomain Configuration

### 26. Domain Configuration
- [ ] Primary domain (yourdomain.com) → Frontend
- [ ] API subdomain (api.yourdomain.com) → Backend (optional)
- [ ] Admin subdomain (admin.yourdomain.com) → Admin panel (optional)
- [ ] DNS propagation verified
- [ ] All domains point to correct IP

---

## Email Configuration

### 27. Email Setup
- [ ] SMTP credentials tested
- [ ] Welcome email template configured
- [ ] Password reset email template configured
- [ ] Invoice email template configured
- [ ] Notification email templates configured
- [ ] Unsubscribe links functional
- [ ] SPF/DKIM/DMARC records configured

---

## Final Deployment

### 28. Pre-Launch Testing (Production)
- [ ] Backend services running: `systemctl status nexaflow-backend`
- [ ] Frontend services running: `pm2 status`
- [ ] Database connectivity confirmed
- [ ] Health checks passing
- [ ] API endpoints responding correctly
- [ ] Web UI accessible and functional
- [ ] All links working
- [ ] Forms submitting successfully
- [ ] Payment processing working
- [ ] Email notifications sending
- [ ] Error pages displaying correctly

### 29. Load Testing (if applicable)
- [ ] Expected concurrent users determined
- [ ] Load test performed (Apache JMeter, Locust)
- [ ] Performance acceptable
- [ ] Auto-scaling configured (if using cloud)
- [ ] Caching implemented where needed

### 30. Go-Live Steps
- [ ] Communicate deployment schedule to stakeholders
- [ ] Maintain deployment window with maintenance message
- [ ] Disable non-critical jobs during deployment
- [ ] Perform final database backup
- [ ] Deploy code to production
- [ ] Run database migrations
- [ ] Verify all services running
- [ ] Update DNS records (if changing servers)
- [ ] Monitoring dashboards accessible
- [ ] On-call team notified and ready

---

## Post-Deployment

### 31. Post-Launch Monitoring (First 24 hours)
- [ ] Monitor error logs continuously
- [ ] Check application metrics
- [ ] Monitor database performance
- [ ] Test key user workflows
- [ ] Monitor payment processing
- [ ] Check email delivery
- [ ] Monitor API response times
- [ ] Check for security issues

### 32. Post-Launch Documentation
- [ ] Document deployment procedures
- [ ] Update runbooks
- [ ] Document troubleshooting steps
- [ ] Create incident response procedures
- [ ] Update architecture documentation
- [ ] Update team wiki/confluence

### 33. Team Communication
- [ ] Notify users of successful launch
- [ ] Provide production domain/endpoints
- [ ] Share documentation links
- [ ] Establish support process
- [ ] Set up on-call rotation
- [ ] Schedule team debriefing

---

## Success Criteria ✅

- [ ] All services running stable (99.5%+ uptime target)
- [ ] Response times within acceptable range (<2s for most endpoints)
- [ ] No critical errors in logs
- [ ] Users successfully logging in
- [ ] Payments processing correctly
- [ ] Emails sending successfully
- [ ] Backups running and verified
- [ ] Monitoring alerting correctly
- [ ] Team trained and ready to support

---

## Sign-Off

- **Prepared By**: _________________ Date: _________
- **Reviewed By**: _________________ Date: _________
- **Approved By**: _________________ Date: _________
- **Deployed By**: _________________ Date: _________ Time: _________

---

**Notes**: 
```
____________________________________________________________________
____________________________________________________________________
____________________________________________________________________
____________________________________________________________________
```

---

For detailed instructions, see:
- [DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md)
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

Generated: 2026-04-03 | Version: NexaFlow v3.0
