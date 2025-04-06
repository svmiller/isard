library(tidyverse)
library(peacesciencer)

GDPPC <- readRDS("/home/steve/Dropbox/data/fariss-gdp/estimates_gdppc_model_combined_normal_noslope_gamma_lambda_additive_test_20240416.rds")
GDP <- readRDS("/home/steve/Dropbox/data/fariss-gdp/estimates_gdp_model_combined_normal_noslope_gamma_lambda_additive_test_20240416.rds")
Pop <- readRDS("/home/steve/Dropbox/data/fariss-gdp/estimates_pop_model_combined_normal_noslope_gamma_lambda_additive_test_20240416.rds")

create_stateyears(subset_years = c(1816:2019)) -> cw_gdppop

cw_gdppop %>%
  left_join(., cw_gw_panel %>% select(year, gwcode, ccode)) -> cw_gdppop


GDPPC %>% #distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "Maddison2020_gdppc_ppp_bcbt") %>%
  select(gwcode, year, mean, sd) %>%
  left_join(cw_gdppop, .) %>%
  rename(mrgdppc = mean,
         sd_mrgdppc = sd) -> cw_gdppop

GDP %>% #distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "PWT100_gdp_ppp_none_2017") %>%
  select(gwcode, year, mean, sd) %>%
  left_join(cw_gdppop, .) %>%
  rename(pwtrgdp = mean,
         sd_pwtrgdp = sd) -> cw_gdppop

Pop %>% # distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "PWT100_pop") %>%
  select(gwcode, year, mean, sd) %>%
  left_join(cw_gdppop, .) %>%
  rename(pwtpop = mean,
         sd_pwtpop = sd) -> cw_gdppop

cw_gdppop %>%
  select(-statenme, -gwcode) -> cw_gdppop

save(cw_gdppop, file='data/cw_gdppop.rda')





GDPPC %>% #distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "Maddison2020_gdppc_ppp_bcbt") %>%
  declare_attributes(data_type = 'state_year', system = 'gw') %>%
  filter(year >= 1816) %>%
  left_join(., gw_cw_panel %>% select(year, gwcode, ccode)) %>%
  filter(!is.na(ccode)) %>%
  filter(n() > 1, .by=c(ccode, year)) %>% data.frame
  select(gwcode, year, mean, sd) %>%
  left_join(gw_gdppop, .) %>%
  rename(mrgdppc = mean,
         sd_mrgdppc = sd) -> gw_gdppop

# I remember taking care of this a few years ago, here:
# - https://github.com/svmiller/peacesciencer/blob/master/data-raw/gw_cow_years.R

# The only thing I think I'd do differently is make sure the microstate data
# are incorporated. That is one thing I didn't do

# Okay, I know this is G-W. Let me see what I can do.

# First, I really should've done this sooner. Might as well add this to the list
# of things to do.

gw_microstates <- read_delim("http://ksgleditsch.com/data/microstates.txt")
gw_microstates %>% data.frame


gw_microstates %>%
  rename(gwcode = 1,
         stateabb = 2,
         statename = 3,
         startdate = 4,
         enddate = 5) %>%
  mutate(microstate = 1) %>%
  bind_rows(gw_states %>% mutate(microstate = 0), .) -> all_gw

# Have to remind myself that things get a little wonky in Oceania:
#
# - Kiribati is 970 in the microstates data, but 946 in CoW.
# - Nauru is 971 in the microstates data, but 970 in CoW
# - Tonga is 972 in the microstates data, but 955 in CoW.
# - Tuvalu is 973 in the microstates data, but 947 in CoW.
#
# Mercifully, MSI, PAL, FSM, and WSM are the same.

# From the gw_cow_years.R script, on UPCA...
# GW have the United Provinces of Central America as gwcode == 89. This was the
# union of Guatemala (90), Honduras (91), El Salvador (92), Costa Rica (94),
# and Nicaragua (93). GW have this from July 1, 1823 to Dec. 31, 1839. What's at
# stake: all those successor states have Jan. 1, 1840 starts in GW. Start dates
# in CoW are a little more scattered. CoW has Guatemala at Jan. 1, 1868,
# Honduras at Jan. 1, 1899, El Salvador at Jan. 1, 1875, Nicaragua at Jan. 1, 1900,
# Costa Rica at Jan. 1, 1920, and Nicaragua at Jan. 1, 1920. That's pretty
# remarkable to have such a wild discrepancy.

