# Corre en cada inicio de sesión, pero solo trabaja la primera vez por usuario.
$marca = "$env:USERPROFILE\.canvia-configurado"
if (Test-Path $marca) { exit 0 }

$code = 'C:\Program Files\Microsoft VS Code\bin\code.cmd'
foreach ($ext in 'vscjava.vscode-java-pack', 'CucumberOpen.cucumber-official') {
    & $code --install-extension $ext --force
}

# Copia el repositorio (carpeta compartida por Docker) al escritorio.
$origen = '\host.lan\Data'
$destino = "$env:USERPROFILE\Desktop\canvia-restassured-bdd"
if (Test-Path $origen) {
    robocopy $origen $destino /E /XD target node_modules /NFL /NDL /NJH /NJS | Out-Null
}

New-Item -ItemType File $marca | Out-Null
