FROM haproxy:2.1.2
MAINTAINER Yannic <yangdong@chalco-steering.com>

ENV KEEPALIVED_VERSION 1.3.9-r2
RUN apk update && \
    apk add keepalived=${KEEPALIVED_VERSION}
COPY docker-entrypoint-override.sh /

RUN chmod +x /docker-entrypoint-override.sh

ENTRYPOINT ["/docker-entrypoint-override.sh"]