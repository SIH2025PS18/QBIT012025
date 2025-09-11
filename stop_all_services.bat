@echo off
echo ========================================
echo    Stopping All Telemedicine Services
echo ========================================
echo.

echo Stopping services on ports 3000, 4000, 5000, 5173...

REM Kill processes on each port
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":3000"') do (
    if "%%a" neq "" (
        echo Stopping process on port 3000 (PID: %%a)
        taskkill /PID %%a /F >nul 2>&1
    )
)

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":4000"') do (
    if "%%a" neq "" (
        echo Stopping process on port 4000 (PID: %%a)
        taskkill /PID %%a /F >nul 2>&1
    )
)

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5000"') do (
    if "%%a" neq "" (
        echo Stopping process on port 5000 (PID: %%a)
        taskkill /PID %%a /F >nul 2>&1
    )
)

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5173"') do (
    if "%%a" neq "" (
        echo Stopping process on port 5173 (PID: %%a)
        taskkill /PID %%a /F >nul 2>&1
    )
)

echo.
echo ✅ All services stopped successfully!
echo.
pause