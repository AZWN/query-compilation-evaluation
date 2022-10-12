# Specializing Scope Graph Resolution Queries (Artifact)

This artifact contains the sources, tests, benchmarks, results and analysis scripts related to the paper 'Specializing Scope Graph Resolution Queries (2022)' by Aron Zwaan.
The algorithms, tests and benchmarks are implemented in Java, the results are included in CSV files, and the analysis scripts are written in R.
The artifact can be used on the users' host machine directly, or a pre-packaged virtual machine can be used.


## Artifact Overview

This artifact is structured as follows:
- the `sources` directory contains all sources of the algorithms, compilation schemes, tests and benchmarks
- the `build` directory contains jars and scripts to execute tests and benchmarks
- the `results` directory contains the result files used to generate the figures in the paper
- the `Rscripts` directory contains R scripts to analyze and plot the results
- the `vm` directory contains a QEMU/VirtualBox executable virtual machine. In the `/home/artifact/Desktop/artifact` directory, the same directories are included. In addition, it includes an Spoofax Eclipse instance, which can be used for exploring the algorithm. There are two users, `root` and `artifact`, which both have password `artifact`.

All required maven dependencies and plugins are included in the `.m2` directory.
Using `source util.sh` ensures maven functions independent from the main maven installation on the host system.


## Installation Guide

First ensure the following dependencies are installed
- Bash
- Java 8 (support guaranteed for 8; should work up to version 11)
- Maven (tested with 3.6.0; 3.6.1 and 3.6.2 are known to be incompatible)
- R base (tested with 4.2.1)
- QEMU (tested with 7.1.0) or VirtualBox (tested with 6.1.34)

Then unzip the archive.


## Kick the Tires Instructions

This section describes how the different tests and benchmarks can be tested.


### 0. Running the Artifact

There are three options to run the artifact:
1. Host machine: open a terminal at the location of the unzipped artifact.
2. QEMU: open a terminal in the `vm` directory, and run `./run`. In the guest machine, open a bash shell in `/home/artifact/Desktop/artifact`.
3. VirtualBox: Import the `vm/artifact-sle22.ovf` image in VirtualBox, start it, and open a bash shell in `/home/artifact/Desktop/artifact`.

> On the virtual machine, `Konsole` can be used as a pre-installed console. Be sure to call `$ bash`, to ensure you are in a bash shell.

> It is recommended to execute the benchmarks on the host machine, as virtualization may give different performance characteristics.


### 1. Building all sources

Using `./build-sources.sh`, all sources can be built. Not that this is not required for evaluating the following steps.
When this script complains about missing plugin dependencies, please use `./install-deps.sh` to install those, but report it as a deficiency in the artifact.

### 2. Executing the Unit Tests

Execute the following commands:
```
cd build
./test-query-correctness.sh
```
The output should show that, for three projects, a total of ~350k queries are tested for correctness.

The results should be comparable to `test-query-correctness-20221004T134202.log`, which supports the claims in section 6.1.


### 3. Executing the Compilation Benchmarks

Execute the following commands:
```
cd build
./run-compilation-benchmarks.sh > compilation-benchmark-results.csv
../Rscripts/plot-pipeline.R compilation-benchmark-results.csv
```
This script should print that approximately 4-5% of the time is spend on precompiling queries.

The results should be comparable to `./Rscripts/plot-pipeline.R ./results/compilation-benchmark-20221004T143716.csv`.

> When this fails with an error that `StatixLang` cannot be found, be sure that you are in a bash shell by executing the `bash` command.

### 4. Executing the Integration Benchmarks

Execute the following commands:
```
cd build
./run-integration-benchmarks.sh > integration-benchmark-results.csv
```

When the benchmark is finished, it reports a result file.
Analyze the result file using

```
../Rscripts/plot-integration.R <java-benchmark-XXX>.csv
```
This script should show that the speedup of using query compilation is 35-45%.

The results should be comparable to `./Rscripts/plot-integration.R ./results/java-benchmark-20221004T142804.csv`


### 5. Executing the Micro-Benchmarks

```
cd build
java -cp statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.resolution.ResolutionBenchmarkRunner --project commons-csv --limit 10
```

When the benchmark is finished, it reports a result file.
Analyze the result file using
```
../Rscripts/plot-micro-benchmarks.R <query-benchmark-XXX>.csv
```

