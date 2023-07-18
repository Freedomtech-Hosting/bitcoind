#!/bin/sh

set -e

ep /etc/bitcoin.conf

exec bitcoind -conf=/etc/bitcoin.conf