# ═══════════════════════════════════════════════════════════════════
#  NexaFlow v3.0 — Production Deployment Script (Windows PowerShell)
#  
#  Usage: powershell -ExecutionPolicy Bypass -File deploy.ps1 -Environment production
# ═══════════════════════════════════════════════════════════════════

param(
    [string]$Environment = "development",
    [switch]$SkipBuild = $false
)

# Configuration
$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BackendDir = Join-Path $ProjectRoot "nexaflow-backend"
$FrontendDir = Join-Path $ProjectRoot "nexaflow-v3-complete"
$LogDir = Join-Path $ProjectRoot "logs"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Create logs directory
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

# Color output functions
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[✓] $Message" "Green"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[✗] $Message" "Red"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "[!] $Message" "Yellow"
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput "[i] $Message" "Cyan"
}

# Check prerequisites
function Check-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    $required = @("java", "mvn", "node", "npm")
    $missing = @()
    
    foreach ($cmd in $required) {
        if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
            $missing += $cmd
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Error "Missing prerequisites: $($missing -join ', ')"
        exit 1
    }
    
    Write-Success "All prerequisites satisfied"
}

# Load environment
function Load-Environment {
    Write-Info "Loading environment: $Environment"
    
    $envFile = Join-Path $ProjectRoot ".env"
    
    if (!(Test-Path $envFile)) {
        Write-Error ".env file not found"
        Write-Info "Please copy .env.example to .env and configure it"
        exit 1
    }
    
    # Load .env file
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            
            # Remove quotes if present
            if ($value -match '^["\'](.+)["\']$') {
                $value = $matches[1]
            }
            
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
    
    Write-Success "Environment loaded"
}

# Build backend
function Build-Backend {
    Write-Info "Building backend..."
    
    Push-Location $BackendDir
    
    try {
        if ($Environment -eq "production") {
            mvn clean package -DskipTests -Pproduction -q
        } else {
            mvn clean package -DskipTests -q
        }
        Write-Success "Backend built successfully"
    } catch {
        Write-Error "Backend build failed: $_"
        Pop-Location
        exit 1
    }
    
    Pop-Location
}

# Build frontend
function Build-Frontend {
    Write-Info "Building frontend..."
    
    Push-Location $FrontendDir
    
    try {
        npm ci --only=production
        Write-Success "Frontend built successfully"
    } catch {
        Write-Error "Frontend build failed: $_"
        Pop-Location
        exit 1
    }
    
    Pop-Location
}

# Start backend
function Start-Backend {
    Write-Info "Starting backend on port 8080..."
    
    Push-Location $BackendDir
    
    $jarFile = Get-ChildItem "target/*.jar" | Select-Object -First 1
    
    if (!$jarFile) {
        Write-Error "No JAR file found in target directory"
        Pop-Location
        exit 1
    }
    
    # Start backend in new window or background job
    $javaArgs = @(
        "-Dspring.profiles.active=$Environment",
        "-Dspring.config.location=classpath:application.properties,classpath:application-$Environment.properties",
        "-jar",
        $jarFile.FullName
    )
    
    $logFile = Join-Path $LogDir "backend_$Timestamp.log"
    
    Start-Process -FilePath "java" `
                  -ArgumentList $javaArgs `
                  -RedirectStandardOutput $logFile `
                  -RedirectStandardError $logFile `
                  -NoNewWindow
    
    Write-Success "Backend started (check logs: $logFile)"
    
    # Wait for backend to be ready
    Write-Info "Waiting for backend to be ready..."
    $maxAttempts = 30
    $attempt = 0
    
    while ($attempt -lt $maxAttempts) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" `
                                         -ErrorAction SilentlyContinue -UseBasicParsing
            if ($response.StatusCode -eq 200) {
                Write-Success "Backend is ready"
                break
            }
        } catch {
            # Service not ready yet
        }
        
        $attempt++
        Start-Sleep -Seconds 1
    }
    
    if ($attempt -ge $maxAttempts) {
        Write-Warning "Backend health check timeout (check logs for errors)"
    }
    
    Pop-Location
}

# Start frontend
function Start-Frontend {
    Write-Info "Starting frontend on port 3000..."
    
    Push-Location $FrontendDir
    
    $logFile = Join-Path $LogDir "frontend_$Timestamp.log"
    
    Start-Process -FilePath "npm" `
                  -ArgumentList "start" `
                  -RedirectStandardOutput $logFile `
                  -RedirectStandardError $logFile `
                  -NoNewWindow
    
    Write-Success "Frontend started (check logs: $logFile)"
    
    # Wait for frontend to be ready
    Write-Info "Waiting for frontend to be ready..."
    $maxAttempts = 30
    $attempt = 0
    
    while ($attempt -lt $maxAttempts) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:3000" `
                                         -ErrorAction SilentlyContinue -UseBasicParsing
            if ($response.StatusCode -eq 200) {
                Write-Success "Frontend is ready"
                break
            }
        } catch {
            # Service not ready yet
        }
        
        $attempt++
        Start-Sleep -Seconds 1
    }
    
    if ($attempt -ge $maxAttempts) {
        Write-Warning "Frontend health check timeout (check logs for errors)"
    }
    
    Pop-Location
}

# Show deployment summary
function Show-Summary {
    ""
    Write-ColorOutput "════════════════════════════════════════════════════════════════════" "Cyan"
    Write-ColorOutput "  NexaFlow v3.0 - Deployment Summary" "Cyan"
    Write-ColorOutput "════════════════════════════════════════════════════════════════════" "Cyan"
    ""
    Write-Host "  Environment: $Environment"
    Write-Host "  Project Root: $ProjectRoot"
    Write-Host "  Timestamp: $Timestamp"
    ""
    Write-Host "  Services:"
    Write-Host "    • Frontend: http://localhost:3000"
    Write-Host "    • Backend API: http://localhost:8080"
    Write-Host "    • API Docs: http://localhost:8080/api"
    Write-Host "    • Health: http://localhost:8080/actuator/health"
    ""
    Write-Host "  Logs:"
    Write-Host "    • Backend: $(Join-Path $LogDir "backend_$Timestamp.log")"
    Write-Host "    • Frontend: $(Join-Path $LogDir "frontend_$Timestamp.log")"
    ""
    Write-Host "  Next Steps:"
    Write-Host "    1. Open browser to http://localhost:3000"
    Write-Host "    2. Configure payment gateways in .env"
    Write-Host "    3. Set up scheduled backups"
    ""
    Write-ColorOutput "════════════════════════════════════════════════════════════════════" "Cyan"
    ""
}

# Main function
function Main {
    Write-ColorOutput "═══════════════════════════════════════════════════════════════════" "Cyan"
    Write-ColorOutput "  NexaFlow v3.0 - Production Deployment Script (Windows)" "Cyan"
    Write-ColorOutput "═══════════════════════════════════════════════════════════════════" "Cyan"
    ""
    
    Check-Prerequisites
    Load-Environment
    
    if (!$SkipBuild) {
        Build-Backend
        Build-Frontend
    }
    
    Start-Backend
    Start-Frontend
    
    Show-Summary
    
    Write-Success "Deployment completed successfully!"
    Write-Info "Press Ctrl+C to stop the services"
}

# Run main function
try {
    Main
    
    # Keep running
    while ($true) {
        Start-Sleep -Seconds 10
    }
} catch {
    Write-Error "Deployment failed: $_"
    exit 1
}
