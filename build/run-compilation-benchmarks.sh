#!/bin/bash

set -eu

java -jar statix.benchmark.query.compilation-1.0.0-SNAPSHOT-jar-with-dependencies.jar ../sources/java-front/lang.java.statics
