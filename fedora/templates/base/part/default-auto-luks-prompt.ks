# Generated using Blivet version 3.4.3    
ignoredisk --only-use={{ disk_dev }}
# Partition clearing information
zerombr
clearpart --all --initlabel
# Disk partitioning information    
part /boot/efi --fstype="efi" --size=512 --fsoptions="umask=0077,shortname=winnt"
part /boot --fstype="ext4" --size=1024
part btrfs.249 --fstype="btrfs" --grow --encrypted --luks-version=luks2
btrfs none --label=fedora btrfs.249
btrfs / --subvol --name=@root fedora
# Required for smooth snapshot booting
btrfs /usr/lib/modules --subvol --name=@modules fedora
btrfs /var --subvol --name=@var fedora
btrfs /var/log --subvol --name=@var_log fedora
btrfs /home --subvol --name=@home fedora
btrfs /.snapshots --subvol --name=@snapshots fedora
