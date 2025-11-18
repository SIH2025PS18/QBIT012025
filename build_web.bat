# Telemed Web Build Script for Windows PowerShell
# This script creates a working web build by temporarily using web-compatible dependencies

Write-Host "🚀 Building Telemed Web Platform..." -ForegroundColor Green

# Backup original pubspec.yaml
Copy-Item "pubspec.yaml" "pubspec_backup.yaml"

# Use web-only pubspec temporarily
Copy-Item "pubspec_web.yaml" "pubspec.yaml"

Write-Host "📦 Installing web-compatible dependencies..." -ForegroundColor Blue
flutter pub get

Write-Host "🌐 Building Flutter web app..." -ForegroundColor Blue
flutter build web --dart-define=ENVIRONMENT=production --dart-define=PLATFORM=web --base-href /telemed18/ --target lib/main_web.dart --release

# Restore original pubspec.yaml
Move-Item "pubspec_backup.yaml" "pubspec.yaml" -Force

Write-Host "✅ Web build completed successfully!" -ForegroundColor Green
Write-Host "📁 Build files are in: build/web/" -ForegroundColor Cyan
Write-Host "🌍 Ready for deployment to GitHub Pages!" -ForegroundColor Cyan

# Optional: Start local server for testing
$response = Read-Host "Start local server for testing? (y/N)"
if ($response -eq "y" -or $response -eq "Y") {
    Write-Host "🌐 Starting local server on http://localhost:8000..." -ForegroundColor Blue
    Set-Location "build/web"
    
    # Try to start server with different methods
    try {
        python -m http.server 8000
    }
    catch {
        try {
            python3 -m http.server 8000
        }
        catch {
            Write-Host "Python not found. Please serve files manually or use Live Server extension." -ForegroundColor Yellow
        }
    }
}