The results should be comparable to `./Rscripts/plot-micro-benchmarks.R ./results/<TODO: copy result from benchmark server>`, which supports the claims in section 6.2.

> Warning: Just executing `./run-micro-benchmarks.sh` is possible, but expected to take more than a week to complete.
> Note that, therefore, the results can have a different distribution than the paper.


### 6. Analyzing the Profiling Snapshots

Execute the following command:
```
./Rscripts/plot-profile.R results/profile-interpreted.csv results/profile-compiled.csv
```

This scripts prints two tables.
The first table shows that, relative to the query method `Resolve` (`RelativeToQuery` column), checking a label order (`Label_LE`) takes 35% of the time, and deriving a regular expression derivative 12.5% (`RE_Derive`).
In the second table, the total type-checking time (`TypeCheck`) was reduced significantly, mainly due to reduced query resolution time.


### 7. Using Spoofax to Explore Query Compilation

When working in the virtual machine, open `spoofax/eclipse` as shown on the Desktop.

When working on the host machine, download Spoofax for your machine:
- MacOS: https://artifacts.metaborg.org/service/local/artifact/maven/redirect?r=releases&g=org.metaborg&a=org.metaborg.spoofax.eclipse.dist&c=macosx-x64-jre&p=tar.gz&v=2.5.17
- Windows (64 bit): https://artifacts.metaborg.org/service/local/artifact/maven/redirect?r=releases&g=org.metaborg&a=org.metaborg.spoofax.eclipse.dist&c=windows-x64-jre&p=zip&v=2.5.17
- Linux: https://artifacts.metaborg.org/service/local/artifact/maven/redirect?r=releases&g=org.metaborg&a=org.metaborg.spoofax.eclipse.dist&c=linux-x64-jre&p=tar.gz&v=2.5.17
Use https://www.spoofax.dev/howtos/installation/install-eclipse-bundle/ to troubleshoot installation issues.
Start Eclipse, and open the `File > Import > Maven > Existing Maven Projects` menu.
Select `<artifact directory>/sources/compilation-examples` as directory.
This should show 5 projects.
Select all of these, and click 'Import'.

Select `pcf` in the `Package Explorer` tab and use `Right Mouse > Build Project`. Use `Window > Show View > Console` to verify that the build succeeded.
Select `lm` in the `Package Explorer` tab and use `Right Mouse > Build Project`. Again, wait for the build to succeed.

Open `pcf.example/example-1-paper.pcf` in Eclipse.
- Ensure that there are no errors.
- Hover over a reference and verify there is a tooltip with its type.
- Use `Ctrl/Cmd Click` on a reference to jump to its corresponding declaration.
- Use the menu `Spoofax > Statix > Show Scopegraph` to generate the scope graph for this file.

Open `lm.example/example-2-paper.lm`.
- Ensure that there is an inline error on `x` on line 16.

Open `statix.example/src/datawf.stxtest`
- Use the menu `Spoofax > Evaluate > Evaluate Test`. A file with a test result opens. Assert the `errors` subsection is empty.
Open `statix.example/src/regex.stxtest`
- Use the menu `Spoofax > Evaluate > Evaluate Test`. A file with a test result opens. Assert the `errors` subsection is empty.
Open `statix.example/src/shadowing.stxtest`
- Use the menu `Spoofax > Evaluate > Evaluate Test`. A file with a test result opens. Assert the `errors` subsection is empty.


## Detailed Instructions

This section contains background information on all tools included in the artifact.


### 1. Unit Tests

The unit tests are included in the `build/statix.benchmark.builder-0.0.1-SNAPSHOT-jar-with-dependencies.jar`. They can be executed as
```
java -cp statix.benchmark.builder-0.0.1-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.builder.QueryExtractor true|false PROJECT...
```
The first parameter (`true|false`) indicates whether the results should be serialized, to be used for the micro benchmarks. This is discussed later.
The `PROJECT` parameter, which can be given multiple times, indicates the queries of which project are tested. Available options are `commons-csv|commons-io|commons-lang3`.
The sources for these projects are packages in the jar, but the original sources can be found in `sources/java-evaluation`.
Only the main sources (`sources/java-evaluation/<project>/src/main/java`) are included.

