# ==========================================
# NexaFlow Backend Production Dockerfile
# Optimized for Railway Deployment
# ==========================================

# Stage 1: Build Backend (Spring Boot - Java)
FROM maven:3.9-eclipse-temurin-17-jammy AS backend-builder
WORKDIR /build/backend

# Copy Maven files
COPY nexaflow-backend/pom.xml .
COPY nexaflow-backend/src ./src

# Build the backend JAR
RUN mvn clean package -DskipTests -q && \
    mv target/nexaflow-backend-*.jar app.jar

# Stage 2: Runtime Environment
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Install required utilities
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy Backend JAR from builder
RUN mkdir -p /app/backend
COPY --from=backend-builder /build/backend/app.jar ./backend/app.jar

# Copy startup script
COPY start-services.sh /app/start.sh
RUN chmod +x /app/start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD curl -f http://localhost:${PORT:-8080}/api/health || exit 1

# Expose port
EXPOSE 8080

# Run startup script
ENTRYPOINT ["/app/start.sh"]
