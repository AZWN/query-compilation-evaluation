#!/bin/bash

set -eu

java -cp statix.benchmark.builder-0.0.1-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.builder.QueryExtractor false commons-csv commons-io commons-lang3
