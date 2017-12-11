#!/bin/bash

# Stage 3: OpenMS Processing
# this needs to occur in the Docker container
SCRIPTS/PIPELINE/09_merge_redetected_features.sh
SCRIPTS/PIPELINE/10_link_features_final.sh
