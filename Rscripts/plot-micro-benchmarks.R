#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ggplot2))

files <- commandArgs(trailingOnly = TRUE)

# Load data
raw <- files[1] %>% read.csv(sep=";")
compiled <- raw %>%
  filter(Benchmark == "mb.statix.benchmark.resolution.ResolutionBenchmark.runCompiled") %>%
  select(
    Param..projectName_idx,
    Score
  ) %>%
  rename(
    ScoreCompiled = Score,
    ProjectName_Index = Param..projectName_idx
  )
trad <- raw %>%
  filter(Benchmark == "mb.statix.benchmark.resolution.ResolutionBenchmark.runTraditional") %>%
  select(
    Param..projectName_idx,
    Score
  ) %>%
  rename(
    ScoreTraditional = Score,
    ProjectName_Index = Param..projectName_idx
  )
data <- inner_join(trad, compiled, "ProjectName_Index") %>%
  mutate(
    SpeedUp = ScoreCompiled / ScoreTraditional,
    SpeedUpLog2 = log(SpeedUp, base = 2)
  )

# Plot Histogram
png(
  filename = files[2], width = 320, height = 320, units = "px"
)

h <- hist(data$SpeedUpLog2,
  breaks = 20,
  freq = FALSE,

  ylim = c(0, 0.6),

  # Ensure axes connect properly
  xaxs = "i",
  yaxs = "i",

  main = "Histogram of Speedup Factors",
  xlab = expression(log[2](RT[gen] / RT[com])),
  ylab = "Relative Frequency"
)

names = data.frame(Start = h$breaks[-1], End = head(h$breaks, -1), Log.SpeedUp = h$density) %>%
  mutate(Header = sprintf("%.1f - %.1f", Start, End)) %>%
  select(Header, Log.SpeedUp)

q <- quantile(data$SpeedUp)
q <- append(q, q[4] - q[2])         # Calculate IQR (Q3 - Q1)
q <- append(q, q[3] + 1.5 * q[6])   # Calculate Upper Fence (Q2 + 1.5IQR)
q <- setNames(q, c("Min", "Q1 (25%)", "Mean (50%)", "Q3 (75%)", "Max", "IQR", "Upper Fence"))

cat("\nHistogram:\n")
print(names)
cat("\nSummary of SpeedUps:\n")
print(q)
