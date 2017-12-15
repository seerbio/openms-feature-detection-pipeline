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

# Get the base names of all the input files
input_data_dir <- commandArgs(TRUE)[1]
base_fns <- list.files(input_data_dir, pattern = "\\.mzML$")
base_fns <- str_replace_all(base_fns, pattern = "\\.mzML$", "")

# The originally detected features
in_fns <- paste0(base_fns, "_features_rta.featureXML")
out_fns <- paste0(base_fns, "_features_rta.csv")
map2(in_fns, out_fns, function(x, y) feat_df(x) %>% write.table(y, row.names = FALSE, quote = FALSE, sep = ","))

# The redetected features
in_fns <- paste0(base_fns, "_features_rta_redetected.featureXML")
out_fns <- paste0(base_fns, "_features_rta_redetected.csv")
map2(in_fns, out_fns, function(x, y) feat_df(x) %>% write.table(y, row.names = FALSE, quote = FALSE, sep = ","))

