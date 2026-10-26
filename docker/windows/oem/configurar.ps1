# Instala lo que pide el manual: JDK 17 (Temurin), Maven 3.9, Git y VS Code.
# Se ejecuta como administrador durante la instalación de Windows. Registro en C:\OEM\configurar.log
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$descargas = 'C:\OEM\descargas'
New-Item -ItemType Directory -Force $descargas | Out-Null

function Descargar($url, $destino) {
    Write-Host "Descargando $url"
    Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing
}

function Agregar-AlPath($ruta) {
    $path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    if ($path -notlike "*$ruta*") {
        [Environment]::SetEnvironmentVariable('Path', "$path;$ruta", 'Machine')
    }
}

# 1. JDK 17 con JAVA_HOME y Path
Descargar 'https://api.adoptium.net/v3/installer/latest/17/ga/windows/x64/jdk/hotspot/normal/eclipse' "$descargas\temurin17.msi"
Start-Process msiexec.exe -Wait -ArgumentList "/i `"$descargas\temurin17.msi`" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome /qn"

# 2. Maven 3.9 con MAVEN_HOME y Path
$mavenVersion = '3.9.11'
$mavenHome = "C:\Program Files\Apache\apache-maven-$mavenVersion"
Descargar "https://archive.apache.org/dist/maven/maven-3/$mavenVersion/binaries/apache-maven-$mavenVersion-bin.zip" "$descargas\maven.zip"
Expand-Archive "$descargas\maven.zip" 'C:\Program Files\Apache' -Force
[Environment]::SetEnvironmentVariable('MAVEN_HOME', $mavenHome, 'Machine')
Agregar-AlPath "$mavenHome\bin"

# 3. Git para Windows (última versión estable)
$release = Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest'
$gitUrl = ($release.assets | Where-Object { $_.name -match '^Git-.*-64-bit\.exe$' } | Select-Object -First 1).browser_download_url
Descargar $gitUrl "$descargas\git.exe"
Start-Process "$descargas\git.exe" -Wait -ArgumentList '/VERYSILENT /NORESTART /NOCANCEL /SP- /SUPPRESSMSGBOXES'

# 4. VS Code para todos los usuarios, con "Abrir con Code" y en el Path
Descargar 'https://update.code.visualstudio.com/latest/win32-x64/stable' "$descargas\vscode.exe"
Start-Process "$descargas\vscode.exe" -Wait -ArgumentList '/VERYSILENT /NORESTART /MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath'

# 5. Las extensiones y la copia del proyecto son por usuario: se hacen al primer inicio de sesión.
$inicio = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\canvia-primer-inicio.cmd'
Set-Content -Path $inicio -Encoding ASCII -Value 'powershell -NoProfile -ExecutionPolicy Bypass -File "C:\OEM\primer-inicio.ps1"'

Remove-Item $descargas -Recurse -Force
Write-Host 'Configuracion terminada.'
