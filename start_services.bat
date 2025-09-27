@echo off
echo Starting Telemedicine Integration...
echo.

cd /d "c:\Users\Asus\Desktop\IIIT BH\CODING\flutter_projects\telemed\web_dashboards\webrtc-signal"

echo Installing WebRTC Signal Server dependencies...
call npm install

echo.
echo Starting WebRTC Signal Server on port 4000...
start "WebRTC Signal Server" cmd /k "node server/index.js"

timeout /t 3 /nobreak >nul

cd /d "c:\Users\Asus\Desktop\IIIT BH\CODING\flutter_projects\telemed\web_dashboards\doctor-dashboard"

echo Installing Doctor Dashboard dependencies...
call npm install

echo.
echo Starting Doctor Dashboard on port 5173...
start "Doctor Dashboard" cmd /k "npm run dev"

echo.
echo ========================================
echo Both services are starting...
echo ========================================
echo WebRTC Signal Server: http://192.168.1.7:4000
echo Doctor Dashboard: http://192.168.1.7:5173
echo ========================================
echo.
echo Press any key to close this window...
pause >nul
