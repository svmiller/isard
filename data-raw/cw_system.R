library(tidyverse)
library(peacesciencer)

cow_states %>%
  mutate(start = as.Date(paste0(styear,"/", stmonth,"/", stday)),
         end = as.Date(paste0(endyear, "/", endmonth,"/",endday))) %>%
  rename(cw_abb = stateabb,
         cw_name = statenme) %>%
  select(ccode, cw_abb, cw_name, start, end) -> cw_system

save(cw_system, file="data/cw_system.rda")
