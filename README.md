#### Quick Start
To start shadowsocks, run `$ docker run -it --rm luxrck/shadowsocks-kcp`, and use `--crypt none --mode fast --mtu 1400 --sndwnd 1024 --rcvwnd 1024 --parityshard 0 --nocomp` as the command line arguments of your kcptun client.

#### Usage
`$ docker run -it --rm luxrck/shadowsocks-kcp --help`

	shadowsocks-kcp uses server mode with kcptun enabled by default

	Options:
		-c|--client    start in client mode
		--no-kcp       disable kcptun

#### Eironments
Change these environments list below to apply new settings.

##### shadowsocks-libev
Shadowsocks with tcp fast-open enabled.

Env.         | Val.
-------------|--------
SS_PORT      |10800
SS_LOCAL_PORT|1080
SS_PASSWORD  |123456
SS_METHOD    |chacha20
SS_TIMEOUT   |600
SS_SERVER    |127.0.0.1

##### kcptun
Make sure to change client's command line arguments if you change these.

Env.           | Val.
---------------|--------
KCP_PORT       | 9000
KCP_MODE       | fast
KCP_MTU        | 1400
KCP_SNDWND     | 1024
KCP_RCVWND     | 1024
KCP_DATASHARD  | 10
KCP_PARITYSHARD| 0
