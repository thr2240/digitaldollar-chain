#!/bin/bash

VALIDATOR="validator1"
CHAINID="digitaldollar_1-1"
MONIKER="thomas"
MAINNODE_RPC="http://35.164.185.127:26657"
MAINNODE_ID="102187f7010eed21080c78b40967e122c235692d@35.164.185.127:26656"
KEYRING="test"

# install chain binary file
make install

# Set moniker and chain-id for chain (Moniker can be anything, chain-id must be same mainnode)
digitaldollard init $MONIKER --chain-id=$CHAINID

# Fetch genesis.json from genesis node
curl $MAINNODE_RPC/genesis? | jq ".result.genesis" > ~/.digitaldollard/config/genesis.json

digitaldollard validate-genesis

# set seed to main node's id
sed -i 's/seeds = ""/seeds = "'$MAINNODE_ID'"/g' ~/.digitaldollard/config/config.toml

# add account for validator in the node
digitaldollard keys add $VALIDATOR --keyring-backend $KEYRING

# run node
digitaldollard start --rpc.laddr tcp://0.0.0.0:26657 --gas-prices 0.00001akarma --gas-adjustment 1.3 --pruning=nothing