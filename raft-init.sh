#!/bin/bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node"
mkdir -p qdata/dd1

#cp permissioned-nodes.json qdata/dd1/static-nodes.json
#cp permissioned-nodes.json qdata/dd1/

#initialize blockchain with genesis
geth --datadir qdata/dd1 init genesis.json
geth --datadir qdata/dd1 account new
read -p "Enter your password again (this is stored in your machine) : "
echo "$REPLY" > qdata/dd1/password

#generate a node key
bootnode -genkey qdata/dd1/geth/nodekey
cp qdata/dd1/geth/nodekey qdata/dd1/nodekey

#print enode id of the node
echo "enode hash : "
bootnode -nodekey qdata/dd1/geth/nodekey -writeaddress

#Initialise Tessera configuration
bash tessera-init.sh
