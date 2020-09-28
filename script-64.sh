sudo apt-get install pv unzip hdparm
curl -O https://raw.githubusercontent.com/hypriot/flash/master/$(uname -s)/flash
chmod +x flash
sudo mv flash /usr/local/bin/flash

# Just make sure the existing is gone
rm ./user-data.yml

# Download this yaml from this repo
curl -O https://gist.githubusercontent.com/RenEvo/6a9e244b670df334c42578b8fe95400b/raw/user-data.yml

// flash it
flash \
  --hostname mycloud.home.renevo.com \
  --userdata ./user-data.yml \
  https://github.com/DieterReuter/image-builder-rpi64/releases/download/v20171013-172949/hypriotos-rpi64-v20171013-172949.img.zip

