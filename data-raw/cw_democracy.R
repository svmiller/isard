# Last updated: June 24, 2026

library(tidyverse)
#library(peacesciencer)
library(isard)
library(democracyData) # v. 0.7.1
library(vdemdata)      # v. 16
library(mirt)

packageVersion("vdemdata")
packageVersion("democracyData")

# For creating basic CoW state years
#create_stateyears() -> cw_democracy

state_panel(system = 'cow') %>%
  as_tibble() -> cw_democracy


# 1) Extended UDS data ----
# I used to lean on extended_uds, but I'd rather just do this myself.

# a) first, create a panel of CoW states...

state_panel(system = 'cow') %>%
  as_tibble() -> cw_panel

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

demscores %>% select(cown, year, all_of(measures)) %>%
  filter(!is.na(cown)) %>%
  rename(ccode = cown) %>%
  arrange(ccode, year) %>%
  group_by(ccode, year) %>%
  fill(measures, .direction = "downup") %>%
  ungroup() -> demscores

demscores %>%
  slice(1, .by=c(ccode, year)) -> demscores

# d) prepare for {mirt}...

prepare_democracy_data(demscores) -> demscores

# e) isolate to just active CoW states since 1816.

cw_panel %>%
  left_join(., demscores) -> demscores

# f) time for {mirt}
cw_model <- mirt(demscores[, 4:ncol(demscores)],
                 model = 1, itemtype = "graded",
                 SE = TRUE, verbose = TRUE,
                 technical = list(NCYCLES = 2000))


# g) merge into cw_panel, to merge into cw_democracy

democracy_scores(cw_model) %>%
  select(z1, z1_adj) %>%
  mutate(z1 = as.vector(z1),
         z1_adj = as.vector(z1_adj)) %>%
  bind_cols(cw_panel, .) -> cw_panel

cw_democracy %>%
  left_join(., cw_panel %>% select(-cw_name)) -> cw_democracy




# 2) Polity...

Polity <-  readxl::read_excel("~/Koofr/data/polity/p5v2018.xls")

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
  select(-cw_name) -> cw_democracy

cw_democracy
# That was... suspiciously easier than I remember it being.

save(cw_democracy, file="data/cw_democracy.rda")
