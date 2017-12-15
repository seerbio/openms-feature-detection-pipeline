library(stringr)
library(tidyverse)


# Get the base names of all the input files
input_data_dir <- commandArgs(TRUE)[1]
base_fns <- list.files(input_data_dir, pattern = "\\.mzML$")
base_fns <- str_replace_all(base_fns, pattern = "\\.mzML$", "")


in1_fns <- paste0(base_fns, "_features_rta.csv")
in2_fns <- paste0(base_fns, "_features_rta_redetected.csv")
out_fns <- paste0(base_fns, "_feature_ids_redetected_rm.csv")

mz_tol_ppm <- 50
rt_tol_sec <- 20


for (i in seq_along(in1_fns)) {
  # These are the originally detected features
  feats_1 <- read_csv(in1_fns[i], col_types = "cddd")
  # These are the redetected features
  feats_2 <- read_csv(in2_fns[i], col_types = "cddd")
  
  # Figure out which features in feats_2
  # are not in feats_1
  feat_ids_rm <- c()
  for (j in 1:nrow(feats_1)) {
    comp_feat <- feats_1[j, ]
    
    diff_ppm <- (comp_feat$mz - feats_2$mz) / comp_feat$mz * 1e6
    diff_rt <- comp_feat$rt - feats_2$rt
    
    idx_sel <- which(abs(diff_ppm) <= mz_tol_ppm & abs(diff_rt) <= rt_tol_sec)
    feat_ids_rm <- c(feat_ids_rm, feats_2[idx_sel,]$feat_id)
  }
  
  tdf <- data.frame(feat_id = feat_ids_rm)
  write.table(tdf, out_fns[i], row.names = FALSE, quote = FALSE, sep = ",")
}
