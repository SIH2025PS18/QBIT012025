@echo off
echo ========================================
echo     Telemed Unified Backend Server
echo ========================================
echo.
echo Starting the complete telemedicine backend...
echo This combines both telemedicine and pharmacy features
echo.

cd /d "%~dp0backend"

if not exist node_modules (
    echo Installing dependencies...
    npm install
    echo.
)

echo Starting Unified Backend Server...
echo.
echo ✅ Server will be available at: http://localhost:5001
echo ✅ Health check: http://localhost:5001/api/health
echo ✅ API endpoints: http://localhost:5001/api
echo ✅ Socket.IO ready for real-time connections
echo.
echo 📋 Available APIs:
echo   - Authentication: /api/auth
echo   - Doctors: /api/doctors
echo   - Patients: /api/patients
echo   - Consultations: /api/consultations
echo   - Medicines: /api/medicines
echo   - Orders: /api/orders
echo   - Pharmacies: /api/pharmacies
echo   - Queue: /api/queue
echo   - Chat: /api/chat
echo   - Video Calls: /api/calls
echo   - Admin: /api/admin
echo.
echo ⚠️  Note: MongoDB is required for full functionality
echo    Start MongoDB service to enable database features
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

set PORT=5001
npm start