#!/bin/bash

# Telemed Web Build Script
# This script creates a working web build by temporarily using web-compatible dependencies

echo "🚀 Building Telemed Web Platform..."

# Backup original pubspec.yaml
cp pubspec.yaml pubspec_backup.yaml

# Use web-only pubspec temporarily
cp pubspec_web.yaml pubspec.yaml

echo "📦 Installing web-compatible dependencies..."
flutter pub get

echo "🌐 Building Flutter web app..."
flutter build web \
  --dart-define=ENVIRONMENT=production \
  --dart-define=PLATFORM=web \
  --base-href /telemed18/ \
  --target lib/main_web.dart \
  --release

# Restore original pubspec.yaml
mv pubspec_backup.yaml pubspec.yaml

echo "✅ Web build completed successfully!"
echo "📁 Build files are in: build/web/"
echo "🌍 Ready for deployment to GitHub Pages!"

# Optional: Start local server for testing
read -p "Start local server for testing? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌐 Starting local server on http://localhost:8000..."
    cd build/web
    python -m http.server 8000 2>/dev/null || python3 -m http.server 8000 2>/dev/null || echo "Python not found. Please serve files manually."
fi