FROM ubuntu:24.04
LABEL maintainer="Deeztek <support@deeztek.com>"

EXPOSE 80 443

# Install systemd
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y systemd \
    init

#Entrypoint
COPY entrypoints/ubuntu_2404_systemd/entrypoint.sh /
RUN chmod +x /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["/entrypoint.sh"]
