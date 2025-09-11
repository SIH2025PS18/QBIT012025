@echo off
echo ========================================
echo     Telemedicine Backend Server
echo ========================================
echo.

cd /d "%~dp0Telemedicine-Backend-main"

if not exist node_modules (
    echo Installing dependencies...
    npm install
    echo.
)

echo Starting Telemedicine Backend Server...
echo Server will be available at: http://localhost:5000
echo Health check: http://localhost:5000/health
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

npm start