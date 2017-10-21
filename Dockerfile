FROM ubuntu:xenial
MAINTAINER oliver@weichhold.com

# diagnostic stuff
RUN apt-get -y update && apt-get install -y --no-install-recommends curl

RUN apt-get update -y && apt-get -y install apt-transport-https wget && wget -qO - https://apt.z.cash/zcash.asc | apt-key add - && \
    echo "deb [arch=amd64] https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list && \
    apt-get -y update && apt-get -y --no-install-recommends install zcash && zcash-fetch-params && \
    rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* /var/cache/man/* /tmp/* /var/lib/apt/lists/*

ADD rootfs /
RUN chmod +x /health-check.sh

RUN touch /data/zcash.conf

EXPOSE 8232 8233
WORKDIR /tmp
ENTRYPOINT zcashd -server -testnet -datadir=/data -rpcuser=user -rpcpassword=pass -port=8233 -rpcport=8232 -rpcbind=0.0.0.0 -rpcallowip=::/0 -addnode=betatestnet.z.cash
