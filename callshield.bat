@echo off
REM ============================================================================
REM CallShield Project Helper Script
REM ============================================================================
REM This script provides quick commands for common Flutter development tasks
REM Usage: callshield.bat [command]
REM ============================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

if "%1"=="" (
    call :show_menu
) else (
    call :handle_command %*
)

exit /b 0

REM ============================================================================
REM Show Interactive Menu
REM ============================================================================
:show_menu
cls
echo.
echo ========================================
echo   CallShield Project Helper
echo ========================================
echo.
echo Select an option:
echo.
echo   1. Run the app
echo   2. Build for Android
echo   3. Build for iOS
echo   4. Build for Windows
echo   5. Build for Web
echo   6. Setup/Install dependencies
echo   7. Clean build files
echo   8. Run tests
echo   9. Exit
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto run_app
if "%choice%"=="2" goto build_android
if "%choice%"=="3" goto build_ios
if "%choice%"=="4" goto build_windows
if "%choice%"=="5" goto build_web
if "%choice%"=="6" goto setup
if "%choice%"=="7" goto clean
if "%choice%"=="8" goto run_tests
if "%choice%"=="9" goto end

echo Invalid choice. Please try again.
timeout /t 2
goto show_menu

REM ============================================================================
REM Handle Command Line Arguments
REM ============================================================================
:handle_command
set cmd=%1
if /i "%cmd%"=="run" goto run_app
if /i "%cmd%"=="build" goto build_all
if /i "%cmd%"=="build-android" goto build_android
if /i "%cmd%"=="build-ios" goto build_ios
if /i "%cmd%"=="build-windows" goto build_windows
if /i "%cmd%"=="build-web" goto build_web
if /i "%cmd%"=="setup" goto setup
if /i "%cmd%"=="clean" goto clean
if /i "%cmd%"=="test" goto run_tests
if /i "%cmd%"=="help" goto show_help

echo Unknown command: %cmd%
call :show_help
exit /b 1

REM ============================================================================
REM Commands
REM ============================================================================

:run_app
echo.
echo [*] Running Flutter app...
echo.
flutter run
if errorlevel 1 (
    echo.
    echo [!] Error running the app. Make sure Flutter SDK is installed and a device is connected.
)
goto end

:build_android
echo.
echo [*] Building for Android...
echo.
flutter build apk
if errorlevel 1 (
    echo.
    echo [!] Error building Android app.
) else (
    echo.
    echo [+] Android build complete. APK saved to: build\app\outputs\apk\release\
)
goto end

:build_ios
echo.
echo [*] Building for iOS...
echo.
flutter build ios
if errorlevel 1 (
    echo.
    echo [!] Error building iOS app. Make sure you're on macOS.
) else (
    echo.
    echo [+] iOS build complete.
)
goto end

:build_windows
echo.
echo [*] Building for Windows...
echo.
flutter build windows
if errorlevel 1 (
    echo.
    echo [!] Error building Windows app.
) else (
    echo.
    echo [+] Windows build complete. Executable saved to: build\windows\runner\Release\
)
goto end

:build_web
echo.
echo [*] Building for Web...
echo.
flutter build web
if errorlevel 1 (
    echo.
    echo [!] Error building Web app.
) else (
    echo.
    echo [+] Web build complete. Output saved to: build\web\
)
goto end

:build_all
echo.
echo [*] Building for all platforms...
echo.
echo Building Android...
flutter build apk
echo.
echo Building Windows...
flutter build windows
echo.
echo Building Web...
flutter build web
echo.
echo [+] All builds complete.
goto end

:setup
echo.
echo [*] Setting up project...
echo.
echo [1] Getting dependencies...
flutter pub get
echo.
echo [2] Checking Flutter setup...
flutter doctor
echo.
echo [+] Setup complete!
goto end

:clean
echo.
echo [*] Cleaning build files...
echo.
flutter clean
if errorlevel 1 (
    echo.
    echo [!] Error during clean.
) else (
    echo.
    echo [+] Clean complete.
)
goto end

:run_tests
echo.
echo [*] Running tests...
echo.
flutter test
if errorlevel 1 (
    echo.
    echo [!] Some tests failed.
) else (
    echo.
    echo [+] All tests passed!
)
goto end

:show_help
echo.
echo Usage: callshield.bat [command]
echo.
echo Commands:
echo   run              - Run the Flutter app
echo   build            - Build for all platforms
echo   build-android    - Build APK for Android
echo   build-ios        - Build for iOS
echo   build-windows    - Build for Windows
echo   build-web        - Build for Web
echo   setup            - Install dependencies and check Flutter setup
echo   clean            - Clean build files
echo   test             - Run tests
echo   help             - Show this help message
echo.
echo Run without arguments to see the interactive menu.
echo.
goto end

:end
if "%1"=="" (
    echo.
    pause
)
exit /b 0
