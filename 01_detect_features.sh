#!/bin/bash
input_data_dir=$1

# Pipeline, Step 1
./99_start_openms_container.sh $input_data_dir ../SCRIPTS/01_run_pipeline_step01.sh

# Pipeline, Step 2
cd pipeline_processing
../SCRIPTS/02_run_pipeline_step02.sh $input_data_dir
cd ..

# Pipeline, Step 3
./99_start_openms_container.sh $input_data_dir ../SCRIPTS/03_run_pipeline_step03.sh

# Pipeline, Step 4
cd pipeline_processing
../SCRIPTS/04_run_pipeline_step04.sh $input_data_dir
cd ..

