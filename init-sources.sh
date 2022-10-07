#!/bin/bash

set -eu

source util.sh

if [ ! -d "sources" ]; then
  mkdir sources
fi

cd sources

# Clone solver
sparse_checkout "nabl" \
  "git@github.com:metaborg/nabl" \
  'develop/tracing' \
  '/scopegraph' '/p_raffrayi' '/statix.solver' '/statix.lang'

# Clone benchmark tool
sparse_checkout "statix-benchmark" \
  "git@github.com:metaborg/statix-benchmark.git" \
  "query-compilation-benchmark" \
  '/statix.benchmark' '/statix.benchmark.builder' '/statix.benchmark.query.compilation'

# Clone Java Spec & Evaluation projects
sparse_checkout "java-front" \
  "git@github.com:metaborg/java-front.git" \
  "master" \
  '/lang.java' '/lang.java.statics'

clone_or_update git@github.com:MetaBorgCube/java-evaluation.git "./java-evaluation"

clone_or_update https://github.com/AZWN/artifact-vm-builder "./artifact-vm-builder"

cd ..
