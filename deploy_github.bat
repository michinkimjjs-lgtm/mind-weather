@echo off
cd /d "%~dp0"
echo ==========================================
echo       Mind Weather - GitHub Upload
echo ==========================================
echo.
echo.
echo Committing changes...
git add .
git commit -m "Update via script"

echo.
echo Uploading to GitHub...
echo.

git push -u origin main

if errorlevel 1 (
    echo.
    echo [!] Login Required / Upload Failed
    echo.
    echo A login window should appear. Please sign in.
    echo If no window appears, or if it fails again:
    echo 1. Keep this window open.
    echo 2. Check your internet connection.
    echo.
    pause
) else (
    echo.
    echo [OK] Upload Successful!
    echo.
    echo The window will close automatically...
    timeout /t 5
)
