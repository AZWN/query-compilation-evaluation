# For documentation purposes only.
# Uses properietary software (YourKit Profiler java agent).

set -eu

java -agentpath:/Applications/Development/YourKit-Java-Profiler-2021.3.app/Contents/Resources/bin/mac/libyjpagent.dylib -cp statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.JavaRun -p 4 -m concurrent -f 2 --profile commons-io
java -agentpath:/Applications/Development/YourKit-Java-Profiler-2021.3.app/Contents/Resources/bin/mac/libyjpagent.dylib -cp statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.JavaRun -p 4 -m concurrent -f 0 --profile commons-io
