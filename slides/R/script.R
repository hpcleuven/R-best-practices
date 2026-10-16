# Load libraries ####
library(dplyr)
library(readr)
library(here)

# Setup ====

## Make subset ====
library(nycflights13) # flights dataset
library(tidyverse)
set.seed(1000)
subset_flights <- flights |> sample_n(2000)

## Save subset ====
subset_flights |>
  # mutate(empty_column = sample(c("", "a", "x", ""), n(), replace=T)) |> 
  write_csv("Flight Subset 2013.csv")
file.copy("Flight Subset 2013.csv", here("data", "nycflights13_random2000.csv"))

# Reload subset ####
some_flights_raw <- read_csv(here("data", "nycflights13_random2000.csv"))

## Change some columns ====
delay_levels <- c("Early", "Kind of on time", "Late")

categorize_delay <- function(minutes) {
  case_when(
    is.na(minutes) ~ NA,
    minutes < -30 ~ delay_levels[[1]],
    minutes <= 30 ~ delay_levels[[2]],
    TRUE ~ delay_levels[[3]]
  ) |> 
    factor(levels = delay_levels)
}
some_flights <- some_flights_raw |> 
  mutate(
    month_name = month.name[month],
    across(
      ends_with("delay"),
      categorize_delay,
      .names = "{.col}_cat"
    ),
    across(where(is.character), as.factor)
  )

## Explore ====

some_flights |> 
  select(contains("delay"))

table(some_flights$dep_delay_cat)

## Save categorical variables and delay ====
cat_file_name <- here("data", "flights_with_factors.csv")
some_flights |>
  select(carrier, flight, month_name, time_hour, contains("delay")) |> 
  write_csv(cat_file_name)

read_csv(cat_file_name)
spec_csv(cat_file_name)
read_csv(cat_file_name, col_types = list(
  month_name = col_factor(levels = month.name),
  dep_delay_cat = col_factor(levels = delay_levels, ordered = TRUE),
  arr_delay_cat = col_factor(levels = delay_levels, ordered = TRUE),
  dep_delay = "i",
  arr_delay = "i",
  time_hour = "T",
  .default = "c")
)
