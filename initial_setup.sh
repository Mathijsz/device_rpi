#!/bin/bash
#
# script doing some things to your source tree
#
# TODO: - make sure the script adds cyanogen_rpi.mk to AndroidProducts.mk too (is this even necessary?)

VENDOR_FILE="../../../vendor/cyanogen/products/cyanogen_rpi.mk"
ARM_ARCH_FILE="../../../build/core/combo/arch/arm/armv6-vfp.mk"
ARM_ARCH_MD5=`md5sum armv6-vfp.mk.dummy | awk '{ print $1 }'`
ARM_ARCH_LOCAL_MD5=`md5sum $ARM_ARCH_FILE | awk '{ print $1 }'`
DIR=`dirname $0`
WORKDIR=`pwd`

if [[ $DIR != "." && $WORKDIR != $DIR ]]; then
   echo "You will need to run this script from its directory"
   exit
fi

if [[ ! -z $1  &&  $1 = 'restore' ]]; then
   if [ -f "$ARM_ARCH_FILE".bak ]; then
      rm $VENDOR_FILE && cp "$ARM_ARCH_FILE".bak $ARM_ARCH_FILE && echo "Backup successfully restored"
      exit
   else
      echo "No backups present, nothing to restore."
      exit
   fi
fi

echo "This script changes your source tree. Backups will be made."
echo "To restore backups, run './initial_setup.sh restore'"
read -p "Press [ENTER] if you want to continue, or else CTRL+C to bail out."

if [ ! -f $VENDOR_FILE ]; then
   echo "Vendor file does not exist, copying..."
   cp cyanogen_rpi.mk.dummy $VENDOR_FILE
else
   echo "Vendor file already exists."
fi

if [ $ARM_ARCH_LOCAL_MD5 != $ARM_ARCH_MD5 ]; then
   echo "armv6-vfp.mk differs from the needed one, correcting..."
   mv $ARM_ARCH_FILE "$ARM_ARCH_FILE".bak
   cp armv6-vfp.mk.dummy $ARCH_ARM_FILE
else
   echo "armv6-vfp.mk doesn't need any changes."
fi
