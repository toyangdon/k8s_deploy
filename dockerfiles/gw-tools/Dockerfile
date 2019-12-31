FROM golang:1.12  as builder

RUN git clone -b v1.4.1 https://github.com/cloudflare/cfssl.git && \
    cd cfssl && \
    make && \ 
    cp bin/* /usr/bin

WORKDIR /workdir