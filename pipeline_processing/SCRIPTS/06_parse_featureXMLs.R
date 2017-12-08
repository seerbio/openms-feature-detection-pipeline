library(xml2)
library(stringr)
library(tidyverse)


feat_df <- function(feature_file) {
  cat("Processing", feature_file, "\n")
  x <- read_xml(feature_file)
  
  n_feats <- xml_find_first(x, "featureList") %>%
    xml_attr("count") %>%
    as.integer
  
  feats <- xml_find_all(x, ".//feature")
  
  out_df <- tibble(feat_id = map_chr(feats, xml_attr, "id"),
                   rt = map_dbl(feats, function(x) 
                     xml_find_all(x, ".//position") %>% xml_double %>% nth(1)),
                   mz = map_dbl(feats, function(x) 
                     xml_find_all(x, ".//position") %>% xml_double %>% nth(2)),
                   intensity = map_dbl(feats, function(x)
                     xml_find_all(x, ".//intensity") %>% xml_double))
  
  out_df
}

base_fns_1 <- paste0("20171116_",
              str_pad(1:18, width = 3, pad = "0"))

base_fns_2 <- paste0("20171117_",
              str_pad(1:17, width = 3, pad = "0"))

base_fns_3 <- paste0("20171120_",
              str_pad(1:17, width = 3, pad = "0"))

base_fns <- c(base_fns_1, base_fns_2, base_fns_3)

# The originally detected features
in_fns <- paste0(base_fns, "_features_rta.featureXML")
out_fns <- paste0(base_fns, "_features_rta.csv")
map2(in_fns, out_fns, function(x, y) feat_df(x) %>% write.table(y, row.names = FALSE, quote = FALSE, sep = ","))

# The redetected features
in_fns <- paste0(base_fns, "_features_rta_redetected.featureXML")
out_fns <- paste0(base_fns, "_features_rta_redetected.csv")
map2(in_fns, out_fns, function(x, y) feat_df(x) %>% write.table(y, row.names = FALSE, quote = FALSE, sep = ","))

