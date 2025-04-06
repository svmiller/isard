library(tidyverse)
library(peacesciencer)

cow_gw_years

# I remember taking care of this a few years ago, here:
# - https://github.com/svmiller/peacesciencer/blob/master/data-raw/cow_gw_years.R

# The only thing I think I'd do differently is make sure the microstate data
# are incorporated. That is one thing I didn't do. I should do it now.


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

gw_system

gw_system %>% # I remind myself that this is privileging the CoW stateabbs, but so be it...
  mutate(stateabb = case_when(
    stateabb == "HSD" ~ "HSG",
    # Justification for Serbia: the dates don't at all overlap, nor should they.
    stateabb == "SER" ~ "YUG",
    stateabb == "RUM" ~ "ROM",
    stateabb == "FJI" ~ "FIJ",
    stateabb == "KBI" ~ "KIR",
    TRUE ~ stateabb
  )) %>%
  rename(gw_statename = statename) %>%
  mutate(enddate = if_else(enddate == as_date("2020-12-31"), as_date("2024-12-31"), enddate)) %>%
  #mutate(enddate = if_else(enddate == as_date("2017-12-31"), as_date("2020-12-31"), enddate)) %>%
  rowwise() %>%
  mutate(day = list(seq(startdate, enddate, by = '1 day'))) %>%
  unnest(day) %>%
  mutate(gwday = 1) %>%
  select(gwcode, stateabb, gw_statename, day, gwday) -> gwdays


cow_states %>%
  mutate(stdate = ymd(paste0(styear,"/",stmonth, "/", stday)),
         enddate = ymd(paste0(endyear,"/",endmonth,"/",endday))) %>%
  select(stateabb:statenme, stdate, enddate) %>%
  rename(cw_statename = statenme) %>%
  mutate(enddate = if_else(enddate == as_date("2016-12-31"), as_date("2024-12-31"), enddate)) %>%
  rowwise() %>%
  mutate(day = list(seq(stdate, enddate, by = '1 day'))) %>%
  unnest(day) %>%
  select(-stdate, -enddate) %>%
  mutate(cowday = 1) -> cowdays


gwdays %>% full_join(., cowdays) -> cow_gw_days

cow_gw_days %>% mutate(year = year(day)) %>%
  distinct(stateabb, year, gwcode, ccode, gw_statename, cw_statename) %>%
  group_by(ccode, year) %>%
  mutate(gwcode = ifelse(is.na(gwcode) & n() > 1, max(gwcode, na.rm=T), gwcode)) %>%
  slice(1) %>% ungroup() -> cw_gw_panel

# gw_cw_panel %>% filter(is.na(ccode)) %>%
#   group_by(gwcode) %>%
#   summarize(min_year = min(year),
#             max_year = max(year),
#             n = n()) %>%
#   data.frame
#
#
# gw_cw_panel %>%
#   mutate(miss_ccode = ifelse(is.na(ccode), 1, 0)) %>%
#   mutate(n = n(), .by=gwcode) %>%
#   mutate(prop = sum(miss_ccode)/n, .by=c(gwcode)) %>%
#   filter(prop == 1) %>%
#   group_split(stateabb) %>%
#   .[[8]] %>% data.frame
#   filter(stateabb == "OFS") %>%
#   filter(prop == 1)
#   filter(is.na(ccode)) %>%
#   group_split(gwcode)

cw_gw_panel %>%
  mutate(gwcode = case_when(
    stateabb == "YAR" ~ 678,
    stateabb == "GMY" & year >= 1990 ~ 260,
    TRUE ~ gwcode
  )) -> cw_gw_panel


cw_gw_panel %>%
  group_by(ccode, year) %>%
  fill(gwcode) %>%
  group_by(ccode, year) %>%
  slice(1) -> cw_gw_panel

# Forgot to do this the first time around
cw_gw_panel %>% ungroup() -> cw_gw_panel

# In case this doesn't register...
cw_gw_panel %>%
  mutate(gw_statename = case_when(
    gwcode == 437 ~ "Cote D'Ivoire",
    gwcode == 271 ~ "Wuerttemberg",
    TRUE ~ gw_statename)) -> cw_gw_panel


# gw_cw_panel %>%
#   select(year, gwcode, ccode) -> gw_cw_panel

save(cw_gw_panel, file="data/cw_gw_panel.rda")

# gw_cw_panel %>% filter(ccode == 41 & year == 1915)
#
# gw_cw_panel %>% filter(!is.na(ccode)) %>% filter(!is.na(gwcode)) %>% filter(n() > 1, .by=c(ccode, year))
#   select(year, gwcode, ccode)
