#!/bin/bash
#set -eu -o pipefail

# install build deps
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y build-essential make unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner software-properties-common maven
sudo apt install golang-go

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

mkdir $HOME/lib
cd $HOME/lib
git clone https://github.com/jpmorganchase/quorum.git
cd $HOME/lib/quorum/
git checkout tags/v2.2.3
make all

mkdir $HOME/bin
cp $HOME/lib/quorum/build/bin/geth $HOME/bin/
cp $HOME/lib/quorum/build/bin/bootnode $HOME/bin/

cd $HOME/lib
wget -q https://oss.sonatype.org/content/groups/public/com/jpmorgan/quorum/tessera-app/0.9.2/tessera-app-0.9.2-app.jar
cp $HOME/lib/tessera-app-0.9.2-app.jar $HOME/bin/tessera.jar


