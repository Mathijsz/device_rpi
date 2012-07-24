#!/bin/bash
#
# script doing some things to your source tree
#

VENDOR_FILE="../../../vendor/cyanogen/products/cyanogen_rpi.mk"
ARM_ARCH_FILE="../../../build/core/combo/arch/arm/armv6-vfp.mk"
ARM_ARCH_MD5="2dc1eb2a25d653a0b8154d8d0b13c245"
ARM_ARCH_LOCAL_MD5=`md5sum $ARM_ARCH_FILE`

if [ ! -f $VENDOR_FILE ]; then

   echo "Vendor file does not exist, copying..."
   cp cyanogen_rpi.mk.dummy $VENDOR_FILE

fi


if [ $ARM_ARCH_LOCAL_MD5 != $ARM_ARCH_MD5 ]; then
   echo "armv6-vfp.mk differs from the needed one, correcting..."
   mv $ARM_ARCH_FILE "$ARM_ARCH_FILE".bak
   cp armv6-vfp.mk.dummy $ARCH_ARM_FILE
fi

