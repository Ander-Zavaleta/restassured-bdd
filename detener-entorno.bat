@echo off
cd /d "%~dp0"
docker compose down
echo Entorno detenido. Tus archivos siguen en esta carpeta.
pause
