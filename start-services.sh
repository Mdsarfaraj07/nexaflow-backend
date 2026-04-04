#!/bin/bash
# NexaFlow Startup Script - Railway Deployment
# Starts both Backend (Spring Boot) and Frontend (Node.js)

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║      NexaFlow Startup - Production Environment                 ║"
echo "╚════════════════════════════════════════════════════════════════╝"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log
log() {
  echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# Function to error
error() {
  echo -e "${YELLOW}[ERROR]${NC} $1"
  exit 1
}

# Function to success
success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# ============================================
# 1. VALIDATE ENVIRONMENT
# ============================================
log "Validating environment variables..."

if [ -z "$SPRING_PROFILES_ACTIVE" ]; then
  export SPRING_PROFILES_ACTIVE="production"
fi

if [ -z "$PORT" ]; then
  export PORT=8080
fi

if [ -z "$NODE_ENV" ]; then
  export NODE_ENV="production"
fi

if [ -z "$FRONTEND_PORT" ]; then
  export FRONTEND_PORT=3000
fi

log "SPRING_PROFILES_ACTIVE: $SPRING_PROFILES_ACTIVE"
log "BACKEND_PORT: $PORT"
log "FRONTEND_PORT: $FRONTEND_PORT"
log "NODE_ENV: $NODE_ENV"

# ============================================
# 2. CHECK DATABASE CONNECTION
# ============================================
if [ ! -z "$DB_HOST" ]; then
  log "Verifying database connection to $DB_HOST:${DB_PORT:-3306}..."
  
  # Wait for database to be ready (retry logic)
  for i in {1..30}; do
    if nc -z $DB_HOST ${DB_PORT:-3306} 2>/dev/null; then
      success "Database is ready!"
      break
    fi
    if [ $i -eq 30 ]; then
      error "Database not accessible after 30 attempts"
    fi
    log "Waiting for database... (attempt $i/30)"
    sleep 2
  done
fi

# ============================================
# 3. START FRONTEND SERVICE (Background)
# ============================================
if [ -d "./frontend" ]; then
  log "Starting Frontend Server (Node.js)..."
  
  cd frontend
  
  # Create .env if it doesn't exist
  if [ ! -f ".env" ]; then
    cat > .env << EOF
NODE_ENV=${NODE_ENV}
PORT=${FRONTEND_PORT}
BACKEND_URL=${BACKEND_URL:-http://localhost:8080}
APP_URL=${APP_URL:-http://localhost:${FRONTEND_PORT}}
JWT_SECRET=${JWT_SECRET}
RAZORPAY_KEY_ID=${RAZORPAY_KEY_ID}
STRIPE_PUBLISHABLE_KEY=${STRIPE_PUBLISHABLE_KEY}
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_USER=${SMTP_USER}
SMTP_PASS=${SMTP_PASS}
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
EOF
    log "Created .env file in frontend directory"
  fi
  
  # Start frontend in background
  nohup npm start > /tmp/frontend.log 2>&1 &
  FRONTEND_PID=$!
  success "Frontend started (PID: $FRONTEND_PID)"
  
  cd ..
else
  log "Frontend directory not found, skipping..."
fi

# ============================================
# 4. START BACKEND SERVICE (Foreground)
# ============================================
if [ -d "./backend" ] && [ -f "./backend/app.jar" ]; then
  log "Starting Backend Server (Spring Boot)..."
  
  cd backend
  
  # Build Java command with all environment variables
  JAVA_OPTS="-Xmx512m -Xms256m"
  
  exec java $JAVA_OPTS \
    -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE \
    -Dserver.port=$PORT \
    -Dspring.datasource.url="jdbc:mysql://${DB_HOST}:${DB_PORT:-3306}/${DB_NAME}" \
    -Dspring.datasource.username=$DB_USER \
    -Dspring.datasource.password=$DB_PASS \
    -Dapp.jwt.secret="$JWT_SECRET" \
    -Dapp.cors.allowed-origins="$CORS_ALLOWED_ORIGINS" \
    -Dspring.mail.host=$MAIL_HOST \
    -Dspring.mail.port=$MAIL_PORT \
    -Dspring.mail.username=$MAIL_USERNAME \
    -Dspring.mail.password=$MAIL_PASSWORD \
    -Dspring.mail.from=$MAIL_FROM \
    -jar app.jar
else
  error "Backend application JAR not found!"
fi
