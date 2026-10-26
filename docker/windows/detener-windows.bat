@echo off
cd /d "%~dp0"
docker compose --profile limpio --profile listo stop
echo Windows apagado. El disco se conserva; para borrarlo: docker compose --profile limpio --profile listo down -v
pause
