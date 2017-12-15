#!/bin/bash

# The name of the docker image to run
docker_img_name=hroest/openms-executables-2.2

# The directory path on the local system
# where the input data (mzML) are located
input_data_dir=$1

# The path to the script to execute
exe_script=$2

# The directory path on the local system
# where the pipeline processing will occur
# and output files will be written
output_data_dir=`pwd`/pipeline_processing
scripts_dir=`pwd`/SCRIPTS
ini_dir=`pwd`/INI


# Start up the docker image
docker run -it \
  -v $input_data_dir:/input_data \
  -v $output_data_dir:/pipeline_processing \
  -v $scripts_dir:/SCRIPTS \
  -v $ini_dir:/INI \
  -w /pipeline_processing \
   $docker_img_name \
   $exe_script
