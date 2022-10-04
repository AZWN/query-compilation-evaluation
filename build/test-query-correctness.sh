#!/bin/bash

set -eu

now=$(date +%Y%m%dT%H%M%S)
java -cp statix.benchmark.builder-0.0.1-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.builder.QueryExtractor false commons-csv commons-io commons-lang3 | tee test-query-correctness-$now.log
