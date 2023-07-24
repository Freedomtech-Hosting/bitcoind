ARG BITCOIND_IMAGE=lncm/bitcoind:v25.0@sha256:fad11d4874f1c2dc4373f6fea913bf95e0f0491f377b9a0930f488565e6266f0
FROM uselagoon/commons as commons
FROM ${BITCOIND_IMAGE} as bitcoind-base

COPY --from=commons /bin/fix-permissions /bin/ep /bin/

COPY bitcoin.conf /etc/bitcoin.conf
COPY start-bitcoind.sh /usr/bin/start-bitcoind.sh

# lncm/bitcoind comes with a bitcoind user generated, unfortunately in kubernetes we can't use that one as we have forced
# rootless, so we switch to the user root to make fix-permission work.
# the actual container will then be started with an random user id but known group=root
USER root
RUN fix-permissions /etc/bitcoin.conf

# needed for rpcauth.py to work
COPY rpcauth.py rpcauth.py
RUN apk add --no-cache python3

ENV BITCOIND_USER=freedomtech \
    BITCOIND_PASSWORD=freedomtech

# bitcoind has an entrypoint which we don't need, overwrite it
ENTRYPOINT [ "" ]

CMD [ "/usr/bin/start-bitcoind.sh" ]