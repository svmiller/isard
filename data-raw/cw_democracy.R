library(tidyverse)
library(peacesciencer)
library(democracyData) # v. 0.5.1
library(vdemdata)      # v. 15

packageVersion("vdemdata")
packageVersion("democracyData")

# For creating basic CoW state years
create_stateyears() -> cw_democracy

cw_democracy

extended_uds %>%
  select(cown, extended_country_name, year, z1, z1_adj) %>%
  na.omit %>%
  rename(ccode = cown) %>%
  filter(n() > 1, .by = c(ccode, year)) %>%
  arrange(ccode, year) %>%
  data.frame

# Always, always Serbia/Yugoslavia...

extended_uds %>% filter(cown == 345 & year %in% c(1918:1920, 2006:2010))

# Okay, looks like this will concern just the years of 1918, 1919, 1920,
# and then 2006-2010. If I understand Marquez' data correctly, we can lean on
# the in_GW_system column for this. If it's TRUE, I'm going to interpret that
# as part of the collision with the G-W system for this exact case.

extended_uds %>%
  filter(!(cown == 345 & year %in% c(1918:1920, 2006:2010) & in_GW_system == TRUE)) %>%
  select(cown, extended_country_name, year, z1, z1_adj) %>%
  na.omit %>%
  rename(ccode = cown) %>%
  left_join(cw_democracy, .) %>%
  select(-extended_country_name) -> cw_democracy

Polity <-  readxl::read_excel("/home/steve/Dropbox/data/polity/p5v2018.xls")

Polity %>%
  select(ccode, country, year, polity2) %>%
  filter(n() > 1, .by=c(ccode, year))

# Polity doesn't appear to have any obvious issues? Certainly of the kind that
# would result in merge hell.

Polity %>%
  select(ccode, year, polity2) %>%
  left_join(cw_democracy, .) -> cw_democracy


# Gonna just do the Vdem by way of the R package thing


vdem %>%
  as_tibble() %>%
  select(country_name, country_text_id, year, COWcode, v2x_polyarchy) %>%
  na.omit %>%
  filter(n() > 1, .by=c(COWcode, year))

# You're kidding... okay, then... I'll take that...
vdem %>%
  as_tibble() %>%
  select(year, COWcode, v2x_polyarchy) %>%
  rename(ccode = COWcode) %>%
  left_join(cw_democracy, .) -> cw_democracy




cw_democracy %>%
  rename(euds = z1,
         aeuds = z1_adj) %>%
  select(-statenme) -> cw_democracy

cw_democracy
# That was... suspiciously easier than I remember it being.

save(cw_democracy, file="data/cw_democracy.rda")
