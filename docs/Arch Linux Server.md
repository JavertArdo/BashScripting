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

# Create ROOT partition
> n
> 2
>
> +59G

#Save changes
> w
```

## Format disk
```bash
mkfs.fat -F 32 /dev/sda1

mkfs.ext4 /dev/sda2
```

## Mount the file systems
```bash
mount /dev/sda2 /mnt

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
echo LinuxServer > /etc/hostname
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
```

## Configure network
```bash
pacman -S netplan

echo "ENABLED=1" | tee /etc/default/netplan
```

Then paste configuration to /etc/netplan/

## Remote control
```bash
pacman -S openssh

systemctl enable sshd
systemctl start sshd
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

## Post configuration
Enable systemd-resolved
```bash
systemctl enable systemd-resolved
systemctl start systemd-resolved
```

> ---
> **Hints**
>
> ```bash
> systemd-resolved --status
> systemd-resolved --flush-caches
> systemd-resolved --statistics
> ```
> ---

Apply netplan configuration
```bash
netplan apply /etc/netplan/*
```
