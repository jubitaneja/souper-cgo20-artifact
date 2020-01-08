#!/bin/sh

echo "Install prerequisites ..."
sudo apt-get -yy install libgmp10 ca-certificates libc6-dev libgmp-dev cmake time patch ninja-build make autoconf automake libtool python subversion re2c git gcc g++ libredis-perl unzip wget redis-server
