# RZV2L Build Scripts Tutorial

## Build RV2L Scripts
The Scripts are used to to quickly build the Renesas and 3rd Party boards. 
#### Yocto Download Directory
In order to minimize network usage and Harddrive spave all builds are configured to use the same Download Directory **oss_package**.
## Docker Support
Some Linux Host enviroments are not supported or maybe corrupted. This docker script creates a supported build enviroment for the RZV2L. The Docker mounted volumes export the generated yocto enviroment to the Host.
#### Download
Create directory to build the RZV2L
clone this repo branch into the created directory and rename it "Scripts"
#### Build Docker
navigate to the Docker sub- directory of Scripts and run the following command. 
```
./setup.sh
```
#### Run the Docker Container
##### Dependencies
Source Directory external hardware. This is where all downloaded Yocto files are found
oss_package Directory: This is where Yocto FIles are downloaded. 

If the yocto source files are in a located an external device make sure to open the directoy with nautilas before running the Docker contiainer. 
Navigate back to the Created directory and run the following command
```
./Scrupts/Docker/run.sh
```
## Buld Yocto
All command from here assume you  are in the running container


## Deployment

After Yocto Build the following sections are used to deploy the images
### Network Deployment
These scripts deply the kernal image, DTB image, and Root Filesystem to the NTFS and TFTBoot drives that are setup on the Host PC. This section does not setup the Network Framework
### SDCard Deployment
This Script creates SD Card Images from each of the RZV2L Working directories. This script checks that all the files exists before creating the image. Only the image not the archive files are created.