The source of the testing tool itself can be found at `sources/statix-benchmark/statix.benchmark.builder/src/main/java/mb/statix/benchmark/builder/QueryExtractor.java`.
The tool first executes the type-checker on the given project, using a tracer that collects all queries the type-checker performs.
For each of these queries, the traditional query resolution algorithm and the compiled query interpreter are executed, and the results are verified to be equal.


### 2. Compilation Pipeline Benchmark

We benchmark the overhead our additional query compilation step induces in the overall compilation pipeline.
The tool executing this benchmark is included in `sources/statix-benchmark/statix.benchmark.query.compilation/src/main/java/mb/statix/benchmark/query/compilation/BenchmarkPipeline.java`, and precompiled in `build/statix.benchmark.query.compilation-1.0.0-SNAPSHOT-jar-with-dependencies.jar PROJECT`.

The tool has a single argument (`PROJECT`), which is a path to a project for which the overhead should be benchmarked.
In addition, it relies on the `SPOOFAXPATH` environment variable, which should point to language archives (`*.spoofax-language` files) for each of the dependencies.
To reproduce the results in the paper, simply execute `./build/run-compilation-benchmarks.sh`.
This executes to benchmark on the `sources/java-front/lang.java.statics` project (which is the Statix specification for Java), using the correct dependencies.

To reproduce the results reported in the paper, just execute `./build/run-compilation-benchmarks.sh`.

Compilation benchmark results can be analyzed using `./Rscripts/plot-pipeline.R RESULT-CSV`, where `RESULT-CSV` is a path to a file generated by the pipeline benchmark tool.
This prints a table with a decomposition of the runtimes of the steps in the compilation pipeline.
The Statix pipeline is composed from the following 5 steps:
1. Parsing
2. Analysis (type-checking)
3. Normalization
4. Precompiling Queries (added as part of this paper)
5. Generation of intermediate representation

Worth mentioning here is that the `Analysis.Time` (type-checking time) column is not measured per file, but for all files together.
The reported value in the column is normalized for the relative file size, measured in AST node count.
The most important column is `Precompile.Rel`, which shows the relative increase of runtime due to precompilation.
It shows that the highest mentioned values is below 11%.

Finally, the tool mentions the relative time precompilation takes for the whole pipeline.
This should be between 4-5%.


### 3. Integration Benchmarks

We benchmarked the overall speedup of type-checkers using compiled queries.
The sources are included in `sources/statix-benchmark/statix.benchmark/src/main/java/mb/statix/benchmark/{Abstract,}JavaBenchmark.jav`, and the compiled version is included in `build/statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar`.
The tool is based on JMH, and can be configured using all options JMH supports.
By default, it uses the following parameters:
- `mode`: single-shot (execute the benchmark method a single time)
- `wi`: 5 (5 warmup iterations)
- `i`: 20 (20 measurement iterations)
- `-Xmx6G`: 6GB RAM
The following benchmark parameters (provided using the `-p name=value1,value2,...` option):
- `project`: the project to benchmark. Available options are `commons-csv,commons-io,commons-lang3`. By default, all three are selected
- `parallelism`: number of cores to use. Default set to `4`.
- `mode`: Mode in which to execute the solver. Present for historical reasons, should be set to `CONCURRENT`.
- `flags`: Flags to pass to the solver. Flag `2` disables compiled queries. Default set to `0,2`. Default must be retained to ensure `Rscripts/plot-integration.R` works appropriately.

To reproduce the results reported in the paper, use `./build/run-integration-benchmarks.sh`.

The results can be analyzed using `./Rscripts/plot-integration.R RESULT-CSV`, where `RESULT-CSV` is the result file of executing the integration benchmarks.
This prints a table with the absolute runtimes of the type-checker when using interpreted and compiled queries, and the Speedup in percentage.


### 4. Micro-Benchmarks

We benchmarked the speedup of each individual query that is executed when type-checking the commons-csv project.
The sources of this benchmark can be found in `sources/statix-benchmark/statix.benchmark/src/main/java/mb/statix/benchmark/resolution/ResolutionBenchmark.java`, which is compiled into `build/statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar`.
It can be executed as follows:
```
java -cp build/statix.benchmark-2.6.0-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.resolution.ResolutionBenchmarkRunner --project PROJECT --limit LIMIT
```
It receives two parameters:
- `PROJECT`: the project to benchmark queries from. Is used to identify a serialized scope graph and set of queries embedded in the jar. Can be given multiple times.
- `LIMIT`: The number of queries to benchmark. Is optional. When not given, all queries in the dataset are benchmarked.

