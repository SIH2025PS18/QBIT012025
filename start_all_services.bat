@echo off
echo ========================================
echo    Starting All Telemedicine Services
echo ========================================
echo.

echo [1/3] Starting Unified Backend (Port 5001)...
start "Unified Backend" cmd /k "cd backend && npm start"
timeout /t 3 /nobreak >nul

echo [2/3] Starting Doctor Dashboard (Port 8083)...
start "Doctor Dashboard" cmd /k "cd doctor_dashboard && start_dashboard.bat"
timeout /t 3 /nobreak >nul

echo [3/3] Starting Patient App...
echo    Run 'flutter run' in the project root to start the patient app
timeout /t 2 /nobreak >nul

echo.
echo ✅ All services started successfully!
echo.
echo 📊 Service URLs:
echo • Unified Backend:     http://192.168.1.7:5001
echo • Doctor Dashboard:    http://192.168.1.7:8083
echo.
echo 📱 Patient App: Run 'flutter run' in the project root
echo.
echo 🔍 Health checks:
echo • Backend health:      http://192.168.1.7:5001/api/health
echo.
echo Press any key to close this window...
pause >nul