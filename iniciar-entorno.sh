#!/bin/sh
set -e
cd "$(dirname "$0")"
PUERTO=8800

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker no esta instalado: https://docs.docker.com/get-docker/"
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "[ERROR] Docker no esta en ejecucion. Inicialo y vuelve a intentar."
  exit 1
fi

echo "Construyendo y levantando el entorno. La primera vez tarda entre 5 y 10 minutos..."
docker compose up -d --build

echo "Esperando a que VS Code responda en http://localhost:$PUERTO ..."
i=0
until curl -s -o /dev/null "http://localhost:$PUERTO"; do
  i=$((i + 1))
  if [ "$i" -ge 60 ]; then
    echo "[ERROR] VS Code no respondio. Revisa: docker compose logs entorno"
    exit 1
  fi
  sleep 2
done

echo "Listo. Abre http://localhost:$PUERTO en tu navegador."
(command -v open >/dev/null && open "http://localhost:$PUERTO") || (command -v xdg-open >/dev/null && xdg-open "http://localhost:$PUERTO") || true
