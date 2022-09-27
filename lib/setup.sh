#!/bin/bash

# Make sure we have a 'third-party' folder.
mkdir -p third-party

# Download and extract rubberband
export RUBBERBAND_VERSION="3.0.0"
if [ ! -d "third-party/rubberband" ]; then
  echo "(0/4) Preparing build by fetching rubberband"
  curl -o third-party/rubberband.tar.bz2 https://breakfastquay.com/files/releases/rubberband-${RUBBERBAND_VERSION}.tar.bz2
  tar xmf third-party/rubberband.tar.bz2 -C third-party
  mv -v third-party/rubberband-${RUBBERBAND_VERSION} third-party/rubberband
  rm third-party/rubberband.tar.bz2
fi