#!/bin/bash

set -eu

source util.sh

Rscript -e 'install.packages(c("tidyverse", "knitr", "whereami", "forcats"))'

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

for dep in ${SPOOFAX_DEPS[@]}; do
  install_plugin_dep "org.metaborg:$dep:${SPOOFAX_VERSION}:spoofax-language"
done
for dep in ${JAVA_DEPS[@]}; do
  install_plugin_dep "org.metaborg:$dep:${SPOOFAX_JAVA_VERSION}:spoofax-language"
done
