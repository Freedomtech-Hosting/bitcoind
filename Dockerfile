FROM uselagoon/commons as commons
FROM debian:buster-slim as builder

ARG BITCOIN_VERSION="d8434da3c14e"
ARG TRIPLET=${TRIPLET:-"x86_64-linux-gnu"}

RUN apt-get update && \
    apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu wget libc6 procps python3
WORKDIR /tmp

# install bitcoin binaries
RUN BITCOIN_URL="https://github.com/benthecarman/bitcoin/releases/download/custom-signet-blocktime/bitcoin-${BITCOIN_VERSION}-${TRIPLET}.tar.gz" && \
    BITCOIN_FILE="bitcoin-${BITCOIN_VERSION}-${TRIPLET}.tar.gz" && \
    wget -qO "${BITCOIN_FILE}" "${BITCOIN_URL}" && \
    mkdir -p bin && \
    tar -xzvf "${BITCOIN_FILE}" -C /tmp/bin --strip-components=2 "bitcoin-${BITCOIN_VERSION}/bin/bitcoin-cli" "bitcoin-${BITCOIN_VERSION}/bin/bitcoind" "bitcoin-${BITCOIN_VERSION}/bin/bitcoin-wallet" "bitcoin-${BITCOIN_VERSION}/bin/bitcoin-util"

FROM debian:buster-slim as custom-signet-bitcoin

COPY rpcauth.py rpcauth.py
RUN apt-get update && \
    apt-get install -qq --no-install-recommends ca-certificates python3 wget tar

ENV BITCOIND_USER=freedomtech \
    BITCOIND_PASSWORD=freedomtech \
    BITCOIND_CHAIN=signet

COPY --from=builder "/tmp/bin" /usr/local/bin

COPY --from=commons /bin/fix-permissions /bin/ep /bin/

COPY bitcoin.conf /etc/bitcoin.conf
COPY start-bitcoind.sh /usr/bin/start-bitcoind.sh

CMD [ "/usr/bin/start-bitcoind.sh" ]


ENV BITCOIND_SIGNETADDNODE=mutinynet-upstream.dev.fedibtc.com:38333 \
    BITCOIND_SIGNETCHALLENGE=512102f7561d208dd9ae99bf497273e16f389bdbd6c4742ddb8e6b216e64fa2928ad8f51ae \
    BITCOIND_DNSSEED=0 \
    BITCOIND_SIGNETBLOCKTIME=30