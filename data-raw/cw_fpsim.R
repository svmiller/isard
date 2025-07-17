library(tidyverse)
library(peacesciencer)
library(isard)

create_dyadyears() -> DDY
attr(DDY, "ps_system") <- NULL
attr(DDY, "ps_data_type") <- NULL

sATOP <- haven::read_dta("/home/steve/Dropbox/data/atop/5.1/atop-sscore.dta")
ATOP <- haven::read_dta('/home/steve/Dropbox/data/atop/5.1/atop5_1ddyr.dta')
# ^ just as an FYI, Steve, there's right bound here at 2018.



# CoW has this issue. Does ATOP?
ATOP %>%
  filter(n() > 1, .by=c(ddyad, year))

# Supposedly no, so that's good.

# 'ddyad' can be split by the last three characters. For example, "2020" would
# be the directed dyad of USA (2) and Canada (20) whereas "20002" would be the
# directed dyad of Canada (20) and the U.S. The last three digits honor the
# three-digit maximum of the state code whereas the first N digits need not.


data.frame(ddyad = c(2020, 20002, 910940, 70910, 910070)) %>%
  mutate(ccode2 = str_sub(ddyad, -3, -1),
         ccode1 = str_sub(ddyad, 1, -4))

# Proof of concept above...

ATOP %>%
  mutate(ccode2 = str_sub(ddyad, -3, -1),
        ccode1 = str_sub(ddyad, 1, -4)) %>%
  select(ddyad, ccode1, ccode2, year, everything()) %>%
  mutate(ccode1 = as.numeric(ccode1),
         ccode2 = as.numeric(ccode2)) %>%
  select(ccode1:consul) %>%
  left_join(DDY %>% filter(year <= 2018), .) %>%
  mutate(across(atopally:consul, ~ifelse(is.na(.), 0, .))) -> DDY


# Okay, here comes the stuff that I hate, though I understand that this is the
# convention. You should not think of alliances as "valued" in any way, shape,
# or form. No matter, this is the way it's done and been done. The extent to
# which we continue doing this, Chiba et al. (2022) suggest the following
# ranking based on the ATOP data.
#
# 3 = defense and/or offense (regardless of other content).
# 2 = neutrality and/or consultation (but no defense or offense obligations)
# 1 = nonaggression (but no defense, offense, neutrality, or consultation)
# 0 = no alliance obligation

DDY %>%
  distinct(atopally, defense, offense, neutral, nonagg, consul) -> proof_o_concept


proof_o_concept %>%
  mutate(ordatop = case_when(
    atopally == 0 ~ 0,
    defense == 1 | offense == 1 ~ 3,
    (neutral == 1 | consul == 1) & (defense == 0 & offense == 0) ~ 2,
    nonagg  == 1 & (defense == 0 & offense == 0 & neutral == 0 & consul == 0) ~ 1,
    TRUE ~ 0 # this will capture those asymm observations where there is an alliance but no obligation
  )) %>% data.frame

# Hmm, is that a 'shareob' that I just wanted to pass over/ignore.

ATOP %>%
  filter(nonagg == 0 & defense == 0 & offense == 0 & neutral == 0 & consul == 0) %>%
  summary

# No, but they are all asymm. Interesting. If we follow the letter of the codebook
# provided by the authors, this is an absence of an "obligation", so they should
# be 0.

DDY %>%
  mutate(ordatop = case_when(
    atopally == 0 ~ 0,
    defense == 1 | offense == 1 ~ 3,
    (neutral == 1 | consul == 1) & (defense == 0 & offense == 0) ~ 2,
    nonagg  == 1 & (defense == 0 & offense == 0 & neutral == 0 & consul == 0) ~ 1,
    TRUE ~ 0 # this will capture those asymm observations where there is an alliance but no obligation
  )) -> DDY

DDY %>%
  expand(ccode1 = ccode1, ccode2 = ccode2, year = year,
         ordatop = 3) %>%
  filter(ccode1 == ccode2) %>%
  left_join(., state_panel() %>%
              filter(year <= 2018) %>%
              as_tibble() %>%
              mutate(in_system = 1) %>%
              rename(ccode1 = ccode) %>%
              select(ccode1, year, in_system)) %>%
  filter(!is.na(in_system)) %>%
  select(-in_system) %>%
  bind_rows(DDY, .) %>%
  arrange(ccode1, year,  ccode2) -> DDY


# Gonna try to replicate that S score I see for Canada/Cuba in 1920. This should
# be a straightforward case where there are no alliances whatsoever.
sATOP %>% filter(year == 1920 & ccode1 == 20) %>% slice(1) %>% data.frame

