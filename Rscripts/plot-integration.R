#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(tidyverse))

cleanup <- function(data) {
  data %>%
    rename(
      Project = Param..project,
      Time = Score
    ) %>%
    select(Project, Time)
}

raw_data <- commandArgs(trailingOnly = TRUE)[1] %>% read.csv
interpreted <- raw_data %>% filter(Param..flags == 2) %>% cleanup %>% rename(Time_Interp = Time)
compiled <- raw_data %>% filter(Param..flags == 0) %>% cleanup %>% rename(Time_Compiled = Time)

data = inner_join(interpreted, compiled, by = "Project") %>% mutate(Speedup = (Time_Interp - Time_Compiled) / Time_Interp * 100)

print(data, row.names = FALSE, digits = 3)