To reproduce the results reported in the paper, use `./build/run-micro-benchmarks.sh`.
Note that this is expected to take 5 - 8 days to complete on a typical machine.

The results can be analyzed using `./Rscripts/plot-micro-benchmarks.R RESULT_CSV HIST.pdf`.
This prints a histogram table of _the logarithm_ of the speedups per individual query, and a summary table of the raw speedups.
In `HIST.pdf`, a histogram of `log(SpeedUp)` is printed.


_Recording._
In the jar, only a dataset for the CSV project is embedded.
This dataset is created with the testing tool discussed earlier.
It can be recreated with the following command:
```
source util.sh
cd sources/statix.benchmark/statix.benchmark.builder
mvn_bare clean verify assembly:single
java -cp target/statix.benchmark.builder-0.0.1-SNAPSHOT-jar-with-dependencies.jar mb.statix.benchmark.builder.QueryExtractor true PROJECT
cd ../../..
./build-sources.sh
```


### 5. Profiling

The profiling results reported in `results/profile-XXX.csv` are created using the YourKit 2021.3-b228 Java profiler in asynchronous sampling mode.
As it is properietary, it is not included in the artifact.
For reference, the source code used to obtain the profiling snapshots can be found in `sources/statix-benchmark/statix.benchmark/src/main/java/mb/statix/benchmark/JavaRun.java`.
The script that executed this class is found in `build/profile.sh`.

The profiling results can be analyzed using `./Rscripts/plot-profile.sh INTERP.csv COMPILED.csv`.
The `INTERP.csv` argument is a CSV file containing the profiling snapshots for interpreted queries, and `COMPILED.csv` is a CSV file containing the profiling snapshots using compiled queries.
The scripts prints tables that show the relative shared of runtime of label order checking and regular expression derivate calculation.


### 6. Eclipse

Inside the virtual machine, there is an Eclipse instance that can be used to explore the query compilation algorithm.
The `sources/compilation-examples` provide 5 projects as a starting point.
- `statix.example`: A project that containst three `.stxtest` files that explain the basic usage of Statix queries.
  - `regex.stxtest`: explains how regular expressions influence query results.
  - `datawf.stxtest`: explains how data well-formedness conditions can be used to select the correct declarations
  - `shadowing.stxtest`: explains how shadowing is performed using label orders and data well-formedness conditions.
- `pcf`: A language frontend definition for PCF.
  - `trans/statics.stx`: contains the specification, including the queries, used for type-checking PCF programs.
- `pcf.example`: Project in which programs in PCF can be written, which are then parsed and type-checked using the specification from the `pcf` project.
  - `example-1-paper.pcf`: The first example in sect. 3.
- `lm`: A language frontend defition for a subset of Language with Modules (LM).
  - `trans/statics.stx`: contains the specification, including the queries, used for type-checking LM programs.
- `lm.example`: Project in which programs in LM can be written, which are then parsed and type-checked using the specification from the `pcf` project.
  - `example-2-paper.lm`: The second example in sect. 3.

In Eclipse, the following functions are important:
- Using `Project > Build Project` on `pcf` and `lm` makes the language specifications available.
- On a PCF/LM file, the `Spoofax > Statix > Show Scope Graph` menu show a textual representation of the scope graph of the program.
- On a Statix file (`.stx/.stxtest`), the `Spoofax > Syntax > Show pre-compiled AST` shows how declarative queries are translated to the new intermediate language.
- On a Statix test file (`.stxtest` only), using `Spoofax > Evaluate > Evaluate Test` evaluates a Spoofax test. This prints a solution to the initial `resolve` constraint. The solutution consists of a unifier (a mapping from variables to values), a scope graph and error/warning/note messages.


## Relation between Source Code and Paper

