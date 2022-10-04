#!/bin/bash

set -eu

now=$(date +%Y%m%dT%H%M%S)
java -cp statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar \
  -Djmh.ignoreLock=true \
  org.openjdk.jmh.Main \
  -jvmArgs -Xmx6G -wi 5 -i 20 -rff java-benchmark-$now.csv \
  mb.statix.benchmark.JavaBenchmark \
  -p parallelism=4 \
  -p mode=CONCURRENT \
  -p project=commons-csv \
  -p flags=0,2
