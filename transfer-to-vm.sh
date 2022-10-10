#!/bin/bash

set -eu
ZIP="./artifact.zip"

if [ -f $ZIP]; then
  rm $ZIP
fi

zip -r  $ZIP sources -x sources/**/.git/**\*
zip -ur $ZIP build
zip -ur $ZIP .m2/settings.xml
zip -ur $ZIP results
zip -ur $ZIP Rscripts
zip -ur $ZIP util.sh
zip -ur $ZIP install-deps.sh
zip -ur $ZIP install-r-deps.R
zip -ur $ZIP build-sources.sh
zip -ur $ZIP clean-sources.sh
zip -ur $ZIP LICENSE

scp -i "~/.ssh/id_ed25519" -P 5555 $ZIP "artifact@localhost:/home/artifact/Desktop/artifact/artifact.zip"

rm $ZIP
