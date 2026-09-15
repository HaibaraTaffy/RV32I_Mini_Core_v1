@echo off
setlocal
cd /d "%~dp0"

set "REMOTE_URL=https://github.com/HaibaraTaffy/RV32I_Mini_Core_v1.git"
set "BRANCH=main"

where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git was not found. Install Git for Windows and try again.
    goto :failed
)

if not exist ".git" (
    echo [INFO] Initializing Git repository...
    git init
    if errorlevel 1 goto :failed
    git branch -M "%BRANCH%"
)

git remote get-url origin >nul 2>nul
if errorlevel 1 (
    git remote add origin "%REMOTE_URL%"
) else (
    git remote set-url origin "%REMOTE_URL%"
)
if errorlevel 1 goto :failed

set "COMMIT_MESSAGE=%~1"
if not defined COMMIT_MESSAGE set /p "COMMIT_MESSAGE=Commit message: "
if not defined COMMIT_MESSAGE set "COMMIT_MESSAGE=Update project"

echo [INFO] Staging changes...
git add -A
if errorlevel 1 goto :failed

git diff --cached --quiet
if errorlevel 1 (
    echo [INFO] Creating commit...
    git commit -m "%COMMIT_MESSAGE%"
    if errorlevel 1 goto :failed
) else (
    echo [INFO] No new changes to commit.
)

echo [INFO] Pushing %BRANCH% to GitHub...
git push -u origin "%BRANCH%"
if errorlevel 1 goto :failed

echo.
echo [SUCCESS] Project pushed to GitHub.
pause
exit /b 0

:failed
echo.
echo [ERROR] Operation failed. Review the message above.
pause
exit /b 1

