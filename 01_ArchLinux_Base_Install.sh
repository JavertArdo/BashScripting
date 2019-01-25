#!/bin/bash

# System settings
SYSTEM_DISK="sda"
SYSTEM_SWAP_PARTITION_SIZE="1024M"		# 1GB for SWAP
SYSTEM_ROOT_PARTITION_SIZE="6144M"		# 6GB for /
SYSTEM_HOME_PARTITION_SIZE=""			# - for /home

# System language
SYSTEM_LOCALE_LANG="en_US.UTF-8 UTF-8"	# Localization
SYSTEM_LANG="en_US.UTF-8"				# Language

# Machine settings
HOST_NAME="linux"						# Computer's name

# User settings
USER_NAME="archer"
USER_GROUP="audio,disk,network,optical,power,storage,video,rfkill,wheel"

# Check if UEFI is enabled
if ! ls /sys/firmware/efi;
then
	echo "Error: Installation only in UEFI mode"
	exit 1
fi

(
	echo o;

	# Boot partition
	echo n;
	echo p;
	echo 1;
	echo "";
	echo +128M;

	# Swap partition
	echo n;
	echo p;
	echo 2;
	echo "";
	echo +$(echo $SYSTEM_SWAP_PARTITION_SIZE);

	# System partition
	echo n;
	echo p;
	echo 3;
	echo "";
	echo +$(echo $SYSTEM_ROOT_PARTITION_SIZE);

	# Home partition
	if [[ ! -z "$SYSTEM_HOME_PARTITION_SIZE" ]];
	then
		echo n;
		echo p;
		echo 4;
		echo "";
		echo +$(echo $SYSTEM_HOME_PARTITION_SIZE);
	fi

) | fdisk /dev/$(echo $SYSTEM_DISK)

# Format partitions
bash -c "mkfs.fat -F 32 /dev/$(echo $SYSTEM_DISK)1"
bash -c "mkswap /dev/$(echo $SYSTEM_DISK)2"
bash -c "mkfs.ext4 /dev/$(echo $SYSTEM_DISK)3"

if [[ ! -z "$SYSTEM_HOME_PARTITION_SIZE" ]];
then
	bash -c "mkfs.ext4 /dev/$(echo $SYSTEM_DISK)4"
fi

# Mount partitions
bash -c "swapon /dev/$(echo $SYSTEM_DISK)2"
bash -c "mount /dev/$(echo $SYSTEM_DISK)3 /mnt"

# Enable DHCPD
bash -c "dhcpd"

# Install base system
bash -c "pacstrap /mnt base"

# Generate fstab file
bash -c "genfstab -U /mnt >> /mnt/etc/fstab"

# Change root
bash -c "arch-chroot /mnt"

# Language
bash -c "echo $SYSTEM_LOCALE_LANG > /etc/locale.gen && locale-gen"
bash -c "echo $SYSTEM_LANG > /etc/locale.conf"

# Machine
bash -c "echo $HOST_NAME > /etc/hostname"

# User area
bash -c "passwd"
bash -c "useradd -m -g users -G $USER_GROUP -s /bin/bash $USER_NAME"
bash -c "passwd $USER_NAME"

# Setup root privilages
bash -c "echo > /etc/sudoers"
bash -c "echo 'root ALL=(ALL) ALL' > /etc/sudoers"
bash -c "echo '$USER_NAME ALL=(ALL) ALL' > /etc/sudoers"

# Cleanup section
bash -c "exit"
bash -c "umount -R /mnt"

echo "System has been already installed..."
echo "Configure your favourite bootloader..."

