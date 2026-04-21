@echo off
echo Stopping any existing server on port 8080...
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') DO (
    taskkill /PID %%P /F >nul 2>&1
)
echo.
echo Starting SVCTE Bus App...
echo.

REM Try Python 3 first
python --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Found Python. Starting server on http://localhost:8080
    start "" "http://localhost:8080/svcte-bus-app-v4.html"
    python -m http.server 8080
    GOTO END
)

REM Try python3 command
python3 --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Found Python3. Starting server on http://localhost:8080
    start "" "http://localhost:8080/svcte-bus-app-v4.html"
    python3 -m http.server 8080
    GOTO END
)

REM Try Node.js npx serve
npx --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Found Node.js. Starting server on http://localhost:8080
    start "" "http://localhost:8080/svcte-bus-app-v4.html"
    npx serve -p 8080 -s .
    GOTO END
)

echo ERROR: Could not find Python or Node.js.
echo Please install Python from https://python.org and try again.
echo Or open svcte-bus-app-v4.html manually after running:
echo   python -m http.server 8080
pause
:END
