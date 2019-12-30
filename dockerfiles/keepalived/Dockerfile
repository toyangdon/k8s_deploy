FROM alpine:3.11.2
MAINTAINER Yannic <yangdong@chalco-steering.com>

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add --update tzdata

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai">/etc/timezone


ENV KEEPALIVED_VERSION 2.0.19-r0
RUN apk add keepalived=${KEEPALIVED_VERSION}

ENTRYPOINT /usr/sbin/keepalived --dont-fork --dump-conf --log-console --log-detail --log-facility 7 --vrrp -f /etc/keepalived/keepalived.conf