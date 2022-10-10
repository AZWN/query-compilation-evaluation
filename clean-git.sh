#!/bin/bash

function clean_repo() {
  local dir=$1
  pushd $dir
  git clean -fxd
  popd
}

clean_repo sources/nabl
clean_repo sources/statix-benchmark
clean_repo sources/java-evaluation
clean_repo sources/java-front
clean_repo sources/compilation-examples
