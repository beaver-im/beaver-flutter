@echo off
chcp 65001 >nul
REM Beaver IM Flutter - run on Xiaomi/Redmi (M2006J10C) with DEV environment
setlocal

set "ENV_NAME=dev"
set "DEVICE_ID=454pukytzlrkp7bm"

echo [Beaver] Running on Xiaomi device %DEVICE_ID% with ENV=%ENV_NAME%
fvm flutter run -d %DEVICE_ID% --dart-define=ENV=%ENV_NAME%

endlocal
