#!/bin/bash
#
# Install prerequisite packages for SonoBus build on Debian based distros

GITREPO="https://github.com/essej/sonobus.git"

PREREQS="libjack-jackd2-dev \
    libopus0 \
    libopus-dev \
    opus-tools \
    libasound2-dev \
    libx11-dev \
    libxext-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxcursor-dev \
    cmake
    "
FREETYPES=$(apt-cache pkgnames libfreetype)
if [[ $FREETYPES == *"libfreetype6-dev"* ]]; then
      PREREQS+="libfreetype6-dev "
elif [[ $FREETYPES == *"libfreetype-dev"* ]]; then
      PREREQS+="libfreetype-dev "
else
    echo "Couldn't find libfreetype dev package"
    exit 1
fi
if [[ $(apt-cache pkgnames libcurl4-openssl-dev) == *"libcurl4-openssl-dev"* ]]; then
      PREREQS+="libcurl4-openssl-dev"
elif [[ $(apt-cache pkgnames libcurl4-gnutls-dev) == *"libcurl4-gnutls-dev"* ]]; then
      PREREQS+="libcurl4-gnutls-dev"
else
    echo "Couldn't find libcurl ssl/tls dev package"
    exit 1
fi




echo ""
echo "Installing prerequisites - " $(date)
echo ""

sudo apt update

sudo apt -y install git build-essential $PREREQS

function ver { printf "%03d%03d%03d%03d" $(echo "$1" | tr '.' ' '); }

cmakever=$(cmake --version | head -1 | cut -d" " -f3)

if [ $(ver $cmakever) -lt $(ver 3.16) ] ; then
  echo "Your CMake is too old! You need version 3.16 or higher. Try to get a newer version, or compile CMake from source."
  exit 1
fi
