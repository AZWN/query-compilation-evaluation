#!/bin/bash

set -eu

# Generic function to checkout a repository sparsely
function sparse_checkout() {
  local dir=$1       # local directory to checkout in
  local repo=$2      # URL to repository to checkout
  local ref=$3       # git ref to checkout
  local init_cmd=$4  # command to initialize repository (e.g., `mvn install`)
  shift 4
  local dirs="$@"    # directories to include in sparse checkout

  echo "[debug] sparse_checkout '$dir' '$repo' '$ref' '$init_cmd' $dirs"

  if [ ! -d "./$dir" ]; then
    mkdir "$dir"
    cd "$dir"
    git init
    git remote add -f origin $repo
    git config core.sparseCheckout true
  else
    cd $dir
  fi
  git pull origin $ref
  git sparse-checkout set $dirs
  git sparse-checkout reapply
  eval "$init_cmd"
  cd ..
}

# Clone solver
sparse_checkout "nabl" \
  "git@github.com:metaborg/nabl" \
  'develop/tracing' \
  'cd scopegraph && mvn install -DskipTests=true && cd ..' \
  '/scopegraph'

# Clone benchmark tool
sparse_checkout "statix-benchmark" \
  "git@github.com:metaborg/statix-benchmark.git" \
  "master" \
  "" \
  '/statix.benchmark' '/statix.benchmark.builder'

# Clone Java Spec & Evaluation projects
sparse_checkout "java-front" \
  "git@github.com:metaborg/java-front.git" \
  "master" \
  "cd lang.java && mvn install && cd ../lang.java.statics && mvn install && cd .." \
  '/lang.java' '/lang.java.statics'

if [ ! -d "./java-evaluation" ]; then
  git clone git@github.com:MetaBorgCube/java-evaluation.git
fi
