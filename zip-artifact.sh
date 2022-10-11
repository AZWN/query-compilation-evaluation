#!/bin/bash

set -eu
ZIP="./query-compilation-artifact.zip"

if [ -f "$ZIP" ]; then
  rm $ZIP
fi

zip -r  $ZIP sources -x sources/**/.git/**\*
zip -ur $ZIP build
zip -ur $ZIP results
zip -ur $ZIP Rscripts
zip -ur $ZIP util.sh
zip -ur $ZIP build-sources.sh
zip -ur $ZIP clean-sources.sh
zip -ur $ZIP .m2
zip -ur $ZIP vm
zip -ur $ZIP LICENSE
zip -ur $ZIP README.txt

du -h $ZIP
