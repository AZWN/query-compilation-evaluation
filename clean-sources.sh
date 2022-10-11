#!/bin/bash

set -eu

source util.sh

function clean_java() {
  local dir=$1
  pushd $dir
  mvn_local clean
  if [ -d target ]; then
    rm -r target/
  fi
  popd
}

function clean_lang() {
  local dir=$1
  pushd $dir
  mvn_local clean
  if [ -d src-gen ]; then
    rm -r src-gen/
  fi
  if [ -d target ]; then
    rm -r target/
  fi
  popd
}

clean_java "sources/statix-benchmark/statix.benchmark"
clean_java "sources/statix-benchmark/statix.benchmark.builder"
clean_java "sources/statix-benchmark/statix.benchmark.query.compilation"

clean_lang "sources/compilation-examples/statix.example"
clean_lang "sources/compilation-examples/pcf"
clean_lang "sources/compilation-examples/pcf.example"
clean_lang "sources/compilation-examples/lm"
clean_lang "sources/compilation-examples/lm.example"
