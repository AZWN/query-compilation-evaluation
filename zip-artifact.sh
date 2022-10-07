#!/bin/bash

set -eu
ZIP="./query-compilation-artifact.zip"

if [ -f $ZIP]; then
  rm $ZIP
fi

zip -r  $ZIP sources
zip -ur $ZIP build
zip -ur $ZIP results
zip -ur $ZIP Rscripts
zip -ur $ZIP util.sh
zip -ur $ZIP build-sources.sh
zip -ur $ZIP .m2
zip -ur $ZIP LICENSE
# TODO: include VM
# TODO: include readme
