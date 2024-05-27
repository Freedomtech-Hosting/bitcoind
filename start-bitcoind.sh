#!/bin/sh

set -e

ep /etc/bitcoin.conf
# our bitcoin.conf is outside of the persistent directory, to be able to easily update it with a redeployment
ln -sf /etc/bitcoin.conf /data/.bitcoin/bitcoin.conf

RPCAUTH=$(./rpcauth.py $BITCOIND_USER $BITCOIND_PASSWORD | head -2 | tail -1 | sed -e "s/^rpcauth=//")

exec bitcoind -conf=/etc/bitcoin.conf -rpcauth=$RPCAUTH