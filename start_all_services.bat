@echo off
echo ========================================
echo    Starting All Telemedicine Services
echo ========================================
echo.

echo [1/4] Starting Medstore Backend (Port 5000)...
start "Medstore Backend" cmd /k "cd medstore\backend && npm start"
timeout /t 3 /nobreak >nul

echo [2/4] Starting WebRTC Signaling Server (Port 4000)...
start "WebRTC Signal" cmd /k "cd webrtc-signal\server && npm start"
timeout /t 3 /nobreak >nul

echo [3/4] Starting Doctor Dashboard (Port 5173)...
start "Doctor Dashboard" cmd /k "cd doctor-dashboard && npm run dev"
timeout /t 3 /nobreak >nul

echo [4/4] Starting Medstore Client (Port 3000)...
start "Medstore Client" cmd /k "cd medstore\client && npm start"
timeout /t 2 /nobreak >nul

echo.
echo ✅ All services started successfully!
echo.
echo 📊 Service URLs:
echo • Medstore Backend:     http://localhost:5000
echo • WebRTC Signaling:    http://localhost:4000
echo • Doctor Dashboard:    http://localhost:5173
echo • Medstore Client:     http://localhost:3000
echo.
echo 📱 Flutter App: Run 'flutter run' in the project root
echo.
echo 🔍 Health checks:
echo • Backend health:      http://localhost:5000/api/health
echo • WebRTC status:       http://localhost:4000
echo.
echo Press any key to close this window...
pause >nul