@echo off
setlocal
cd /d "%~dp0"
set PUERTO=8800

where docker >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Docker no esta instalado. Instala Docker Desktop: https://www.docker.com/products/docker-desktop/
  pause
  exit /b 1
)

docker info >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Docker Desktop no esta abierto. Abrelo, espera a que diga "Engine running" y vuelve a ejecutar este archivo.
  pause
  exit /b 1
)

echo Construyendo y levantando el entorno. La primera vez tarda entre 5 y 10 minutos...
docker compose up -d --build
if errorlevel 1 (
  echo [ERROR] No se pudo levantar el entorno. Revisa el mensaje de arriba.
  pause
  exit /b 1
)

echo Esperando a que VS Code responda en http://localhost:%PUERTO% ...
set /a INTENTOS=0
:esperar
curl -s -o nul http://localhost:%PUERTO%
if not errorlevel 1 goto listo
set /a INTENTOS+=1
if %INTENTOS% geq 60 (
  echo [ERROR] VS Code no respondio. Revisa: docker compose logs entorno
  pause
  exit /b 1
)
timeout /t 2 >nul
goto esperar

:listo
start "" http://localhost:%PUERTO%
echo.
echo Listo. VS Code esta abierto en http://localhost:%PUERTO%
echo Para apagarlo ejecuta detener-entorno.bat
pause
