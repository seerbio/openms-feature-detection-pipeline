#!/bin/bash

# Stage 2: R and Python processing
# this occurs outside of the docker container
# since installing R, python and packages inside
# the OpenMS container image causes problems
Rscript SCRIPTS/PIPELINE/06_parse_featureXMLs.R
Rscript SCRIPTS/PIPELINE/07_filter_overlapping_features_redetect.R
python3 SCRIPTS/PIPELINE/08_remove_overlapping_features.py
