@echo off
rem Lo ejecuta Windows una sola vez, al final de la instalación (perfil "listo").
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\OEM\configurar.ps1" > "C:\OEM\configurar.log" 2>&1
