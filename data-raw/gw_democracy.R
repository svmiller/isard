library(tidyverse)
library(peacesciencer)
library(democracyData) # v. 0.5.1
library(vdemdata)      # v. 15

packageVersion("vdemdata")
packageVersion("democracyData")

# For creating basic CoW state years
# create_stateyears() -> cw_democracy


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

gw_system %>%
  mutate(styear = year(startdate),
         endyear = year(enddate)) %>%
  # No states died from 2020 to 2024, so this is safe (for now...)
  # Please don't jinx yourself, Steve...
  mutate(endyear = ifelse(endyear == 2020, 2024, endyear)) %>%
  rowwise() %>%
  mutate(year = list(seq(styear, endyear, by=1))) %>%
  select(gwcode, stateabb, statename, year) %>%
  unnest(year) -> gw_democracy



gw_democracy
# cool, cool, cool...
# Okay, let's get this show on the road...

extended_uds %>%
  select(GWn, extended_country_name,
         in_GW_system, year, z1, z1_adj) %>%
  na.omit %>%
  rename(gwcode = GWn) %>%
  filter(n() > 1, .by = c(gwcode, year)) %>%
  arrange(gwcode, year) %>%
  data.frame

# Boo... *booing intensifies*...
# Okay, let's see what's going on here...

extended_uds %>%
  filter(GWn %in% c(255, 260) & year %in% c(1945))

gw_system %>% filter(gwcode %in% c(255, 260))

# This is an interesting case. G-W have Germany (Prussia) until 1945, as gwcode
# 255. The democracy data have two gwcodes for 260 in that year, but none for 255.
# 260 won't be observed as a code until 1949, though. For what it's worth,
# I side-stepped this completely in the `gwcode_democracy` data in {peacesciencer}.
# I just have nothing for this observation in this year. I feel like I have to
# honor that here just by how straightforward the data are in the country name.

extended_uds %>%
  filter(GWn %in% c(255, 260) & year %in% c(1988:1992)) %>%
  arrange(year)

# This one looks like a bit more interesting. The implications are not terribly
# problematic, but it does suggest that 1990 observes a one-off democracy penalty
# for West Germany in eating East Germany, at least by this coding. I don't know
# how I feel about that interpretation, though. If the system is G-W and
# `in_GW_system` is TRUE for both, I might have more flexibility to pick one with
# more face validity.

extended_uds %>%
  filter(GWn %in% c(678:680) & year %in% c(1988:1992)) %>%
  arrange(year)

# I have less a stake or subject domain knowledge of this one and I will probably
# just slice the first one that I see.

# Okay, let's do it this way...

extended_uds %>%
  select(GWn, extended_country_name,
         in_GW_system, year, z1, z1_adj) %>%
  na.omit %>%
  rename(gwcode = GWn) %>%
  filter(n() > 1, .by = c(gwcode, year)) %>%
  arrange(gwcode, year) %>%
  data.frame %>%
  # NOTE TO FUTURE STEVE: Xavier is working on an update of these and you will
  # 100% want to inspect/change this when he does. It works for now, for what it
  # is ultimately doing.
  mutate(omit = c(1, 1, 0, 1, 0, 1)) %>%
  left_join(extended_uds %>%   select(GWn, extended_country_name,
                                      in_GW_system, year, z1, z1_adj) %>%
              na.omit %>%
              rename(gwcode = GWn), .) %>%
  mutate(omit = ifelse(is.na(omit), 0, omit)) %>%
  filter(omit == 0) %>%
  select(gwcode, year, z1, z1_adj) %>%
  left_join(gw_democracy, .) -> gw_democracy

# Polity now....

Polity <-  readxl::read_excel("/home/steve/Dropbox/data/polity/p5v2018.xls")

Polity %>% # This is going to bleed because it's demarcated in CoW...
  select(ccode, country, year, polity2) %>%
  left_join(., cw_gw_panel %>% select(year, gwcode, ccode)) %>%
  filter(!is.na(gwcode)) %>%
  filter(n() > 1, .by=c(gwcode, year))

# Booo, again...
# Okay, the Germany case is going to be a distinction without a difference.
# Let me eyeball the Yemeni cases...

Polity %>%
  select(ccode, country, year, polity2) %>%
  filter(ccode %in% c(678, 679) & year %in% c(1988:1991))

# Hmm. I'm just going to take the 679 of those with the polity2 of 0. The path
# of least resistance here would be to slice the last row.

Polity %>%
  select(ccode, country, year, polity2) %>%
  left_join(., cw_gw_panel %>% select(year, gwcode, ccode)) %>%
  filter(!is.na(gwcode)) %>%
  slice(n(), .by=c(gwcode, year)) %>%
  select(gwcode, year, polity2) %>%
  left_join(gw_democracy, .) -> gw_democracy


# Gonna just do the Vdem by way of the R package thing


vdem %>%
  as_tibble() %>%
  select(country_name, country_text_id, year, COWcode, v2x_polyarchy) %>%
  rename(ccode = COWcode) %>%
  left_join(., cw_gw_panel %>% select(year, gwcode, ccode)) %>%
  na.omit %>%
  filter(n() > 1, .by=c(gwcode, year))

# I am soooo suspicious of this, but let's see what happens...

vdem %>%
  as_tibble() %>%
  select(country_name, country_text_id, year, COWcode, v2x_polyarchy) %>%
  rename(ccode = COWcode) %>%
  left_join(., cw_gw_panel %>% select(year, gwcode, ccode)) %>%
  na.omit %>%
  select(gwcode, year, v2x_polyarchy) %>%
  left_join(gw_democracy, .) -> gw_democracy

# huh...

gw_democracy %>%
  select(gwcode, year, z1, z1_adj, polity2, v2x_polyarchy) %>%
  rename(euds = z1,
         aeuds = z1_adj) -> gw_democracy

save(gw_democracy, file="data/gw_democracy.rda")
