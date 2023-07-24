#!/bin/sh

set -e

ep /etc/bitcoin.conf

RPCAUTH=$(./rpcauth.py $BITCOIND_USER $BITCOIND_PASSWORD | head -2 | tail -1 | sed -e "s/^rpcauth=//")

exec bitcoind -conf=/etc/bitcoin.conf -rpcauth=$RPCAUTH