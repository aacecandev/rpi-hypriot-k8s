#!/bin/bash

# sudo apt-get install pv curl python-pip unzip hdparm
# sudo pip install awscli

# curl -O https://raw.githubusercontent.com/hypriot/flash/master/$(uname -s)/flash
# chmod +x flash
# mv flash ${HOME}/bin/flash


# Just make sure the existing is gone
# rm ./user-data.yml

# Download this yaml from this repo
# curl -O https://gist.githubusercontent.com/RenEvo/6a9e244b670df334c42578b8fe95400b/raw/user-data.yml

# Download the image
# https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.3/hypriotos-rpi-v1.12.3.img.zip
# https://ubuntu.com/download/raspberry-pi

# Add variables to env and parse user-data.yml
source exports.sh
envsubst < user-data-master.yml.tpl > user-data.yml
envsubst < device-init.yaml.tpl > device-init.yaml
envsubst < test.tpl > test

# Unzip the image
unzip hypriotos-rpi-v1.12.3.img.zip

flash \
  --userdata user-data.yml \
  --bootconf config.txt \
  --config device-init.yaml \
  --device $DEVICE \
  --file test \
  hypriotos-rpi-v1.12.3.img

rm hypriotos-rpi-v1.12.3.img

#OPTIONS:
#   --help|-h      Show this message
#   --bootconf|-C  Copy this config file to /boot/config.txt
#   --config|-c    Copy this config file to /boot/device-init.yaml (or occidentalis.txt)
#   --hostname|-n  Set hostname for this SD image
#   --ssid|-s      Set WiFi SSID for this SD image
#   --password|-p  Set WiFI password for this SD image
#   --clusterlab|-l Start Cluster-Lab on boot: true or false
#   --device|-d    Card device to flash to (e.g. /dev/disk2)
#   --force|-f     Force flash without security prompt (for automation)
#   --userdata|-u  Copy this cloud-init config file to /boot/user-data
#   --metadata|-m  Copy this cloud-init config file to /boot/meta-data
#   --file|-F      Copy this custom file to /boot

# https://cloudinit.readthedocs.io/en/latest/topics/merging.html

# ssh pirate@hostname.local -> password hypriot