# ^ In other words, you can ignore gwcode == 89 and don't have to worry about
# matching it to anything...

# Oh god, Gran Colombia. Let me remind myself of this...

all_gw %>%
  filter(gwcode %in% c(99, 100, 101, 95, 130, 135, 140))

# The only polite intrigue here is the slight overlap with Venezuela, but that's
# confined in the G-W system. There is no overlap whatsoever with the CoW system
# for these cases (barring the partial overlap with Brazil, but that' no concern
# here). You can ignore gwcode == 99 and don't have to worry about matching it
# to anything...

cow_states %>%
  filter(ccode %in% c(99, 100, 101, 95, 130, 135, 140))


# Let's do this and see what happens. There will be cleanup, I'm sure...

GDPPC %>%
  rename(gwcode = gwno) %>%
  filter(between(year, 1816, 2019)) %>%
  filter(!(gwcode %in% c(89, 99))) %>%
  filter(indicator == "Maddison2020_gdppc_ppp_bcbt") %>%
  select(gwcode, year, mean, sd) %>%
  mutate(ccode = countrycode::countrycode(gwcode, "gwn", "cown")) %>%
  mutate(ccode = case_when(
    # Ignore the temporal issues, per se. Just look for obvious matches...
    is.na(ccode) & gwcode == 54 ~ 54, # Dominica
    is.na(ccode) & gwcode == 55 ~ 55, # Grenada
    is.na(ccode) & gwcode == 56 ~ 56, # St. Lucia
    is.na(ccode) & gwcode == 57 ~ 57, # SVG
    is.na(ccode) & gwcode == 58 ~ 58, # A&B
    is.na(ccode) & gwcode == 60 ~ 60, # SKN
    is.na(ccode) & gwcode == 221 ~ 221, # Monaco
    is.na(ccode) & gwcode == 223 ~ 223, # Liechtenstein
    is.na(ccode) & gwcode == 232 ~ 232, # Andorra
    # Okay, I can see here that we're going to ride the struggle bus with Prussia/Germany
    is.na(ccode) & gwcode == 255 & year <= 1945 ~ 255, # Prussia/Germany, up until WW2
    TRUE ~ ccode
  )) %>%
  # Now advisable, I just want information...
  left_join(., all_gw %>%
              select(gwcode:statename, microstate) %>%
              slice(1, .by=gwcode)) %>%
  filter(is.na(ccode)) %>% print()
  # Doing this piece by piece, iteratively. I'm aware that something like Dominica
  # isn't a state in 1826. I'm just wanting to identify the easy stuff like this
  # before getting to the weird stuff (like Russia, Serbia, Yemen, etc.)



# declare_attributes(data_type = 'state_year', system = 'gw') %>%
#   add_ccode_to_gw() %>%
#   filter(is.na(ccode)) %>%
#   summarize(n = n(), .by=gwcode) %>%
#   data.frame

gw_gdppop

GDPPC %>% #distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "Maddison2020_gdppc_ppp_bcbt") %>%
  select(gwcode, year, mean, sd) %>%
  left_join(gw_gdppop, .) %>%
  rename(mrgdppc = mean,
         sd_mrgdppc = sd) -> gw_gdppop

GDP %>% #distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "PWT100_gdp_ppp_none_2017") %>%
  select(gwcode, year, mean, sd) %>%
  left_join(gw_gdppop, .) %>%
  rename(pwtrgdp = mean,
         sd_pwtrgdp = sd) -> gw_gdppop

Pop %>% # distinct(indicator)
  rename(gwcode = gwno) %>%
  filter(indicator == "PWT100_pop") %>%
  select(gwcode, year, mean, sd) %>%
  left_join(gw_gdppop, .) %>%
  rename(pwtpop = mean,
         sd_pwtpop = sd) -> gw_gdppop

gw_gdppop %>% select(-statename) %>%
  filter(year <= 2019) -> gw_gdppop

# gw_gdppop %>%
#   mutate(across(mrgdppc:sd_pwtpop, ~log(.))) -> gw_gdppop

save(gw_gdppop, file="data/gw_gdppop.rda")
