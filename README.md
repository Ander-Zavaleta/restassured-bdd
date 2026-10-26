# Canvia · Automatización de APIs con REST Assured + Cucumber

Proyecto base del curso de QA Automation (parte 1): pruebas de API en **Java 17** con **REST Assured**,
escenarios en **Gherkin (español)** con **Cucumber** y ejecución con **Maven**.
API bajo prueba: [Restful Booker](https://restful-booker.herokuapp.com).

## Empieza aquí

| Si... | Sigue |
|---|---|
| Vas a configurar tu PC | [Instalación en Windows, paso a paso](docs/01-instalacion-windows-paso-a-paso.md) |
| No pudiste instalar Java o Maven | Doble clic en **`iniciar-entorno.bat`** → [Entorno listo en Docker](docs/02-entorno-docker-alumnos.md) |
| Es tu primera vez con Git | [Git y GitHub](docs/04-git-y-github.md) |
| Eres el instructor | [Windows en Docker para la demo](docs/03-windows-en-docker-instructor.md) |

Toda la documentación: [docs/](docs/README.md).

## Ejecutar

```powershell
mvn test                                     # todos los escenarios
mvn test "-Dcucumber.filter.tags=@smoke"     # solo @smoke (en PowerShell, con comillas)
mvn test "-DbaseUrl=http://localhost:3001"   # otra URL de la API
```

Resultado esperado: `Tests run: 4, Failures: 0, Errors: 0, Skipped: 0`.
Reporte: `target/cucumber-report.html`.

## Estructura

```text
├── pom.xml                                 dependencias y versiones
├── src/test/java/com/canvia/qa/
│   ├── runners/RunCucumberTest.java        punto de entrada de JUnit
│   ├── steps/ReservaSteps.java             código de cada paso Gherkin
│   └── support/                            Hooks (URL base) y Contexto compartido
├── src/test/resources/features/            escenarios .feature en español
├── docker-compose.yml + iniciar-entorno.*  entorno listo para alumnos
├── docker/windows/                         Windows 11 en Docker para la demo
└── docs/                                   guías y PDF del curso
```

## Versiones

| Herramienta | Versión |
|---|---|
| Java (Temurin) | 17 |
| Maven | 3.9 |
| REST Assured | 6.3.0 |
| Cucumber-JVM | 7.34.9 |
| JUnit Platform | 6.1.3 |

## Cómo se trabaja

1. `develop` es la rama de trabajo; `main` guarda las versiones estables.
2. Cada ejercicio va en su rama `feature/<ejercicio>-<tu-nombre>`.
3. Se entrega con un Pull Request a `develop`; la CI corre `mvn test` y debe quedar en verde.

Detalle en [Git y GitHub](docs/04-git-y-github.md#6-el-flujo-de-cada-ejercicio).
