#!/bin/bash

# Stage 1: OpenMS Processing
# this needs to occur in the Docker container
/SCRIPTS/PIPELINE/01_detect_features.sh
/SCRIPTS/PIPELINE/02_rt_alignment.sh
/SCRIPTS/PIPELINE/03_link_features.sh
/SCRIPTS/PIPELINE/04_generate_seed_lists.sh
/SCRIPTS/PIPELINE/05_redetect_features.sh
