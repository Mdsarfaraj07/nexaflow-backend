# NexaFlow Backend - Quick Start Guide

## 🚀 Get Started in 3 Minutes

### Option 1: Using H2 In-Memory Database (Easiest)

1. **Open `application.properties`**
   ```bash
   cd nexaflow-backend/src/main/resources
   nano application.properties
   ```

2. **Comment PostgreSQL and uncomment H2 settings:**
   ```properties
   # PostgreSQL (Production)
   # spring.datasource.url=jdbc:postgresql://localhost:5432/nexaflow_db
   # ...

   # H2 Database (Development/Testing) - UNCOMMENT THESE:
   spring.datasource.url=jdbc:h2:mem:nexaflow_db
   spring.datasource.driver-class-name=org.h2.Driver
   spring.datasource.username=sa
   spring.datasource.password=
   spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
   spring.h2.console.enabled=true
   spring.h2.console.path=/h2-console
   ```

3. **Run the application:**
   ```bash
   cd nexaflow-backend
   mvn spring-boot:run
   ```

4. **Test it:**
   - Backend: http://localhost:8080/api/auth/health
   - H2 Console: http://localhost:8080/h2-console

### Option 2: Using PostgreSQL (Production-Ready)

1. **Install PostgreSQL**
   ```bash
   # Ubuntu/Debian
   sudo apt install postgresql postgresql-contrib
   
   # macOS
   brew install postgresql
   ```

2. **Create Database**
   ```bash
   sudo -u postgres psql
   CREATE DATABASE nexaflow_db;
   \q
   ```

3. **Update `application.properties`:**
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/nexaflow_db
   spring.datasource.username=postgres
   spring.datasource.password=your_postgres_password
   ```

4. **Run the application:**
   ```bash
   mvn spring-boot:run
   ```

### Option 3: Using Docker (Recommended)

1. **Start everything with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

   This starts:
   - PostgreSQL database
   - Spring Boot backend

2. **Access:**
   - Backend: http://localhost:8080

## 📧 Default Login Credentials

### Admin Dashboard
- **Email:** admin@nexaflow.in
- **Password:** Admin@123

### Demo Client
- **Email:** client@demo.com
- **Password:** Client@123

## 🔧 Essential Configuration

### 1. JWT Secret (REQUIRED)
```properties
app.jwt.secret=CHANGE_THIS_TO_A_RANDOM_32_CHAR_STRING_NOW
```

### 2. Email (Optional but Recommended)
```properties
# Gmail
spring.mail.username=your@gmail.com
spring.mail.password=your_16_char_app_password
```

### 3. Payment Gateways (Optional)
```properties
# Stripe
stripe.api.key=sk_test_...
stripe.publishable.key=pk_test_...

# Razorpay
razorpay.key.id=rzp_test_...
razorpay.key.secret=...
```

## 🧪 Test the API

### 1. Health Check
```bash
curl http://localhost:8080/api/auth/health
```

### 2. Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@nexaflow.in","password":"Admin@123"}'
```

### 3. Get Services
```bash
curl http://localhost:8080/api/services/public
```

## 📱 Connect Your Frontend

Update your frontend API base URL:
```javascript
const API_URL = "http://localhost:8080/api";
```

## 🎯 Default Data Included

On first run, the system automatically creates:
- ✅ Admin account
- ✅ Demo client account
- ✅ 6 sample services (Website, Mobile App, UI/UX, etc.)

## 🐛 Troubleshooting

### Port 8080 already in use
```bash
# Change port in application.properties
server.port=8081
```

### Database connection failed
```bash
# Use H2 instead (see Option 1 above)
# or check PostgreSQL is running:
sudo service postgresql status
```

### Build errors
```bash
# Clean and rebuild
mvn clean install -U
```

## 📚 Next Steps

1. Read full README.md for detailed documentation
2. Test all API endpoints
3. Configure payment gateways
4. Set up email service
5. Deploy to production

## 🆘 Need Help?

- Check README.md for full documentation
- View logs: `tail -f logs/spring.log`
- Database console: http://localhost:8080/h2-console (H2 only)

---

Happy coding! 🚀
