# Open MS Feature Detection Pipeline

*Pipeline for feature detection using OpenMS*

## Prerequisites

1. On your local machine make sure you have Python3 and R installed so that `python3` and `Rscripts` are on your path.

2. Make sure the following R packages are installed - 

    * stringr
    * xml2 (which in turn is dependent on `libxml2-dev`)
    * tidyverse

## Set-up

1. Install Docker on your system
        [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/)

2. By default, docker commands require root/sudo.  To configure access without sudo, execute the following command, then logout/login:

        sudo usermod -aG docker

3. Grab the latest OpenMS container and install them on your system    
        [https://github.com/OpenMS/OpenMS/wiki/OpenMS-Docker-Containers](https://github.com/OpenMS/OpenMS/wiki/OpenMS-Docker-Containers)

    - Choose the *OpenMS executables* container -- the pipeline only needs the OpenMS executable since all operations will be running from the commandline.  
    - An example as of 12/08/2017:

          docker pull hroest/openms-executables-2.2


4. After the container is downloaded, you can verify it's there via the command below.  Also note the full name of the container image under the REPOSITORY heading.  This name needs to be used in the 00_start_openms_container.sh script.

        docker images

## Running the Pipeline

1. Choose the location where you want to run the pipeline and checkout this repository there.

        git clone https://github.com/ZenBrayn/openms-feature-detection-pipeline.git

2. Review the ```SCRIPTS/99_start_openms_container.sh``` and update the docker image name variable ```docker_img_name``` to that from the ```docker images``` command.

3. Run the ```01_detect_features.sh``` script with one additional commandline argument: the absolute path where the input data are located on the local system, e.g.

        ./01_detect_features.sh /path/to/inputdata

4. This will start the docker container and change the working directory to the pipeline_processing sub-directory where the pipeline will run and the output files will be written.

5. Execute the pipeline running the script ```00_run_pipeline.sh```.  This main script will run a series of processing scripts which are all located under the ```SCRIPTS``` directory.  These scripts also refer to parameter input files located in the ```INI``` directory.  Generally speaking, the user will not need to modify the processing scripts or the parameter files.  For logging purposes the pipeline can be run as:

        00_run_pipeline.sh &> pipeline_log.txt

6. Depending on the number and size of the input files, the pipeline processing might take a long time.  These docker commands are helpful for managing your session:
    * detach from a running docker instance: ```CTRL-P, CTRL-Q```
    * list running docker instances: ```docker ps```
    * re-attach to a running docker instance: ```docker attach CONTAINER_ID``` (get the container ID from ```docker ps```)
