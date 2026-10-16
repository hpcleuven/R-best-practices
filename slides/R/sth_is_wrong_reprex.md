``` r
library(nycflights13)
df <- head(flights)
for (i in 1:length(df$dep_delay)) {
  if (is.na(df$dep_delay[[i]])) {
    df[i, "dep_delay_cat"] <- NA
  } else if(df$dep_delay[[i]] < -30) {
    df[i, "dep_delay_cat"] <- delay_categories[[1]]
  } else if(df$dep_delay[[i]] < 30) {
    df[i, "dep_delay_cat"] <- delay_categories[[2]]
  } else {
    df[i, "dep_delay_cat"] <- delay_categories[[3]]
  }
}
#> Error:
#> ! object 'delay_categories' not found
delay_categories <- c("Early", "Kind of on time", "Late")
```

<sup>Created on 2026-10-16 with [reprex v2.1.1](https://reprex.tidyverse.org)</sup>
