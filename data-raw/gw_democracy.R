# Last updated: June 25, 2026

library(tidyverse)
#library(peacesciencer)
library(isard)
library(democracyData) # v. 0.7.1
library(vdemdata)      # v. 16
library(mirt)

packageVersion("vdemdata")
packageVersion("democracyData")



state_panel(system = 'gw') %>%
  as_tibble() -> gw_democracy


# 1) Extended UDS data ----
# I used to lean on extended_uds, but I'd rather just do this myself.

# a) first, create a panel of G-W states...

state_panel(system = 'gw') %>%
  as_tibble() -> gw_panel

# b) then, pull the measures that appear in extended_uds

extended_uds %>%
  unnest(measures) %>%
  distinct(measures) %>%
  pull() -> measures

# c) follow a lot of the guide that Xavier makes available, but with one caveat.
#    the generate_democracy_scores_dataset does duplicate some rows in which the
#    lexical_index measures appear as separate rows to themselves. group_by() %>%
#    fill(.direction = 'downup') will take care of that.

demscores <- generate_democracy_scores_dataset(output_format = "wide")

demscores %>% select(GWn, year, all_of(measures)) %>%
  filter(!is.na(GWn)) %>%
  rename(gwcode = GWn) %>%
  arrange(gwcode, year) %>%
  # filter(n() > 1, .by = c(gwcode, year)) %>%
  # group_split(gwcode) %>% .[[3]]
  group_by(gwcode, year) %>%
  fill(measures, .direction = "downup") %>%
  ungroup() -> demscores

demscores %>%
  slice(1, .by=c(gwcode, year)) -> demscores

# d) prepare for {mirt}...

prepare_democracy_data(demscores) -> demscores

# e) isolate to just active G-W states since 1816.

gw_panel %>%
  left_join(., demscores) -> demscores


# f) time for {mirt}
gw_model <- mirt(demscores[, 4:ncol(demscores)],
                 model = 1, itemtype = "graded",
                 SE = TRUE, verbose = TRUE,
                 technical = list(NCYCLES = 2000))


# g) merge into gw_panel, to merge into gw_democracy

democracy_scores(gw_model) %>%
  select(z1, z1_adj) %>%
  mutate(z1 = as.vector(z1),
         z1_adj = as.vector(z1_adj)) %>%
  bind_cols(gw_panel, .) -> gw_panel

gw_democracy %>%
  left_join(., gw_panel %>% select(-gw_name)) -> gw_democracy


# Polity now....

Polity <-  readxl::read_excel("~/Koofr/data/polity/p5v2018.xls")

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
