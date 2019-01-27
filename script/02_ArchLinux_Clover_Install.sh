#!/bin/bash

#Settings
SYSTEM_DISK="sda"
CLOVER_ISO_PATH="/tmp/Clover.iso"

# Copy files on EFI
if [[ ! -d "/mnt/iso" ]];
then
	bash -c "mkdir /mnt/iso"
fi
bash -c "mount -o loop $CLOVER_ISO_PATH /mnt/iso"

if [[ ! -d "/mnt/efi" ]];
then
	bash -c "mkdir /mnt/efi"
fi
bash -c "mount /dev/$(echo $SYSTEM_DISK)1 /mnt/efi"

bash -c "rsync -r --info=progress2 /mnt/iso /mnt/efi"

# Configure
# TODO

# Cleanup
bash -c "umount -R /mnt"
