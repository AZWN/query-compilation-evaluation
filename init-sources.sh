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
  '/scopegraph' '/p_raffrayi' 'statix.solver'

# Clone benchmark tool
sparse_checkout "statix-benchmark" \
  "git@github.com:metaborg/statix-benchmark.git" \
  "query-compilation-benchmark" \
  '/statix.benchmark' '/statix.benchmark.builder'

# Clone Java Spec & Evaluation projects
sparse_checkout "java-front" \
  "git@github.com:metaborg/java-front.git" \
  "master" \
  '/lang.java' '/lang.java.statics'

if [ ! -d "./java-evaluation" ]; then
  git clone git@github.com:MetaBorgCube/java-evaluation.git
fi

cd ..

# Install plugins
install_plugin_dep "org.codehaus.plexus:plexus-component-annotations:2.0.0:jar"
install_plugin_dep "org.apache.maven.shared:maven-common-artifact-filters:3.1.0:jar"
install_plugin_dep "org.apache.maven.shared:maven-artifact-transfer:0.9.0:jar"
install_plugin_dep "org.apache.maven.shared:maven-artifact-transfer:0.11.0:jar"
install_plugin_dep "org.codehaus.plexus:plexus-interpolation:1.25:jar"
install_plugin_dep "org.codehaus.plexus:plexus-io:3.2.0:jar"
install_plugin_dep "org.codehaus.plexus:plexus-compiler-eclipse:2.8.8:jar"
install_plugin_dep "org.codehaus.plexus:plexus-archiver:4.2.1:jar"
install_plugin_dep "org.apache.maven:maven-archiver:3.5.0:jar"
install_plugin_dep "org.eclipse.jdt:ecj:3.25.0:jar"

install_plugin_dep "org.apache.maven:maven-profile:2.0.6:jar"
install_plugin_dep "org.apache.maven:maven-plugin-registry:2.0.6:jar"
install_plugin_dep "org.apache.maven:maven-plugin-parameter-documenter:2.0.6:jar"
install_plugin_dep "org.apache.maven.reporting:maven-reporting-api:2.0.6:jar"
install_plugin_dep "org.apache.maven.doxia:doxia-sink-api:1.0-alpha-7:jar"
install_plugin_dep "org.apache.maven:maven-repository-metadata:2.0.6:jar"
install_plugin_dep "org.apache.maven:maven-error-diagnostics:2.0.6:jar"
install_plugin_dep "org.apache.maven:maven-plugin-descriptor:2.0.6:jar"
install_plugin_dep "org.apache.maven.shared:maven-filtering:1.1:jar"
install_plugin_dep "org.apache.maven.reporting:maven-reporting-api:2.0.9:jar"
install_plugin_dep "org.apache.maven.surefire:maven-surefire-common:2.12.4:jar"
