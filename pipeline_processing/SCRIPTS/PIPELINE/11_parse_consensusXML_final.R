library(xml2)
library(stringr)
library(tidyverse)

fn <- "linked_features_final.consensusXML"

x <- read_xml(fn)

# Read the map info for the filenames
map_list <- xml_find_all(x, ".//map")
map_df <- tibble(map_id = xml_attr(map_list, "id") %>% as.integer,
                 file_name = xml_attr(map_list, "name"),
                 dataset = str_match(file_name, "(.+)_features_rta_final\\.featureXML$")[, 2],
                 n_features = as.numeric(xml_attr(map_list, "size")))
map_id_to_dataset <- map_df %>%
  select(map_id, dataset) %>%
  deframe
saveRDS(map_df, "map_data_final.rds")


# Read the feature groups
feat_df <- function(feat_grp, map_id_map) {
  elements <- xml_find_all(feat_grp, ".//element")
  
  tibble(map_id = xml_attr(elements, "map") %>% as.integer,
         dataset = map_id_map[as.character(map_id)],
         feat_id = paste0("f_", xml_attr(elements, "id")),
         mz = xml_attr(elements, "mz") %>% as.numeric,
         rt = xml_attr(elements, "rt") %>% as.numeric,
         intensity = xml_attr(elements, "it") %>% as.numeric,
         charge = xml_attr(elements, "charge") %>% as.integer)
}

feat_grps <- xml_find_all(x, ".//consensusElement")

feat_data <- tibble(group_id = map_chr(feat_grps, function(x) xml_attr(x, "id")),
                    group_mz = map_chr(feat_grps, function(x) xml_find_all(x, "centroid") %>% 
                                         xml_attr("mz")) %>% as.numeric,
                    group_rt = map_chr(feat_grps, function(x) xml_find_all(x, "centroid") %>% 
                                         xml_attr("rt")) %>% as.numeric,
                    charge = map_chr(feat_grps, function(x) xml_attr(x, "charge")) %>% as.integer,
                    group_quality = map_chr(feat_grps, function(x) xml_attr(x, "quality")) %>% as.numeric,
                    feature_data = map(feat_grps, feat_df, map_id_to_dataset),
                    n_features = map_int(feature_data, nrow))

saveRDS(feat_data, "feature_data_final.rds")

