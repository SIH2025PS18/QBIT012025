@echo off
echo ========================================
echo    Starting Doctor Dashboard on Port 8083
echo ========================================
echo.

echo Starting Doctor Dashboard...
flutter run -d chrome --web-port=8083

echo.
echo Doctor Dashboard should be running on http://192.168.1.7:8083
echo Press Ctrl+C to stop the server
pause