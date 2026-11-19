@echo off
chcp 65001 >nul
REM Beaver IM Flutter - build PROD release APK
setlocal

set "ENV_NAME=prod"

echo [Beaver] Building release APK with ENV=%ENV_NAME%
fvm flutter build apk --release --dart-define=ENV=%ENV_NAME%

echo.
echo [Beaver] Output: build\app\outputs\flutter-apk\app-release.apk
endlocal
