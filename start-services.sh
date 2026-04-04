#!/bin/bash
# NexaFlow Startup Script - Railway Deployment
# Starts the Spring Boot Backend on Railway

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║      NexaFlow Backend Startup - Production Environment         ║"
echo "╚════════════════════════════════════════════════════════════════╝"

# Default port
PORT=${PORT:-8080}
SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE:-production}

echo "[$(date)] Starting NexaFlow Backend on port $PORT..."
echo "[$(date)] Environment: $SPRING_PROFILES_ACTIVE"

# Wait for database if configured
if [ ! -z "$DB_HOST" ]; then
  echo "[$(date)] Waiting for database..."
  for i in {1..30}; do
    if timeout 2 bash -c "echo > /dev/tcp/$DB_HOST/${DB_PORT:-3306}" 2>/dev/null; then
      echo "[$(date)] Database is ready!"
      break
    fi
    echo "[$(date)] Waiting for database... (attempt $i/30)"
    sleep 2
  done
fi

# Start backend
cd /app/backend
echo "[$(date)] Starting Spring Boot application..."
exec java -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -jar app.jar
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
