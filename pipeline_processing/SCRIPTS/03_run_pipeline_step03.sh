#!/bin/bash

# Stage 3: OpenMS Processing
# this needs to occur in the Docker container
SCRIPTS/09_merge_redetected_features.sh
SCRIPTS/10_link_features_final.sh
