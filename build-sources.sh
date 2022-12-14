#!/bin/bash

set -eu

source util.sh

if [ ! -d "build" ]; then
  mkdir build
fi


mvn_install "sources/nabl/scopegraph"
mvn_install "sources/nabl/p_raffrayi"
mvn_install "sources/nabl/statix.solver"

mvn_install "sources/nabl/statix.lang"

mvn_install "sources/java-front/lang.java"

mvn_install_standalone "sources/statix-benchmark/statix.benchmark" "target/statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar"
mvn_install_standalone "sources/statix-benchmark/statix.benchmark.builder" "target/statix.benchmark.builder-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
mvn_install_standalone "sources/statix-benchmark/statix.benchmark.query.compilation" "target/statix.benchmark.query.compilation-1.0.0-SNAPSHOT-jar-with-dependencies.jar"

mvn_install "sources/compilation-examples/pcf"
mvn_install "sources/compilation-examples/lm"
