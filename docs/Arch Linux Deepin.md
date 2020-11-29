# Installation guide
This is installation with Deepin Desktop on Intel based platform. The main goal is to set up distro as minimal as possible and boot linux kernel directly from EFI implementation on motherboard.

## Verify boot mode
In this step we simply check boot mode. If Linux is booted in EFI mode the command should return a list of deivces.

```bash
ls /sys/firmware/efi/efivars
```

## Check ethernet connection
Considering the fact that installation takes place via the ethernet we should first check the connection. This can be done by simply pinging the official distro website or any other site.

```bash
ping -c 1 archlinux.org
```

## Create partitions on disk
We only need two partitions to work. First partition contains the linux kernel and bootloader files. Second is the root partition with the system files. This setup doesn't provide the swap partition for hibernation.

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

# Create ROOT partition
> n
> 2
>
> +255G

#Save changes
> w
```

## Format disk
After creating partitions we format them with right filesystem. EFI partition is formatted as FAT32 and root partition as EXT4.

```bash
mkfs.fat -F 32 /dev/sda1

mkfs.ext4 /dev/sda2
```

## Mount the file systems
Now we can mount these partitions in the right order.

```bash
mount /dev/sda2 /mnt

mkdir /mnt/boot

mount /dev/sda1 /mnt/boot
```

## Install basic packages
Using the script we download the necessary groups of packages.

* **base** - minimal package set
* **base-devel** - additional packages for developing
* **linux** - Linux kernel and modules
* **linux-firmware** - Linux firmware modules

```bash
pacstrap /mnt base base-devel linux linux-firmware
```

## Configure the system
Generating partitions mounting points.

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

## Change the system
Switching to the fresh base installation system

```bash
arch-chroot /mnt
```

## Edit localizations
Generate locales related with your preferences.

```bash
pacman -S nano

nano /etc/locale.gen

locale-gen
```

## Create host name
Create file with host name which will be shown in local network.

```bash
echo LinuxPC > /etc/hostname
```

## Setup accounts
First of all change root password. Next we add new user and changing its password.

```bash
passwd

useradd -m -g users -G audio,disk,network,optical,power,storage,video,rfkill,wheel -s /bin/bash archer

passwd archer
```

Add user to sudoers file

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
Many desktop environments rely on NetworkManager.

```bash
pacman -S networkmanager

systemctl enable NetworkManager
```

## Boot the system
### Install packages
This is the easiest and cleanest way to create NVRAM reigstry on motherboard.

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
