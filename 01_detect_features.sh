#!/bin/bash
input_data_dir=$1

# This is the output directory
output_dir="PIPELINE_PROCESSING"
mkdir $output_dir

# Pipeline, Step 1
./SCRIPTS/99_start_openms_container.sh $input_data_dir $output_dir /SCRIPTS/01_run_pipeline_step01.sh

# Pipeline, Step 2
cd $output_dir
../SCRIPTS/02_run_pipeline_step02.sh $input_data_dir
cd ..

# Pipeline, Step 3
./SCRIPTS/99_start_openms_container.sh $input_data_dir $output_dir /SCRIPTS/03_run_pipeline_step03.sh

# Pipeline, Step 4
cd $output_dir
../SCRIPTS/04_run_pipeline_step04.sh $input_data_dir
cd ..

