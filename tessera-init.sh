#!/usr/bin/env bash

echo "[*] Initialising Tessera configuration"

currentDir=$(pwd)
    DDIR="qdata/c1"
    mkdir -p ${DDIR}
    mkdir -p qdata/logs
    rm -f "${DDIR}/tm.ipc"

java -jar $HOME/bin/tessera.jar -keygen -filename  "tm"
#tessera -keygen -filename "${DDIR}/tm"
mv "tm.pub" "${DDIR}/tm.pub"
mv "tm.key" "${DDIR}/tm.key"

    #change tls to "strict" to enable it (don't forget to also change http -> https)
    cat <<EOF > ${DDIR}/tessera-config.json
{
  "useWhiteList": false,
  "jdbc": {
    "username": "sa",
    "password": "",
    "url": "jdbc:h2:./${DDIR}/db;MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
    "autoCreateTables": true
  },
  "serverConfigs": [
    {
      "app": "ThirdParty",
      "enabled": true,
      "serverAddress": "http://localhost:9081",
      "communicationType": "REST"
    },
    {
      "app": "Q2T",
      "enabled": true,
      "serverAddress": "unix:${DDIR}/tm.ipc",
      "communicationType": "REST"
    },
    {
      "app": "P2P",
      "enabled": true,
      "serverAddress": "http://localhost:9001",
      "sslConfig": {
        "tls": "OFF",
        "generateKeyStoreIfNotExisted": true,
        "serverKeyStore": "${DDIR}/server-keystore",
        "serverKeyStorePassword": "quorum",
        "serverTrustStore": "${DDIR}/server-truststore",
        "serverTrustStorePassword": "quorum",
        "serverTrustMode": "TOFU",
        "knownClientsFile": "${DDIR}/knownClients",
        "clientKeyStore": "${DDIR}/client-keystore",
        "clientKeyStorePassword": "quorum",
        "clientTrustStore": "${DDIR}/client-truststore",
        "clientTrustStorePassword": "quorum",
        "clientTrustMode": "TOFU",
        "knownServersFile": "${DDIR}/knownServers"
      },
      "communicationType": "REST"
    }
  ],
  "peer": [
    {
      "url": "http://localhost:9001"
    }
  ],
  "keys": {
    "passwords": [
      
    ],
    "keyData": [
      {
        "config": $(cat${
          DDIR
        }/tm.key),
        "publicKey": "$(cat ${DDIR}/tm.pub)"
      }
    ]
  },
  "alwaysSendTo": [
    
  ],
  "unixSocketFile": "${DDIR}/tm.ipc"
}
EOF