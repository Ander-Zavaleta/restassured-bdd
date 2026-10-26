@echo off
setlocal
cd /d "%~dp0"

set PERFIL=%1
if "%PERFIL%"=="" set PERFIL=limpio
if not "%PERFIL%"=="limpio" if not "%PERFIL%"=="listo" (
  echo Uso: iniciar-windows.bat [limpio^|listo]
  exit /b 1
)

docker info >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Docker Desktop no esta abierto.
  pause
  exit /b 1
)

echo Levantando Windows (%PERFIL%). La primera vez descarga e instala Windows: 20 a 40 minutos.
docker compose --profile %PERFIL% up -d
if errorlevel 1 (
  pause
  exit /b 1
)

timeout /t 5 >nul
start "" http://localhost:8006
echo Abre http://localhost:8006 para ver el escritorio. Usuario: alumno / Clave: canvia
pause
