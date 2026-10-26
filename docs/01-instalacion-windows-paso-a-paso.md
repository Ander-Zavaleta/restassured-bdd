# Instalación en Windows, paso a paso

Guion para configurar una PC Windows desde cero hasta ver los escenarios en verde.
El instructor lo sigue en vivo sobre un Windows limpio (ver [Windows en Docker](03-windows-en-docker-instructor.md))
y los alumnos replican cada paso en su PC.

Detalle completo, macOS/Linux y solución de errores: [manual de instalación (PDF)](pdf/manual-instalacion-restassured-cucumber.pdf).

| Paso | Qué instalamos | Comprobación |
|---|---|---|
| 0 | Terminal y winget | `winget --version` |
| 1 | JDK 17 (Temurin) | `java -version` |
| 2 | Maven 3.9 | `mvn -v` |
| 3 | Git | `git --version` |
| 4 | VS Code + extensiones | `code --version` |
| 5 | Proyecto | `mvn test` en verde |

---

## Paso 0 · Abrir la terminal

1. Clic derecho en el botón de Inicio → **Terminal**. Se abre PowerShell.
2. Comprueba que tienes `winget` (el instalador de paquetes de Windows):

```powershell
winget --version
```

Si dice que no se reconoce el comando, abre **Microsoft Store**, busca **Instalador de aplicación** y actualízalo.
La primera vez que uses `winget` te pedirá aceptar los términos: responde `Y`.

> Regla de oro: **después de cada instalación, cierra la terminal y abre una nueva**. Las variables de entorno
> nuevas solo se ven en terminales nuevas.

---

## Paso 1 · Java (JDK 17)

```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

Alternativa: el instalador `.msi` de <https://adoptium.net>. En la pantalla de componentes marca
**Set JAVA_HOME variable** y **Add to PATH**.

Cierra y abre la terminal. Comprueba:

```powershell
java -version
echo $env:JAVA_HOME
```

Esperado:

```text
openjdk version "17.0.x" ...
OpenJDK Runtime Environment Temurin-17.0.x+y
C:\Program Files\Eclipse Adoptium\jdk-17.0.x.y-hotspot\
```

**Si `JAVA_HOME` sale vacío**, créalo a mano (ajusta la carpeta a la que tengas):

```powershell
$jdk = (Get-ChildItem "C:\Program Files\Eclipse Adoptium" -Directory | Where-Object Name -like "jdk-17*").FullName
setx JAVA_HOME "$jdk"
```

**Si `java -version` dice `1.8`**: hay un Java viejo delante. Ve a *Editar las variables de entorno del sistema →
Variables de entorno → Path* y sube `%JAVA_HOME%\bin` al primer lugar.

---

## Paso 2 · Maven 3.9

Maven no tiene paquete oficial en winget; se instala descomprimiendo un zip.

1. Descarga **apache-maven-3.9.x-bin.zip** desde <https://maven.apache.org/download.cgi>.
2. Descomprímelo en `C:\Program Files\Apache\` (quedará `C:\Program Files\Apache\apache-maven-3.9.x`).
3. Crea la variable y agrégala al Path (PowerShell **como administrador**):

```powershell
$maven = (Get-ChildItem "C:\Program Files\Apache" -Directory | Where-Object Name -like "apache-maven-3.9*").FullName
[Environment]::SetEnvironmentVariable("MAVEN_HOME", $maven, "Machine")
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$path;$maven\bin", "Machine")
```

O por la interfaz: *Variables de entorno → Nueva* `MAVEN_HOME`, y en *Path → Nuevo* `%MAVEN_HOME%\bin`.

Cierra y abre la terminal. Comprueba:

```powershell
mvn -v
```

```text
Apache Maven 3.9.x
Java version: 17.0.x, vendor: Eclipse Adoptium, runtime: C:\Program Files\Eclipse Adoptium\jdk-17...
```

Mira la línea **Java version**: debe decir 17. Maven usa el Java de `JAVA_HOME`.

---

## Paso 3 · Git

```powershell
winget install --id Git.Git -e
```

Cierra y abre la terminal:

```powershell
git --version
```

La configuración de tu nombre, correo y cuenta de GitHub está en la [guía de Git y GitHub](04-git-y-github.md#3-configurar-git-una-sola-vez-por-pc).

---

## Paso 4 · VS Code y extensiones

```powershell
winget install Microsoft.VisualStudioCode
```

Cierra y abre la terminal, e instala las dos extensiones del curso:

```powershell
code --install-extension vscjava.vscode-java-pack
code --install-extension CucumberOpen.cucumber-official
```

| Extensión | Para qué |
|---|---|
| Extension Pack for Java | Autocompletado, compilación y depuración de Java |
| Cucumber (Gherkin) Full Support | Colores en los `.feature` y salto del step al código Java |

Al abrir el proyecto, VS Code también las sugiere (archivo `.vscode/extensions.json`).

---

## Paso 5 · Proyecto y primera ejecución

```powershell
mkdir C:\cursos
cd C:\cursos
git clone <url-de-este-repositorio>
cd canvia-restassured-bdd
code .
```

En la terminal de VS Code (`Ctrl+ñ` o *Terminal → New Terminal*):

```powershell
mvn test
```

La primera vez descarga las librerías (1–3 minutos). Esperado:

```text
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

El reporte HTML queda en `target/cucumber-report.html`.

Ejecutar por etiqueta (en PowerShell, **entre comillas**):

```powershell
mvn test "-Dcucumber.filter.tags=@smoke"
```

---

## Si algo falla

| Síntoma | Causa | Solución |
|---|---|---|
| `'mvn' no se reconoce...` | Path sin `%MAVEN_HOME%\bin` o terminal vieja | Revisa el Paso 2 y abre otra terminal |
| `invalid target release: 17` | Maven usa Java 8 | `JAVA_HOME` debe apuntar al JDK 17 (Paso 1) |
| `Connect timed out` descargando librerías | Proxy corporativo | `%USERPROFILE%\.m2\settings.xml` con el bloque `<proxies>` (ver manual PDF) |
| `Unknown lifecycle phase ".filter.tags=..."` | Falta comillas en PowerShell | `mvn test "-Dcucumber.filter.tags=@smoke"` |
| `Tests run: 0` | El runner no encontró los features | No muevas `src/test/resources/features` ni el runner |

¿Nada de esto funciona y tienes Docker? Usa el [entorno listo en Docker](02-entorno-docker-alumnos.md).

---

[Índice de documentación](README.md) · Siguiente: [Entorno listo en Docker](02-entorno-docker-alumnos.md)
