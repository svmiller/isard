library(tidyverse)
library(peacesciencer)

gw_cow_years

# I remember taking care of this a few years ago, here:
# - https://github.com/svmiller/peacesciencer/blob/master/data-raw/gw_cow_years.R

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

# some manual fixes/insertions
gw_system %>%
  mutate(statename = case_when(
    gwcode == 437 ~ "Côte d'Ivoire",
    gwcode == 403 ~ "São Tomé and Príncipe",
    gwcode == 271 ~ "Württemberg",
    TRUE ~ statename
  )) -> gw_system


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
  group_by(gwcode, year) %>%
  mutate(ccode = ifelse(is.na(ccode) & n() > 1, max(ccode, na.rm=T), ccode)) %>%
  slice(1) %>% ungroup() -> gw_cw_panel

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

gw_cw_panel %>%
  mutate(ccode = case_when(
    gwcode == 260 & year >= 1991 ~ 255,
    gwcode == 678 & between(year, 1926, 1989) ~ 678,
    TRUE ~ ccode
  )) -> gw_cw_panel

gw_cw_panel %>%
  rename(gw_name = gw_statename,
         cw_name = cw_statename) -> gw_cw_panel


# gw_cw_panel %>%
#   mutate(gw_statename = case_when(gwcode == 437 ~ "Cote D'Ivoire",
#                                   gwcode == 271 ~ "Wuerttemberg",
#                                   TRUE ~ gw_statename)) -> gw_cw_panel


# gw_cw_panel %>%
#   select(year, gwcode, ccode) -> gw_cw_panel

save(gw_cw_panel, file="data/gw_cw_panel.rda")

# gw_cw_panel %>% filter(ccode == 41 & year == 1915)
#
# gw_cw_panel %>% filter(!is.na(ccode)) %>% filter(!is.na(gwcode)) %>% filter(n() > 1, .by=c(ccode, year))
#   select(year, gwcode, ccode)