In this section, we discuss how the included sources relate to the paper.
We first give an overview of the `sources/` subdirectory, and then highlight a few important sources.
The sources subdirectory contains the following projects:
- `nabl/scopegraph`: contains the definition of scope graphs, and the name resolution algorithms.
- `nabl/p_raffrayi`: contains a framework for executing scope-graph-based type-checkers concurrently and incrementally. It is included because this artifact contains a special development build of Statix that allows tracing queries (required for the tests and micro-benchmarks), but not directly relevant.
- `nabl/statix.solver`: contains the Solver for Statix, which uses scope graph based name resolution.
  - `src/main/java/mb/statix/concurrent/StatixSolver.java` contains the concurrent Statix solver, which is used for the integration benchmarks. Lines 624-715 (esp. 670-673) show how queries are interpreted. This corresponds to the `Op-Query-SM` rule in figure 7 of the paper.
- `nabl/statix.lang`: contains the Statix meta-language definition
  - `syntax/statix/lang/PreCompiled.sdf3` contains the syntax of compiled queries, corresponding to figure 6 of the paper.
- `statix.benchmark`: contains the test and benchmarking tools discussed extensively above.
- `java-front/lang.java`: Syntax specification for Java.
- `java-front/lang.java.statics`: Type system specification for Java. Used for all tests and benchmarks that used Java projects as object programs.
- `java-evaluation/`: contains Java projects `commons-csv`, `commons-io` and `commons-lang3`, which are used for testing and benchmarking.
- `compilation-examples/`: contains projects that can be imported in Eclipse and explored, as discussed above.


### Name Resolution Algorithm

The name resolution algorithm is implemented three times in this artifact:
1. `sources/nabl/scopegraph/src/main/java/mb/scopegraph/oopsla20/reference/NameResolution.java`
2. `sources/nabl/scopegraph/src/main/java/mb/scopegraph/oopsla20/reference/FastNameResolution.java`
3. `sources/nabl/scopegraph/src/main/java/mb/scopegraph/ecoop21/NameResolution.java`

The name resolution algorithm as presented in figure 5 is implemented in (1). (2) is an adapted version which is slightly faster. This version is used in the micro-benchmarks as reference. (3) is an asynchronous implementation of (1), which is used in the concurrent Statix solver. We discuss the relation between (1) and figure 5 in more detail.


Creating an instance of this class is roughly equal to calling `Resolve` in fig. 5.
The fields are the values of the sub-functions.
The `dataLabel` field is the `$` label.
The completeness condition is used for scheduling queries correctly, which is briefly discussed in the Related Work section, but irrelevant otherwise.

The `env` method corresponds to `Resolve-All`, but passes all labels instead of only the head set (algorithm (3), which is used for profiling, makes this restriction).
The `env_L` method corresponds to `Resolve-L` and `Resolve-lL`.
The `env` variable is the aggregate of all iterations over the for loop.
It first computes the `max` over the label set.
Then, it iterates over each max label, and invokes `env_L` with the `smaller`-set.
Then, it computes the environment for `l` using `env_l`.
These results are shadowed (`minus`) and added to the aggregate set `env`.

The `max` and `smaller` functions directly correspond to their counterparts in the paper, and `env_l` to `Resolve-l-hat`.

The `env_data` method corresponds to `Resolve-$`.
It first tests if the current `path` matches the original `re` by checking if its current state is accepting.
In our paper, this check already happens in `ResolveAll` (specifically, the `{ $ | e \in L(R) }` condition).
Then, when `dataWf.wf(datum)` holds, the path is returned in a singleton environment.

Finally `env_edges` corresponds to `Resolve-l`.
It first checks whether `l` can be followed, which is the case when `newRe` is available.
The paper does this in the H(R) function in `Resolve-All`.
Then, it uses `getEdges` to retrieve all new target scopes.
For each target, it extends the path (`step`), and calls `env` (`Resolve-All`) again.


### Compilation Scheme

Second, the specializer from fig. 9 is implemented in `sources/nabl/statix.lang/trans/statix/lang/precompile/queries.str`, using the Stratego term transformation language.

At line 19 - 30, `StateMachine` terms are defined.
These are automata corresponding to regular expressions, _not_ state machines as defined in figure 6, but as emitted by `gen_states` (sect. 5.2).
This function is implemented as a Java primitive (`labelre-to-states`), which can be found in `sources/nabl/statix.solver/src/main/java/mb/statix/spoofax/STX_labelre_to_states.java`.
At line 61, it converts a regular expression into a state machine.
The while loop starting at line 77 generates all states, which are returned as a `StateMachine` term.

