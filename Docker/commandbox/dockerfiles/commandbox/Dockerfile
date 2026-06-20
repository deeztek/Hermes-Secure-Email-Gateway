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
    openjdk-11-jre \
    openjdk-11-jre-headless \
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

#Entrypoint
COPY entrypoints/commandbox/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]

