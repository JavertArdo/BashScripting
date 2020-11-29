# Cheat Sheet
## Disk
### Cleaning disk
```bash
dd if=/dev/urandom of=/dev/sdX bs=4096 status=progress
```

## Processes
### Kill
```bash
pidof <app_name>
ps -A | grep <app_name>

kill -9 <app_pid>
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
