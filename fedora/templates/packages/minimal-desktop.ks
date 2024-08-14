# Base Packages
%packages
# Exclude unwanted groups for minimal install
-@dial-up
-@input-methods
-@standard

# Install workstation-product-environment to resolve RhBug:1891500
@^workstation-product-environment

# Install cracklib-dicts and libpwquality for cryptsetup
cracklib
cracklib-dicts
libpwquality

# Install gpg keys
distribution-gpg-keys

#zram
zram

# Exclude unwanted packages
-gfs2-utils
-reiserfs-utils
-cheese
-rhythmbox
-virtualbox-guest-additions
-gnome-software
-gnome-tour
-gnome-boxes
-gnome-maps
-snapshot
-mediawriter
-PackageKit
-PackageKit-command-not-found
%end
# Enable zram, rpm does not properly create zram device
%post --interpreter /bin/bash
systemctl enable zram-swap --now
%end
