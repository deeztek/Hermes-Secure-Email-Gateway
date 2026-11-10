FROM ubuntu:24.04
LABEL maintainer="Deeztek <support@deeztek.com>"
EXPOSE 8888

#Set Docker CLI version from https://download.docker.com/linux/static/stable/x86_64/
#ENV DOCKERVERSION=docker-28.3.3

# Install postfix rsyslog opendkim dumb-init
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y curl \
    dos2unix \
    dnsutils \
    iputils-ping \
    rar \
    sendemail \
    libio-socket-inet6-perl \
    haveged \
    gnupg \
    dmidecode \
    openjdk-21-jre-headless \
    dumb-init

#Copy docker binary from docker:dind image on dockerhub
COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/

#Get Docker compose plugin (fetches latest if COMPOSE_VERSION not specified)
ARG COMPOSE_VERSION=""
RUN if [ -z "$COMPOSE_VERSION" ]; then \
        COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); \
    fi && \
    echo "Installing Docker Compose ${COMPOSE_VERSION}" && \
    curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

#download Ortussolutions sources GPG key
RUN curl -fsSl https://downloads.ortussolutions.com/debs/gpg | gpg --dearmor | tee /usr/share/keyrings/ortussolutions.gpg > /dev/null

#Copy Sources List
COPY build/commandbox.list /etc/apt/sources.list.d/commandbox.list

#Install Commandbox and dependencies
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y apt-transport-https \
    commandbox

#Run CommandBox once so its first-run setup (unpacking its own runtime into
#/root/.CommandBox) happens at build time, not on every new container's first
#start. /root/.CommandBox is not a volume, so the result ships in the image.
RUN box version

#Bake the CFML engine into CommandBox's artifacts cache (#402).
#With an exact version in server.json, CommandBox skips the ForgeBox lookup and
#deploys from this cache, so a host never downloads the engine at first start.
#The engine is fetched with curl: CommandBox 6.3.5's own downloader gets 403
#from downloads.ortussolutions.com (seen on DEV and on the build host, where
#curl gets the same file). The SHA-256 pins the exact file that was tested.
#LUCEE_VERSION MUST match "cfengine" (lucee@<version>) in
#config/hermes/var/www/html/server.json; tests/v261107 checks that they agree.
ARG LUCEE_VERSION=6.2.9+4
ARG LUCEE_ZIP_VERSION=6.2.9.4
ARG LUCEE_SHA256=a751602dc76d7ef975da5735d894ca3682c3e6b45a8a6080e4d1ada5cb533197
RUN mkdir -p "/root/.CommandBox/artifacts/lucee/${LUCEE_VERSION}" && \
    curl -fsSL -o "/root/.CommandBox/artifacts/lucee/${LUCEE_VERSION}/lucee.zip" \
        "https://downloads.ortussolutions.com/lucee/lucee/${LUCEE_ZIP_VERSION}/cf-engine-${LUCEE_ZIP_VERSION}.zip" && \
    echo "${LUCEE_SHA256}  /root/.CommandBox/artifacts/lucee/${LUCEE_VERSION}/lucee.zip" | sha256sum -c -

#JDBC driver bundle for the datasources (#402). Every Application.cfc pins
#com.mysql.jdbc 5.1.40, which Lucee 6.2 does not ship (it bundles Connector/J
#9.x as com.mysql.cj) and would otherwise fetch from update.lucee.org at first
#start. entrypoint.sh copies it into the server home before the server starts.
#Kept outside /opt/hermes, which is bind-mounted over at run time. The SHA-256
#matches the jar on Maven Central (its published SHA-1 also checked).
ARG MYSQL_JDBC_VERSION=5.1.40
ARG MYSQL_JDBC_SHA256=27a80bf2e36d9d08d1be93f70d3124633a6952fe3b95833306905dcba6bfe96d
RUN mkdir -p /opt/lucee-bundles && \
    curl -fsSL -o "/opt/lucee-bundles/com.mysql.jdbc-${MYSQL_JDBC_VERSION}.jar" \
        "https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}.jar" && \
    echo "${MYSQL_JDBC_SHA256}  /opt/lucee-bundles/com.mysql.jdbc-${MYSQL_JDBC_VERSION}.jar" | sha256sum -c -

#Entrypoint
COPY entrypoints/commandbox/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

