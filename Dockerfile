# shadowsocks-libev with kcp

FROM alpine:latest

ENV SS_VER 3.0.2
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER

ENV KCP_VER 20170217
ENV KCP_URL https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN apk add --no-cache --virtual .build-deps \
      autoconf build-base curl libtool linux-headers xmlto asciidoc \
      libev-dev libsodium-dev openssl-dev pcre-dev mbedtls-dev udns-dev \
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR && ./configure && make install && cd .. && rm -rf $SS_DIR \
    && mkdir -p /opt/kcptun && cd /opt/kcptun && curl -sSL $KCP_URL | tar xz \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/local/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .run-deps $runDeps privoxy \
    && apk del .build-deps

# set to an non-zero value to enable privoxy http proxy.
ENV PORT          0

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
