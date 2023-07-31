#!/bin/sh

set -e

if [ ! -d "/data/.bitcoin/signet" ]; then
  echo "Downloading mutiny signet snapshot"
  mkdir -p /data/.bitcoin/signet
  wget -q https://fedi-public-snapshots.s3.amazonaws.com/bitcoind-mutinynet-signet.tar -O - | tar -C /data/.bitcoin/signet -xvf -
fi

ep /etc/bitcoin.conf

RPCAUTH=$(./rpcauth.py $BITCOIND_USER $BITCOIND_PASSWORD | head -2 | tail -1 | sed -e "s/^rpcauth=//")

exec bitcoind -conf=/etc/bitcoin.conf -rpcauth=$RPCAUTH