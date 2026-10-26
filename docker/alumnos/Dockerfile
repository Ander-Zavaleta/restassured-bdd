# Entorno listo para el curso: JDK 17 + Maven 3.9 + VS Code en el navegador (code-server).
FROM maven:3.9-eclipse-temurin-17

ARG CODE_SERVER_VERSION=4.96.4

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh \
    | sh -s -- --method=standalone --prefix=/usr/local --version=${CODE_SERVER_VERSION}

# Mismas extensiones que pide el manual de instalación.
RUN for ext in vscjava.vscode-java-pack CucumberOpen.cucumber-official; do \
      code-server --install-extension "$ext" || echo "AVISO: no se pudo instalar $ext"; \
    done

# Precarga las librerías del pom.xml para que el primer `mvn test` no descargue todo.
COPY pom.xml /tmp/precarga/pom.xml
RUN mvn -B -q -f /tmp/precarga/pom.xml dependency:go-offline || true \
 && rm -rf /tmp/precarga

COPY docker/alumnos/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