The first strategy in `.../precompile/queries.str` (`precompile-query`) corresponds to `specialize_M`.
After some bookkeeping, it invokes `labelre-to-states (line 64) to get a state machine corresponding to the initial regular expression of the query.
Then, it uses `compile-state` to compile all states to query resolution state machine states.
When possible, the optimization from 5.4 is applied by passing `compile-shadow-unconditional`.

`compile-state` corresponds to `specialize_Y`.
It computes the head-set of the regex state machine, and passes that to `compile-L`.
This returns a sequence of steps and a variable, which are returned in a `State` term.
The transformation is wrapped in `scope-local-new` to ensure unique variable name generation, and the `{| AvailableExp: ... |}` dynamic rule syntax is used to integrate the available-expression-based optimization (sect. 5.3) in the pipeline.

`compile-L`, which corresponds to `specialize_L` computes the `max`-set (line 86).
For each max label, its smaller set is computed, and the sequence of assignments that computes that sub-environment is generated (line 88/89).
This returns term of type `[[Asgn] * Var]`, stored in `E_v*`.
The assignments are flattened to `E*`, and a merge instruction for all subenvironments is added.

The rule for `compile-lL` (which corresponds to `specialize_lL`) has two cases.
The first case (lines 101-103), handles the case where `L` is empty.
It creates an expression for `l` (`Resolve`/`SubEnv`), and then uses `compile-non-existent` to check if the expression is already available.
The second case (line 105-109) additionally compiles the environment for its `L` set, and inserts the correct shadowing operation using `compile-shadow`.
This strategy argument can be either `compile-shadow-unconditional` or `compile-shadow-conditional`
The first is used when the data equivalence conditions is always true.
It generates a `CExp` expression, which is the `else` operator in fig. 11.
When shadowing is conditional, a `Shadow` expression is generated by `compile-shadow-conditional` (line 124-131)

Finally, the two cases for `specialize_l` are implemented in `compile-l`.


### Interpreting Compiled Queries.

Finally, we must discuss how interpreted queries are interpreted (figure 7).
An interpreter for compiled queries is implemented in two places:
1. `sources/nabl/scopegraph/src/main/java/mb/scopegraph/oopsla20/reference/ResolutionInterpreter.java`
2. `sources/nabl/scopegraph/src/main/java/mb/scopegraph/ecoop21/ResolutionInterpreter.java`, which is a asynchronous version of the first.
Again, because it is simpler, we discuss the first one.

The fields of this class correspond to the context variables of the `Eval-State` rule (apart from the path).
The second `resolve` method and the `evaluateStep` method implement the `Eval-State` rule.
`resolve` creates an empty store (implemented as a hashmap), evaluates all steps, and returns the value of the last step.
Evaluating a step comprises evaluating the expression and adding it to the store.
To evaluate an expression (in `evaluateExp`), 'pattern matching' is applied.
We discuss each case, each of which corresponds to a rule, below.

The case for `Resolve` expressions (line 67 - 75), which corresponds to to the `Exp-Resolve` rule, returns a singleton environment when the target of a scope has a datum and is wellformed.

The case for `SubEnv` expressions (line 77 - 134) corresponds to the `Exp-Subenv` rule.
It first retrieves the new state (81) and all relevant edges (82).
After that iterates over the targets, and aggregates all environments this returns.
This is split in three separate but similar loops to prevent redundant instantiation/copying of environments.

For `Merge` expressions, the third case (line 136 - 176), a similar pattern that effectively aggregates all environments the variables refer to, is applied. This corresponds to the `Exp-Merge` rule.

The case for `Shadow` expressions (line 178 - 199) implements rule `Exp-Shadow`.
It retrieves both environments and applies shadowing to the right argument.
The `isShadowed` function returns `false` only if no declaration in the left environment shadows it.

Finally, the last case (line 201 - 209) implements the rules in figure 11.
The left environment is returned if not empty (`Exp-Else-L`) or the result of evaluating the right expression (`Exp-Else-R`) otherwise.


## Known Issues

On some operating systems, using the VM with QEMU crashes with the following message:
```
vmx_write_mem: mmu_gva_to_gpa ffff9c5a5d044000 failed
```
This is due to a bug in QEMU.
[StackOverflow](https://stackoverflow.com/questions/60231203/qemu-qcow2-mmu-gva-to-gpa-crash-in-mac-os-x) suggests this can be fixed by altering the `-cpu` argument in `./run`.
