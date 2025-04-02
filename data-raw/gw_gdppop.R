library(tidyverse)
library(peacesciencer)

GDPPC <- readRDS("/home/steve/Dropbox/data/fariss-gdp/estimates_gdppc_model_combined_normal_noslope_gamma_lambda_additive_test_20240416.rds")
GDP <- readRDS("/home/steve/Dropbox/data/fariss-gdp/estimates_gdp_model_combined_normal_noslope_gamma_lambda_additive_test_20240416.rds")
Pop <- readRDS("/home/steve/Dropbox/data/fariss-gdp/estimates_pop_model_combined_normal_noslope_gamma_lambda_additive_test_20240416.rds")

create_stateyears(system = 'gw') -> gw_gdppop

# From their paper...
#
# Future users who are interested in within-country change should use one of the
# PPP estimates that are designed for this dimension of comparison (e.g., MDP
# 2018 RGDPpcNA in 2011 $US). Users interested in making between-country
# comparisons should use the estimates generated for the MDP 2018 CGDPpc in 2011
# $US variable. This is because the model includes parameters that preserve the
# built in methodologies used to generate the original dataset.26 All this to
# say, we take seriously the data production process of each variable included
# in our latent variable model, which should help guide scholars to the
# appropriate estimates generated from our model and alleviate concerns about
# combining different variables together in a unified latent variable framework.
#
# To close, we wish to reiterate that the uncertainty estimates associated with
# our data should always be incorporated into any statistical analysis and that,
# though these uncertainty estimates are useful, they do not eliminate concerns
# about systematic measurement error that may arise because of potential bias
# in the information sources used to estimate these data (such as lying or
# low state capacity). Moving forward, we plan to update our new data each year
# and incorporate new information as it becomes available.

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

save(gw_gdppop, file="data/gw_gdppop.rda")
