FROM alpine:3

LABEL org.opencontainers.image.authors="Mikael Göransson <github@mgor.se>"

RUN addgroup -g 1000 homebridge && \
    adduser -Ss /bin/false -u 1000 -G homebridge -h /opt/homebridge homebridge

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    g++ \
    make

RUN apk add --no-cache \
    nodejs \
    npm

RUN npm install -g --unsafe-perm \
    homebridge \
    homebridge-telldus

RUN apk del .build-deps

RUN mkdir /opt/homebridge/data && \
    chown homebridge:homebridge /opt/homebridge/data

VOLUME /opt/homebridge/data

USER homebridge

EXPOSE 51826
EXPOSE 5353/udp

CMD ["/usr/bin/homebridge", "-U", "/opt/homebridge/data"]

