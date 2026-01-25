FROM python:3.9-slim
MAINTAINER Deeztek <support@deeztek.com>
EXPOSE 9000

# Install gcc libldap2-dev libsasl2-dev
RUN apt-get update && \
    apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y gcc \
    libldap2-dev \
    libsasl2-dev

WORKDIR /app

COPY build/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY build/app.py ./

#ENTRYPOINT ["python", "app.py"]
CMD ["gunicorn", "-b", "0.0.0.0:9000", "app:app"]

