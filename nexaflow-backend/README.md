# NexaFlow Backend - Spring Boot v3.0

Complete Spring Boot backend for NexaFlow Global SaaS & Digital Agency Platform with dual-currency support (INR + USD), payment gateway integration (Stripe + Razorpay), and comprehensive project management features.

## 🚀 Features

### Core Features
- ✅ **Dual Currency Support** - INR & USD with live exchange rate auto-refresh
- ✅ **Payment Gateways** - Stripe (International) + Razorpay (India)
- ✅ **JWT Authentication** - Secure token-based authentication
- ✅ **Role-Based Access** - Admin & Client roles with permissions
- ✅ **Email Service** - Beautiful HTML email templates (SMTP/Brevo)
- ✅ **RESTful APIs** - Complete REST API endpoints

### Business Features
- 📦 **Service Management** - Create and manage service offerings
- 📋 **Booking System** - Complete booking workflow with invoices
- 💳 **Payment Processing** - Integrated payment verification
- 📊 **Project Management** - Projects with milestones and progress tracking
- 📄 **Invoice Generation** - Automated invoice creation with GST
- 🎟️ **Coupon System** - Percentage and flat discount coupons
- 📬 **Messaging** - Internal messaging between admin and clients
- ⭐ **Testimonials** - Client testimonials with approval workflow
- 🔔 **Notifications** - Real-time notification system
- 📧 **Email Logs** - Complete email delivery tracking
- ⏱️ **Time Tracking** - Project time entry tracking

## 📁 Project Structure

```
nexaflow-backend/
├── src/main/java/com/nexaflow/
│   ├── NexaFlowApplication.java          # Main application
│   ├── config/                           # Configuration classes
│   │   ├── SecurityConfig.java          # Spring Security config
│   │   ├── WebConfig.java               # Web configuration
│   │   └── DataInitializer.java         # Default data setup
│   ├── controller/                       # REST Controllers
│   │   ├── AuthController.java
│   │   ├── BookingController.java
│   │   ├── ServiceController.java
│   │   ├── PaymentController.java
│   │   └── CurrencyController.java
│   ├── dto/                              # Data Transfer Objects
│   │   ├── request/
│   │   └── response/
│   ├── entity/                           # JPA Entities
│   │   ├── User.java
│   │   ├── Service.java
│   │   ├── Booking.java
│   │   ├── Project.java
│   │   ├── Invoice.java
│   │   ├── Milestone.java
│   │   ├── Deliverable.java
│   │   ├── Coupon.java
│   │   ├── Message.java
│   │   ├── Testimonial.java
│   │   ├── Notification.java
│   │   ├── EmailLog.java
│   │   └── TimeEntry.java
│   ├── enums/                            # Enumerations
│   ├── exception/                        # Exception handlers
│   ├── repository/                       # JPA Repositories
│   ├── security/                         # Security components
│   │   └── JwtAuthenticationFilter.java
│   ├── service/                          # Business logic
│   │   ├── AuthService.java
│   │   ├── BookingService.java
│   │   ├── PaymentService.java
│   │   ├── EmailService.java
│   │   └── CustomUserDetailsService.java
│   └── util/                             # Utility classes
│       ├── JwtUtil.java
│       └── CurrencyUtil.java
├── src/main/resources/
│   └── application.properties           # Application configuration
├── pom.xml                              # Maven dependencies
└── README.md                            # This file
```

## 🛠️ Technologies Used

- **Java 17** - Programming language
- **Spring Boot 3.2.0** - Framework
- **Spring Security** - Authentication & Authorization
- **Spring Data JPA** - Data persistence
- **PostgreSQL** - Primary database (H2 for testing)
- **JWT (JJWT 0.12.3)** - Token-based authentication
- **Stripe Java SDK** - International payments
- **Razorpay Java SDK** - India payments
- **JavaMailSender** - Email service
- **Lombok** - Reduce boilerplate code
- **Maven** - Build tool

## 🚀 Quick Start

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- PostgreSQL 12+ (or use H2 for development)

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd nexaflow-backend
```

2. **Configure Database**

Edit `src/main/resources/application.properties`:

**For PostgreSQL (Production):**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/nexaflow_db
spring.datasource.username=postgres
spring.datasource.password=your_password
```

**For H2 (Development/Testing):**
```properties
# Comment out PostgreSQL config and uncomment:
# spring.datasource.url=jdbc:h2:mem:nexaflow_db
# spring.datasource.driver-class-name=org.h2.Driver
# spring.h2.console.enabled=true
```

3. **Configure Environment Variables**

Update the following in `application.properties`:

```properties
# JWT Secret (CHANGE THIS!)
app.jwt.secret=your_super_secret_jwt_key_minimum_32_characters

# Email Configuration (Gmail example)
spring.mail.username=your@gmail.com
spring.mail.password=your_app_password

# Razorpay (Optional - India payments)
razorpay.key.id=your_razorpay_key_id
razorpay.key.secret=your_razorpay_key_secret

# Stripe (Optional - International payments)
stripe.api.key=your_stripe_secret_key
stripe.publishable.key=your_stripe_publishable_key
```

