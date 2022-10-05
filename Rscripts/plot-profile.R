#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(tidyverse))

MTH_ROOT <- "java.util.concurrent.ForkJoinWorkerThread.run() ForkJoinWorkerThread.java"
MTH_QUERY_ROOT <- "mb.p_raffrayi.impl.AbstractUnit.doQuery(IActorRef, IActorRef, boolean, ScopePath, IQuery, DataWf, DataLeq, DataWf, DataLeq) AbstractUnit.java"

MTH_DERIV_REGEX <- "mb.scopegraph.ecoop21.RegExpLabelWf.step(Object) RegExpLabelWf.java"
MTH_LBL_ORD_CMP <- "mb.scopegraph.ecoop21.RelationLabelOrder.lt(EdgeOrData, EdgeOrData) RelationLabelOrder.java"

name_map = new.env(hash = TRUE)
assign(MTH_ROOT, "TypeCheck()", env = name_map)
assign(MTH_QUERY_ROOT, "Resolve()", env = name_map)
assign(MTH_DERIV_REGEX, "Derive()", env = name_map)
assign(MTH_LBL_ORD_CMP, "Label_LE()", env = name_map)

summarize_perf <- function(perf_data) {
  filtered_perf <- perf_data %>% 
    filter(Method %in% c(MTH_ROOT, MTH_QUERY_ROOT, MTH_DERIV_REGEX, MTH_LBL_ORD_CMP)) %>% 
    mutate(MethodName = mget(Method, env = name_map)) %>%
    select(MethodName, Time..ms.) %>%
    rename(Method = MethodName) %>%
    relocate(Method)
  full_time     <- (filtered_perf %>% filter(Method == "TypeCheck()"))[1, 2]
  query_time    <- (filtered_perf %>% filter(Method == "Resolve()"))[1, 2]
  filtered_perf %>%
    mutate(RelativeToFull  = (Time..ms. / full_time)  * 100) %>%
    mutate(RelativeToQuery = (Time..ms. / query_time) * 100) 
}

files <- commandArgs(trailingOnly = TRUE)

cat("Runtime using Query Resolution Algorithm\n")
print(read.csv(files[1]) %>% summarize_perf, row.names = FALSE, digits = 3)
cat("Runtime using Compiled Queries\n")
print(read.csv(files[2]) %>% summarize_perf, row.names = FALSE, digits = 3)