DDY %>%
  filter(ccode1 == 40 & year == 1920) %>%
  #  data.frame %>%
  select(ccode2, ordatop) %>%
  rename(cub_ordatop = 2) %>%
  left_join(., DDY %>% filter(ccode1 == 20 & year == 1920) %>% select(ccode2, ordatop)) %>%
  rename(can_ordatop = 3) -> example

srs <- function(data) {
  numer <- sum((data$cub_ordatop - data$can_ordatop)^2)
  denom <- length(data$can_ordatop)*(max(data$can_ordatop)^2)
  1 - 2*(numer/denom)
}


srs(example)

DDY %>%
  filter(year == 1816) %>%
  select(ccode1, ccode2, ordatop) %>%
  spread(ccode2, ordatop) -> A

ccodes <- A$ccode1
n <- nrow(A)

s_matrix <- matrix(NA, nrow = n, ncol = n, dimnames = list(ccodes, ccodes))
A$ccode1 <- NULL

s_score <- function(x, y) {
  distance <-  sum((x - y)^2)
  max_dist <- length(x)*(3^2)
  1 - 2*(distance / max_dist)
}

for (i in 1:n) {
  for (j in i:n) {
    sim <- s_score(A[i, ], A[j, ])
    s_matrix[i, j] <- sim
    s_matrix[j, i] <- sim  # symmetric
  }
}

sATOP %>% filter(year == 1816)



srs <- function(data) {
  numer <- sum(abs(data$x- data$y))
  denom <- length(data$x)*max(data$x)
  1 - 2*(numer/denom)

}

DDY %>%
  filter(ccode1 == 40 & year == 1920) %>%
  data.frame %>%
  select(ccode2, ordatop)
  #bind_rows(., tibble(ccode2 = 40, ordatop = 3)) %>%
  arrange(ccode2) %>%
  rename(cub = ordatop) %>%
  mutate(can = ifelse(ccode2 == 20, 3, 0)) -> example

example

tibble(id = c("x", "y", letters[1:8]),
       x = c(1, 0, 0, 1, 0, 0, 1, 0, 0, 0),
       y = c(0, 1, 1, 0, 0, 0, 1, 1, 0, 0))  -> example

srs(example)

DDY %>%
  filter(ccode1 == 40 & year == 1920) %>%
#  data.frame %>%
  select(ccode2, ordatop) %>%
  rename(cub_ordatop = 2) %>%
  left_join(., DDY %>% filter(ccode1 == 20 & year == 1920) %>% select(ccode2, ordatop)) %>%
  rename(can_ordatop = 3) -> example

srs <- function(data) {
  similarity <- sum((data$cub_ordatop - data$can_ordatop)^2)
  max_similarity <- length(data$can_ordatop) * (max(data$can_ordatop)^2)
  1 - 2*(similarity / max_similarity)
}


srs(example)

  bind_rows(., tibble(ccode2 = 40, ordatop = 3)) %>%
  arrange(ccode2) %>%
  rename(cub = ordatop) %>%
  mutate(can = ifelse(ccode2 == 20, 3, 0)) -> example

srs <- function(data) {
  similarity <- sum((data$cub - data$can)^2)
  max_similarity <- length(data$cub) * (max(data$can)^2)
  1 - 2*(similarity / max_similarity)
}

DDY %>%
  select(ccode1:year, ordatop) %>%
  filter(year == 1920) %>%
  select(-year) %>%
  spread(ccode2, ordatop) %>%
  as.matrix() %>%
  cor(method = 'kendall') %>%
  as_tibble() %>%
  select(-ccode1) %>% slice(-1) %>%



srs <- function(example) {
  numer <- sum((example$cub - example$can)^2)
  denom <- length(example$cub)*(3^2)
  1 - 2*(numer/denom)

}

tribble(~state, ~gmy, ~rus,
        "GMY", 3, 0,
        "RUS", 0, 3,
        "UKG", 0, 1,
        "FRN", 0, 3,
        "AUH", 3, 0,
        "ITA", 3, 1,
        "BEL", 0, 0,
        "SPN", 0, 0,
        "TUR", 0, 0,
        "NTH", 0, 0,
        "SWD", 0, 0,
        "RUM", 3, 0,
        "POR", 0, 0,
        "SWZ", 0, 0,
        "GRC", 0, 0,
        "DEN", 0, 0,
        "YUG", 0, 0,
        "BUL", 0, 0,
        "NOR", 0, 0,
        "ALB", 0, 0) -> AA

srs <- function(example) {
  numer <- sum(abs(example$gmy - example$rus))
  denom <- length(example$gmy)*3
  1 - 2*(numer/denom)

}

srs(AA)

1/(3)

example %>%
  srs(.)

srs(example)

sATOP





DD


sATOP %>%
  select(dyad, ccode1, ccode2, year) %>%
  left_join(ATOP, .) %>%
  select(dyad, ccode1, ccode2, year, everything()) -> ATOP

ATOP %>%
  summary
