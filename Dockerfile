FROM openjdk:8
MAINTAINER Ibere Luiz Di Tizio Junior <ibere.tizio@gmail.com>

ARG VERSION_DIR=3.6
ARG VERSION_SERVER=3.6.252

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 apt-transport-https ca-certificates procps curl vim netcat locales libssl1.1 libzmq5 && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && dpkg-reconfigure --frontend noninteractive locales && \
    apt-get -qq clean

#RUN curl -sL http://packages.netxms.org/netxms.gpg | apt-key add - && \
#    echo "deb http://packages.netxms.org/debian/ buster main" > /etc/apt/sources.list.d/netxms.list && \
#    apt-get update && apt-get -y install libssl1.1 libzmq5 &&  \
RUN curl -O https://www.netxms.org/download/releases/${VERSION_DIR}/netxms-reporting-server-${VERSION_SERVER}.zip

RUN mkdir -p /opt/nxreporting/conf

WORKDIR /opt/nxreporting
RUN unzip /netxms-reporting-server-${VERSION_SERVER}.zip

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US \
    LC_ALL=en_US.UTF-8 \
    UNLOCK_ON_STARTUP=1 \
    UPGRADE_ON_STARTUP=1 \
    DEBUG_LEVEL=7

VOLUME /data

EXPOSE 4701 4703
EXPOSE 514/udp

COPY . /
COPY nxreporting.* logback.xml /opt/nxreporting/conf/

RUN  chmod 755 /docker-entrypoint.sh 

CMD ["/docker-entrypoint.sh"]