4. **Build the project**
```bash
mvn clean install
```

5. **Run the application**
```bash
mvn spring-boot:run
```

The server will start on `http://localhost:8080`

## 📝 Default Credentials

The application automatically creates default users on first run:

### Admin Account
- **Email:** admin@nexaflow.in
- **Password:** Admin@123

### Demo Client Account
- **Email:** client@demo.com
- **Password:** Client@123

## 🔌 API Endpoints

### Authentication
```
POST   /api/auth/register     - Register new user
POST   /api/auth/login        - Login user
GET    /api/auth/me           - Get current user
GET    /api/auth/health       - Health check
```

### Services
```
GET    /api/services/public   - Get active services (public)
GET    /api/services          - Get all services
GET    /api/services/{id}     - Get service by ID
POST   /api/services          - Create service (Admin)
PUT    /api/services/{id}     - Update service (Admin)
DELETE /api/services/{id}     - Delete service (Admin)
```

### Bookings
```
POST   /api/bookings          - Create booking
GET    /api/bookings          - Get bookings (filtered by role)
GET    /api/bookings/{id}     - Get booking by ID
GET    /api/bookings/admin/all - Get all bookings (Admin)
```

### Payments
```
POST   /api/payments/create-order  - Create payment order
POST   /api/payments/verify        - Verify payment
GET    /api/payments/stripe-key    - Get Stripe public key
```

### Currency
```
GET    /api/currency/rate          - Get current exchange rate
POST   /api/currency/convert       - Convert currency
```

## 💳 Payment Gateway Setup

### Stripe (International Payments)

1. Sign up at https://stripe.com
2. Get your API keys from Dashboard → Developers → API Keys
3. Add to `application.properties`:
```properties
stripe.api.key=sk_test_...           # Secret key
stripe.publishable.key=pk_test_...   # Publishable key
```

### Razorpay (India Payments)

1. Sign up at https://razorpay.com
2. Get your keys from Settings → API Keys
3. Add to `application.properties`:
```properties
razorpay.key.id=rzp_test_...
razorpay.key.secret=your_secret
```

## 📧 Email Configuration

### Using Gmail SMTP

1. Enable 2-Factor Authentication
2. Generate App Password: https://myaccount.google.com/apppasswords
3. Configure in `application.properties`:
```properties
spring.mail.username=your@gmail.com
spring.mail.password=your_16_char_app_password
```

### Using Brevo API (Recommended)

1. Sign up at https://www.brevo.com
2. Get API key from Settings → SMTP & API
3. Add to `application.properties`:
```properties
brevo.api.key=your_brevo_api_key
brevo.from.email=your@email.com
brevo.from.name=NexaFlow
```

## 🔒 Security

- **JWT Tokens** - Expires in 7 days (configurable)
- **Password Encoding** - BCrypt hashing
- **CORS** - Configurable allowed origins
- **Role-Based Access Control** - Admin and Client roles
- **API Security** - Protected endpoints with JWT authentication

## 🗄️ Database Schema

The application automatically creates all necessary tables on startup:

- `users` - User accounts (Admin & Client)
- `services` - Service offerings
- `bookings` - Booking records
- `projects` - Project management
- `invoices` - Invoice records
- `milestones` - Project milestones
- `deliverables` - Project deliverables
- `coupons` - Discount coupons
- `messages` - Internal messaging
- `testimonials` - Client testimonials
- `notifications` - User notifications
- `email_logs` - Email delivery logs
- `time_entries` - Time tracking

## 🌍 Deployment

### Docker Deployment (Recommended)

Create `Dockerfile`:
```dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Build and run:
```bash
mvn clean package
docker build -t nexaflow-backend .
docker run -p 8080:8080 nexaflow-backend
```

### Heroku Deployment

1. Create `Procfile`:
```
web: java -jar target/nexaflow-backend-3.0.0.jar
```

2. Deploy:
```bash
heroku create nexaflow-backend
git push heroku main
```

### Railway/Render Deployment

Simply connect your Git repository and configure environment variables in the dashboard.

## 🧪 Testing

Run tests:
```bash
mvn test
```

## 📚 API Documentation

For detailed API documentation, you can integrate Swagger/OpenAPI:

Add to `pom.xml`:
```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.2.0</version>
</dependency>
```

Access at: `http://localhost:8080/swagger-ui.html`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

MIT License

## 💬 Support

For questions and support:
- Email: hello@nexaflow.in
- Documentation: Full API docs available in Postman collection

## 🎉 What's Included

✅ Complete backend with all features from original Node.js version
✅ PostgreSQL database support
✅ H2 in-memory database for testing
✅ Comprehensive error handling
✅ Input validation
✅ Email service with beautiful HTML templates
✅ Payment gateway integration (Stripe + Razorpay)
✅ JWT authentication
✅ Role-based access control
✅ Dual currency support with auto-refresh
✅ Default data initialization
✅ Production-ready configuration

---

Built with ❤️ using Spring Boot
