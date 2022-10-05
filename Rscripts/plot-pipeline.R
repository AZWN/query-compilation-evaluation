#!/usr/bin/env Rscript

options(width=240)

suppressPackageStartupMessages(library(tidyverse))

data <- commandArgs(trailingOnly = TRUE)[1] %>% read.csv  %>%
  mutate(Analysis.Time = Analysis.Time..agg. / sum(AST.Node.Count) * AST.Node.Count) %>%
  mutate(Total.Time = Parse.Time + Analysis.Time + Normalize.Time + Precompile.Time + CodeGen.Time) %>%
  mutate(
    Parse.Rel = Parse.Time / Total.Time,
    Analysis.Rel = Analysis.Time / Total.Time,
    Normalize.Rel = Normalize.Time / Total.Time,
    Precompile.Rel = Precompile.Time / Total.Time,
    CodeGen.Rel = CodeGen.Time / Total.Time,
  ) %>%
  select(-Analysis.Time..agg.) %>%
  arrange(desc(Precompile.Time)) %>%
  top_n(10, Precompile.Time)

print(data, row.names = FALSE, digits = 3)
cat("Total percentage of time spend on precompilation: ")
cat((sum(data$Precompile.Time) / sum(data$Total.Time) * 100) %>% round(1) %>% toString)
cat("%\n")