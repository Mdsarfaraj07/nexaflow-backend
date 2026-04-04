# ==========================================
# NexaFlow Production Dockerfile - Railway
# ==========================================
# Multi-stage build for optimized production image

# Stage 1: Build Backend (Spring Boot - Java)
FROM maven:3.8.1-openjdk-17 as backend-builder
WORKDIR /build/backend

# Copy Maven files
COPY nexaflow-backend/pom.xml .
COPY nexaflow-backend/src ./src

# Build the backend JAR
RUN mvn clean package -DskipTests -q && \
    ls -la target/*.jar && \
    mv target/nexaflow-backend-*.jar /build/backend/app.jar

# Stage 2: Build Frontend (Node.js)
FROM node:18-alpine as frontend-builder
WORKDIR /build/frontend

# Copy package files
COPY nexaflow-v3-complete/package*.json ./

# Install production dependencies only
RUN npm ci --only=production && \
    npm cache clean --force

# Stage 3: Runtime Environment
FROM eclipse-temurin:17-jdk-slim as runtime

WORKDIR /app

# Install Node.js and necessary utilities
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    curl \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Copy Backend JAR from builder
COPY --from=backend-builder /build/backend/app.jar ./backend/app.jar

# Copy Frontend files
COPY --from=frontend-builder /build/frontend/node_modules ./frontend/node_modules
COPY nexaflow-v3-complete/public ./frontend/public
COPY nexaflow-v3-complete/server.js ./frontend/server.js
COPY nexaflow-v3-complete/.env.production ./frontend/.env

# Copy startup script
COPY start-services.sh /app/start.sh
RUN chmod +x /app/start.sh

# Create logs directory
RUN mkdir -p /app/logs

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:${PORT:-8080}/api/auth/health || exit 1

# Expose ports
EXPOSE 8080 3000

# Run startup script
ENTRYPOINT ["/app/start.sh"]
