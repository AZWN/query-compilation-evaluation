#!/bin/bash

set -eu

java -cp statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.resolution.ResolutionBenchmarkRunner --project commons-csv
