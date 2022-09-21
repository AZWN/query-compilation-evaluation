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

  echo "[debug] sparse_checkout $dir $repo $ref $init_cmd $dirs"

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
  '558f63e825066263ff8600f0a0eb4f07bb556b00' \
  'cd scopegraph && mvn install && cd ..' \
  '/scopegraph'

# Clone benchmark tool
sparse_checkout "statix-benchmark" \
  "git@github.com:metaborg/statix-benchmark.git" \
  "master" \
  "" \
  '/statix.benchmark' '/statix.benchmark.builder'

# Clone Java Spec & Evaluation projects
