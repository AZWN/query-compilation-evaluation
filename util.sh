export SCRIPT_DIR=$(dirname $0 | xargs realpath)

export SPOOFAX_VERSION="2.6.0-SNAPSHOT"
export SPOOFAX_JAVA_VERSION="1.1.0-SNAPSHOT"

export SPOOFAX_DEPS=(org.metaborg.meta.lang.template org.metaborg.meta.lang.esv statix.lang sdf3.ext.statix meta.lib.spoofax statix.runtime)
export JAVA_DEPS=(lang.java)

_SPOOFAXPATH=""
for dep in ${SPOOFAX_DEPS[@]}; do
  _SPOOFAXPATH="$SCRIPT_DIR/.m2/repository/org/metaborg/$dep/$SPOOFAX_VERSION/$dep-$SPOOFAX_VERSION.spoofax-language:$_SPOOFAXPATH"
done
for dep in ${JAVA_DEPS[@]}; do
  _SPOOFAXPATH="$SCRIPT_DIR/.m2/repository/org/metaborg/$dep/$SPOOFAX_JAVA_VERSION/$dep-$SPOOFAX_JAVA_VERSION.spoofax-language:$_SPOOFAXPATH"
done
export SPOOFAXPATH=$_SPOOFAXPATH

function mvn_bare() {
  local repo=$SCRIPT_DIR/.m2/repository
  mvn -s $SCRIPT_DIR/.m2/settings.xml -Dmaven.repo.local=$repo $@
}

function mvn_local() {
  mvn_bare -o -DskipTests=true $@
}

# Download and install remote sources/artifacts
# Generic function to checkout a repository sparsely
function sparse_checkout() {
  local dir=$1       # local directory to checkout in
  local repo=$2      # URL to repository to checkout
  local ref=$3       # git ref to checkout
  shift 3
  local dirs="$@"    # directories to include in sparse checkout

  echo "[debug] sparse_checkout '$dir' '$repo' '$ref' $dirs"

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
  cd ..
}

function install_plugin_dep() {
  mvn_bare dependency:get -Dartifact=$1 -DgeneratePom=true
}

# Build and install local sources
function mvn_install() {
  pushd $1
  mvn_bare dependency:go-offline -DgeneratePom=true
  mvn_local install
  popd
}

function mvn_install_standalone() {
  pushd $1
  mvn_bare dependency:go-offline -DgeneratePom=true
  mvn_local verify install assembly:single
  popd
  cp $1/$2 build/
}
