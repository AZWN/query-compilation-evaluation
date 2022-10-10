#!/bin/bash

set -eu

source ../util.sh

now=$(date +%Y%m%dT%H%M%S)
java -jar statix.benchmark.query.compilation-1.0.0-SNAPSHOT-jar-with-dependencies.jar ../sources/java-front/lang.java.statics | tee compilation-benchmark-$now.csv
