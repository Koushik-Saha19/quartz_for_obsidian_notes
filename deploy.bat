@echo off
setlocal enabledelayedexpansion

REM ====== CONFIGURE THESE ======
set REPO_URL=https://github.com/Koushik-Saha19/devops_notes.git
set BRANCH=main
REM =============================

echo [1/4] Building site...
call pnpm quartz build
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed with exit code %ERRORLEVEL%
    goto :end
)

echo [2/4] Copying into temp folder...
rmdir /s /q deploy-temp 2>nul
mkdir deploy-temp
xcopy /E /I /Y public\* deploy-temp\ > nul

cd deploy-temp

echo [3/4] Initializing git repo...
git init > nul
git checkout -b %BRANCH% > nul
git remote add origin %REPO_URL%

git add .
git commit -m "Update site" > nul

echo [4/4] Pushing to GitHub...
git push -f origin %BRANCH%

cd ..
rmdir /s /q deploy-temp

echo ✅ Deployment complete!

:end
echo Press any key to exit...
pause > nul
