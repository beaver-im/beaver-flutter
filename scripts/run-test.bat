@echo off
chcp 65001 >nul
REM Beaver IM Flutter - run on auto-detected device with TEST environment
setlocal

set "ENV_NAME=test"

echo [Beaver] Running with ENV=%ENV_NAME% (auto-select device)
fvm flutter run --dart-define=ENV=%ENV_NAME%

endlocal
