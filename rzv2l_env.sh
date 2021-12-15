BSP_FILE=rzv2l_linux-pkg_ver0.8.0.zip
DRP_FILE=rzv2l_drpai-support-pkg_ver0.91.zip
ISP_FILE=rzv2l_isp_support_pkg_ver.0.50.zip


if [ -f "$BSP_FILE" ]; then
    unzip $BSP_FILE
    cp rzv2l_linux-pkg_ver0.8.0/rzv2l_bsp_v080.tar.gz .
    rm -rfd rzv2l_linux-pkg_ver0.8.0
else
    echo "BSP Package $BSP_FILE is required"
    exit
fi

if [ -f "$DRP_FILE" ]; then
    unzip $DRP_FILE -d drp
    cp drp/rzv2l_meta-drpai_ver0.90.tar.gz .
    rm -rfd drp
else
    echo "DRP Pacakge not available"
fi 

if [ -f "$ISP_FILE" ]; then
### Copy/Move the 'ISP Pacakege' Zip file (rzv2l_isp_support_pkg_ver.0.50.zip) under the BSP directory.
    unzip $ISP_FILE -d isp
    cp isp/rzv2l_meta-isp_ver0.50.tar.gz .
    rm -rfd isp
else
    echo "ISP Pacakge not available"
fi 
