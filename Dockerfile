# shadowsocks-libev with kcp

FROM alpine:latest

ENV SS_VER 2.5.6
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER

ENV KCP_VER 20161118
ENV KCP_URL https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN apk add --no-cache --virtual .build-deps \
      autoconf build-base curl libtool linux-headers openssl-dev pcre-dev xmlto asciidoc  \
    && apk add --no-cache --virtual .runtime-deps \
      pcre \
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR && ./configure && make install && cd .. && rm -rf $SS_DIR \
    && mkdir -p /opt/kcptun && cd /opt/kcptun && curl -sSL $KCP_URL | tar xz \
    && apk del .build-deps

ENV SS_PORT       10800
ENV SS_LOCAL_PORT 1080
ENV SS_PASSWORD   123456
ENV SS_METHOD     chacha20
ENV SS_TIMEOUT    600
ENV SS_SERVER     0.0.0.0

ENV KCP_PORT        9000
ENV KCP_MODE        fast
ENV KCP_MTU         1400
ENV KCP_SNDWND      1024
ENV KCP_RCVWND      1024
ENV KCP_DATASHARD   10
ENV KCP_PARITYSHARD 0

EXPOSE $SS_PORT/tcp $SS_PORT/udp $KCP_PORT/udp

COPY entrypoint /bin/entrypoint
RUN chmod +x /bin/entrypoint
ENTRYPOINT ["entrypoint"]
