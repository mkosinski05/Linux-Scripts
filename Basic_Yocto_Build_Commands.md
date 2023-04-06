### Sites

The required packages to build the RZV2L images are listed below. The links are password protected and require Renesas Sales to access.

[Linux BSP Package v0.8](https://renesasgroup.sharepoint.com/sites/RZG2LRZV2LProductTeam/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=B9lPfn&cid=0d70f554%2Dfe42%2D4064%2D84d4%2D919eca584c07&FolderCTID=0x012000A9F4D5CD96A4824C87216C4E9E1382E4&id=%2Fsites%2FRZG2LRZV2LProductTeam%2FShared%20Documents%2FGeneral%2FRZV2L%2F2%2EProduct%2F3%2ESoftware%2FRelease%2FRelease%5FPackage%2F2nd%5Frelease&viewid=e306ee10%2De545%2D4d46%2Dab46%2D4823744ef300)

[DRP-AI Support Package v0.90](https://renesasgroup.sharepoint.com/sites/RZG2LRZV2LProductTeam/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=B9lPfn&cid=0d70f554%2Dfe42%2D4064%2D84d4%2D919eca584c07&FolderCTID=0x012000A9F4D5CD96A4824C87216C4E9E1382E4&id=%2Fsites%2FRZG2LRZV2LProductTeam%2FShared%20Documents%2FGeneral%2FRZV2L%2F2%2EProduct%2F3%2ESoftware%2FRelease%2FRelease%5FPackage%2F2nd%5Frelease&viewid=e306ee10%2De545%2D4d46%2Dab46%2D4823744ef300)

[RZG2L Codec Library v0.4](https://renesasgroup.sharepoint.com/sites/RZGlobalAETeam/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=aU6A53&cid=7df44a88%2Dffd1%2D4987%2Daa2b%2Dc07988977850&RootFolder=%2Fsites%2FRZGlobalAETeam%2FShared%20Documents%2FGeneral%2FRZ%2DG%2FRZ%2DG2%2FRZG2L%20Codec%20Library%20v0%2E4&FolderCTID=0x01200090898976F43146438DCB95A7808BD610)

[RZG2L Mali Library v0.51](https://renesasgroup.sharepoint.com/sites/RZGlobalAETeam/Shared%20Documents/Forms/AllItems.aspx?csf=1&web=1&e=1b3GMz&cid=ceaa6e58%2Ddccb%2D4215%2Db113%2Db9bbae599b8f&RootFolder=%2Fsites%2FRZGlobalAETeam%2FShared%20Documents%2FGeneral%2FRZ%2DG%2FRZ%2DG2%2FRZG2L%20Mali%20Library%20v0%2E51&FolderCTID=0x01200090898976F43146438DCB95A7808BD610)

### Build

- Execute rzv2l_env.sh script. The script extracts zip files and the extracts the required archve files.
- Run the rzv2l_build.sh. This script builds the environment. This is includes Linux BSP, DRP-AI, RZG2L Mali, and codec.
- (Optional) rzv2l_clean.sh: This script removes the work directory and extracted files in step 1.

###  SDK

These steps show how to setup the SDK for developing embedded applications. 

##### 1. Build SDK

```
bitbake core-image-weston -c populate_sdk
```

##### 2. Install SDK  ( core-image-minimal )

```
cd ~/user_work/build/tmp/deploy/sdk
sudo sh poky-glibc-x86_64-core-image-minimal-aarch64-smarc-rzv2l-toolchain-3.1.5.sh
```

##### 2. Install SDK ( core-image-weston )

```
cd ~/user_work/build/tmp/deploy/sdk
sudo sh poky-glibc-x86_64-core-image-weston-aarch64-smarc-rzv2l-toolchain-3.1.5.sh
```

##### 3. Enable SDK

This command needs to be executed every time before development. Closing the terminal window with end the enviroment. 

```
source /opt/poky/3.1.5/environment-setup-aarch64-poky-linux
```

##### 4. Verify SDK 

```
echo $CC
aarch64-poky-linux-gcc -mcpu=cortex-a55 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security --sysroot=/opt/poky/3.1.5/sysroots/aarch64-poky-linux
```

### Adding Packages to BSP

**RZV2L BSP Configurations**

- TARGET_SYS	**aarch64-poky-linux**
- MACHINE         **smarc-rzv2l**

**Step 1.** You can find the Yocto Project recipes from [Yocto Open Embedded Recipe Website](https://layers.openembedded.org/layerindex/branch/master/layers/). From this page select recipe tab. Then enter the package you are looking for in the search bar. Use the name in the Recipe Name column in the following steps( i.e. openssl ).

**Step 2.**  Open the the work/build/conf/local.conf and add the following line

```
CORE_IMAGE_EXTRA_INSTALL += "<package_name>"
or
IMAGE_INSTALL_append = "<package_name>"
```

**Step 3.**  Build the yocto image and sdk.

```
bitbake core-image-weston
bitbake core-image-weston -c populate_sdk
```

**Step 4a.**  Verify package is added. If the example adds openssl.

```
ls ./tmp/work/$TARGET_SYS/openssh
.. list all openssl files
```

**Step 4b.**  Check the generated root file system

```
find ./tmp/work/$MACHINE-poly-linux/core-image-weston/1.0-r0/rootfs -name sshd
.. list of the package installation location in rootfs
```

**Step 4c.**  Check the SDK package

```
find ./tmp/work/$MACHINE-poly-linux/core-image-weston/1.0-r0/sdk -name sshd
.. list of the package installation location in the SDK
```

#### Reference

- [Yocto Adding Package](https://wiki.yoctoproject.org/wiki/Cookbook:Example:Adding_packages_to_your_OS_image)
- [Yocto Open Embedded Recipe Website](https://layers.openembedded.org/layerindex/branch/master/layers/)

### SDK Application Makefile

##### Set Include directories from the SDK root file system. 

```
OPENCV_LINK = -isystem ${SDKTARGETSYSROOT}/usr/include/opencv4 \
			  -lopencv_imgcodecs -lopencv_imgproc -lopencv_core -lopencv_highgui
```

Here is an example of linking the opencv verion 4 to the application build. The key thing to note here is the variable ***${SDKTARGETSYSROOT}***. This variable specifies the location of the target root file system used for the SDK. This variable created when the SDK section 4.

##### Statically Link BSP libraries.

```
BSP_080_SDK_FLAG = \
			  -ljpeg -lwebp -ltiff -lz -ltbb -lgtk-3 -lpng16 -lgdk-3 -lcairo  \
			  -llzma -lrt -lcairo-gobject \
			  -lxkbcommon -lwayland-cursor -lwayland-egl -lwayland-client -lepoxy \
			  -lfribidi -lharfbuzz -lfontconfig \
			  -lglib-2.0 -lgobject-2.0 -lgdk_pixbuf-2.0 -lgmodule-2.0 -lpangocairo-1.0 \
			  -latk-1.0 -lgio-2.0 -lpango-1.0 -lfreetype -lpixman-1 -luuid -lpcre \
			  -lmount -lresolv -lexpat -lpangoft2-1.0 -lblkid \
```

##### Compile 

```
${CXX} -std=c++14 sample_app_resnet50_cam.cpp camera.cpp image.cpp wayland.cpp \
	-lwayland-client \
	${OPENCV_LINK} ${BSP_080_SDK_FLAG} \
	-lpthread -O2 -ldl ${LDFLAGS} -o sample_app_resnet50_cam
```



