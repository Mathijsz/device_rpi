#!/bin/bash
#
# script doing some things to your source tree
#
# TODO: - fix bionic shizzle too (oh, the hackiness)
#       - improve vendorsetup.sh part
# Warning: ugly bash script ahead

DIR=`dirname $0`
WORKDIR=`pwd`

if [[ $DIR != "." && $WORKDIR != $DIR ]]; then
   echo "You will need to run this script from its directory"
   exit
fi

VENDOR_FILE="../../../vendor/cyanogen/products/cyanogen_rpi.mk"
ARM_ARCH_FILE="../../../build/core/combo/arch/arm/armv6-vfp.mk"
ARM_ARCH_MD5=`md5sum armv6-vfp.mk.dummy | awk '{ print $1 }'`

if [ -f $ARM_ARCH_FILE ]; then
   ARM_ARCH_LOCAL_MD5=`md5sum $ARM_ARCH_FILE | awk '{ print $1 }'`
else
   echo "Local armv6-vfp.mk file does not exist at all"
   echo "Trying to restore backup..."
   cp "$ARM_ARCH_FILE".bak $ARM_ARCH_FILE && echo "... successfully did that."
   if [ $? -ne 0 ]; then
      echo "... failed to do so."
      echo "Copying the new one for you"
      cp armv6-vfp.mk.dummy $ARM_ARCH_FILE && echo "done, please re-run the script."
      exit
   fi
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

if [[ -f $ARM_ARCH_FILE && $ARM_ARCH_LOCAL_MD5 != $ARM_ARCH_MD5 ]]; then
   echo "armv6-vfp.mk differs from the needed one, correcting..."
   mv $ARM_ARCH_FILE "$ARM_ARCH_FILE".bak
   cp armv6-vfp.mk.dummy "$ARM_ARCH_FILE"
else
   echo "armv6-vfp.mk doesn't need any changes."
fi

LINE="add_lunch_combo cyanogen_rpi-eng"
VENDSETUP="../../../vendor/cyanogen/vendorsetup.sh"
VENDCHECK=`cat $VENDSETUP | grep cyanogen_rpi-eng | wc -l`

if [[ $VENDCHECK -gt 0 ]]; then
   echo "vendorsetup.sh doesn't need any changes."
else
   echo "Adding needed line to vendorsetup.sh"
   echo $LINE >> $VENDSETUP
fi

