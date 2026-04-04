#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
#  NexaFlow v3.0 — Production Deployment Script (Linux/macOS)
#  
#  Usage: bash deploy.sh [production|development|staging]
# ═══════════════════════════════════════════════════════════════════

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-production}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_ROOT/nexaflow-backend"
FRONTEND_DIR="$PROJECT_ROOT/nexaflow-v3-complete"
LOG_DIR="$PROJECT_ROOT/logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create logs directory
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    if ! command -v java &> /dev/null; then
        log_error "Java is not installed"
        exit 1
    fi
    
    if ! command -v mvn &> /dev/null; then
        log_error "Maven is not installed"
        exit 1
    fi
    
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        log_warning "Docker is not installed (required for Docker deployment)"
    fi
    
    log_success "All prerequisites satisfied"
}

# Load environment
load_environment() {
    log "Loading environment: $ENVIRONMENT"
    
    if [ ! -f "$PROJECT_ROOT/.env" ]; then
        log_error ".env file not found"
        log "Please copy .env.example to .env and configure it"
        exit 1
    fi
    
    # shellcheck source=/dev/null
    source "$PROJECT_ROOT/.env"
    log_success "Environment loaded"
}

# Build backend
build_backend() {
    log "Building backend..."
    
    cd "$BACKEND_DIR"
    
    if [ "$ENVIRONMENT" = "production" ]; then
        mvn clean package -DskipTests -Pproduction -q
    else
        mvn clean package -DskipTests -q
    fi
    
    log_success "Backend built successfully"
}

# Build frontend
build_frontend() {
    log "Building frontend..."
    
    cd "$FRONTEND_DIR"
    npm ci --only=production
    
    log_success "Frontend built successfully"
}

# Deploy with Docker Compose
deploy_docker() {
    log "Deploying with Docker Compose..."
    
    cd "$PROJECT_ROOT"
    
    if [ "$ENVIRONMENT" = "production" ]; then
        docker-compose -f docker-compose.production.yml build
        docker-compose -f docker-compose.production.yml up -d
    else
        docker-compose up -d
    fi
    
    log_success "Docker deployment completed"
    
    # Wait for services to be ready
    log "Waiting for services to be ready..."
    sleep 10
    
    # Health check
    if curl -f http://localhost:8080/actuator/health &> /dev/null; then
        log_success "Backend is running"
    else
        log_error "Backend health check failed"
        return 1
    fi
    
    if curl -f http://localhost:3000 &> /dev/null; then
        log_success "Frontend is running"
    else
        log_error "Frontend health check failed"
        return 1
    fi
}

# Deploy standalone (without Docker)
deploy_standalone() {
    log "Deploying standalone..."
    
    # Build backend
    build_backend
    
    # Build frontend  
    build_frontend
    
    log "Starting services..."
    
    # Start backend in background
    log "Starting backend on port 8080..."
    cd "$BACKEND_DIR"
    nohup java -Dspring.profiles.active="$ENVIRONMENT" \
        -Dspring.config.location=classpath:application.properties,classpath:application-"$ENVIRONMENT".properties \
        -jar target/*.jar > "$LOG_DIR/backend_$TIMESTAMP.log" 2>&1 &
    BACKEND_PID=$!
    echo "$BACKEND_PID" > "$LOG_DIR/backend.pid"
    log_success "Backend started (PID: $BACKEND_PID)"
    
    # Start frontend in background
    log "Starting frontend on port 3000..."
    cd "$FRONTEND_DIR"
    nohup npm start > "$LOG_DIR/frontend_$TIMESTAMP.log" 2>&1 &
    FRONTEND_PID=$!
    echo "$FRONTEND_PID" > "$LOG_DIR/frontend.pid"
    log_success "Frontend started (PID: $FRONTEND_PID)"
    
    # Wait for services
    sleep 5
    
    # Health check
    if curl -f http://localhost:8080/actuator/health &> /dev/null; then
        log_success "Backend is running"
    else
        log_error "Backend failed to start"
        kill $BACKEND_PID 2>/dev/null || true
        return 1
    fi
    
    if curl -f http://localhost:3000 &> /dev/null; then
        log_success "Frontend is running"
    else
        log_error "Frontend failed to start"
        kill $FRONTEND_PID 2>/dev/null || true
        return 1
    fi
}

# Stop services
stop_services() {
    log "Stopping services..."
    
    if [ -f "$LOG_DIR/backend.pid" ]; then
        BACKEND_PID=$(cat "$LOG_DIR/backend.pid")
        kill $BACKEND_PID 2>/dev/null || true
        rm "$LOG_DIR/backend.pid"
        log_success "Backend stopped"
    fi
    
    if [ -f "$LOG_DIR/frontend.pid" ]; then
        FRONTEND_PID=$(cat "$LOG_DIR/frontend.pid")
        kill $FRONTEND_PID 2>/dev/null || true
        rm "$LOG_DIR/frontend.pid"
        log_success "Frontend stopped"
    fi
}

# Generate configuration summary
show_summary() {
    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "  NexaFlow v3.0 - Deployment Summary"
    echo "════════════════════════════════════════════════════════════════════"
    echo""
    echo "  Environment: $ENVIRONMENT"
    echo "  Project Root: $PROJECT_ROOT"
    echo "  Timestamp: $TIMESTAMP"
    echo ""
    echo "  Services:"
    echo "    • Frontend: http://localhost:3000"
    echo "    • Backend API: http://localhost:8080"
    echo "    • API Docs: http://localhost:8080/api"
    echo "    • Health: http://localhost:8080/actuator/health"
    echo ""
    echo "  Logs:"
    echo "    • Backend: $LOG_DIR/backend_$TIMESTAMP.log"
    echo "    • Frontend: $LOG_DIR/frontend_$TIMESTAMP.log"
    echo ""
    echo "  Next Steps:"
    echo "    1. Access frontend: https://yourdomain.com"
    echo "    2. Configure payment gateways in .env"
    echo "    3. Set up backups and monitoring"
    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
}

# Main execution
main() {
    log "═══════════════════════════════════════════════════════════════════"
    log "  NexaFlow v3.0 - Production Deployment Script"
    log "═══════════════════════════════════════════════════════════════════"
    log ""
    
    check_prerequisites
    load_environment
    
    case "$ENVIRONMENT" in
        production|staging)
            deploy_docker
            ;;
        development)
            deploy_standalone
            ;;
        *)
            log_error "Unknown environment: $ENVIRONMENT"
            log "Usage: bash deploy.sh [production|development|staging]"
            exit 1
            ;;
    esac
    
    show_summary
    log_success "Deployment completed successfully!"
}

# Handle signals
trap 'log_error "Deployment interrupted"; stop_services; exit 1' INT TERM

# Run main function
main
