# Installation guide
## Verify boot mode
```bash
ls /sys/firmware/efi/efivars
```

## Check ethernet connection
```bash
ping -c 1 archlinux.org
```

## Create partitions on disk
```bash
fdisk /dev/sda

# Create GPT partition table
> g

# Create EFI partition
> n
> 1
>
> +372M
> t
> 1

# Create SWAP partition
> n
> 2
>
> +16G
> t
> 2
> 19

# Create ROOT partition
> n
> 3
>
> +239G

#Save changes
> w
```

## Format disk
```bash
mkfs.fat -F 32 /dev/sda1

mkswap /dev/sda2

swapon /dev/sda2

mkfs.ext4 /dev/sda3
```

## Mount the file systems
```bash
mount /dev/sda3 /mnt

mkdir /mnt/boot

mount /dev/sda1 /mnt/boot
```

## Install basic packages
```bash
pacstrap /mnt base base-devel linux linux-firmware
```

## Configure the system
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

## Change the system
```bash
arch-chroot /mnt
```

## Edit localizations
```bash
pacman -S nano

nano /etc/locale.gen

locale-gen
```

## Create host name
```bash
echo LinuxPC > /etc/hostname
```

## Setup accounts
```bash
passwd

useradd -m -g users -G audio,disk,network,optical,power,storage,video,rfkill,wheel -s /bin/bash archer

passwd archer
```

Add user to sudoers
```bash
echo "" > /etc/sudoers
echo "root ALL=(ALL) ALL" >> /etc/sudoers
echo "archer ALL=(ALL) ALL" >> /etc/sudoers
```

## Install drivers
```bash
pacman -S intel-ucode
pacman -S intel-media-sdk
pacman -S vulkan-intel
```

## Install important packages
```bash
pacman -S networkmanager

systemctl enable NetworkManager
```

## Boot the system
### Install packages
```bash
pacman -S efibootmgr
```

### NVRAM registry
```bash
efibootmgr --disk /dev/sdX --part Y --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=PARTUUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw initrd=\initramfs-linux.img' --verbose
```

## Reboot
```bash
exit

umount -R /mnt

reboot
```

# Deepin Environment
## Installation
```bash
pacman -S deepin
```

Edit LightDM configuration file
```bash
nano /etc/lightdm/lightdm.conf
```
replace greeter session
```
greeter-session=lightdm-deepin-greeter
```
Enable LightDM on startup
```bash
systemctl enable lightdm.service
```

## Fixes
### Wireless network
Edit NetworkManager configuration file
```bash
nano /etc/NetworkManager/NetworkManager.conf
```
add the following lines
```
[device]
wifi.scan-rand-mac-address=no
```
