# Cheat Sheet
## Disk
### Cleaning disk
```bash
dd if=/dev/urandom of=/dev/sdX bs=4096 status=progress
```

## Packages
### Purge package
```bash
sudo pacman -Rns <package>
```

### Remove unnecessary packages
```bash
sudo pacman -R $(pacman -Qdtq)
```
