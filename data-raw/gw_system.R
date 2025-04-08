library(tidyverse)

# Really tired of repeating myself by this point. Gotta put this one in
# {peacesciencer}
gw_microstates <- read_delim("http://ksgleditsch.com/data/microstates.txt")
gw_microstates %>% data.frame

gw_states2 <- read_delim("http://ksgleditsch.com/data/ksgmdw.txt")
# ^ I am pretty sure that this is a simple update from what I last recorded
# through 2020, but might as well be safe...


gw_microstates %>%
  rename(gwcode = 1,
         stateabb = 2,
         statename = 3,
         startdate = 4,
         enddate = 5) %>%
  mutate(microstate = 1) %>%
  bind_rows(gw_states2 %>%
              rename(gwcode = 1,
                     stateabb = 2,
                     statename = 3,
                     startdate = 4,
                     enddate = 5) %>% mutate(microstate = 0), .) -> gw_system

# I know this is horribly inefficient, and I'm doing a lot of copy-paste. But...
gw_system %>%
  select(gwcode:statename, microstate, everything()) %>%
  rename(gw_abb = 2,
         gw_name = 3,
         start = 5,
         end = 6) -> gw_system

save(gw_system, file="data/gw_system.rda")
