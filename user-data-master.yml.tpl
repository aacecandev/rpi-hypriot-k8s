#cloud-config
# vim: syntax=yaml
#

# The current version of cloud-init in the Hypriot rpi-64 is 0.7.9
# When dealing with cloud-init, it is SUPER important to know the version
# I have wasted many hours creating servers to find out the module I was trying to use wasn't in the cloud-init version I had
# Documentation: http://cloudinit.readthedocs.io/en/0.7.9/index.html

# CAUTION
#network:
#  config: disabled

# Set your hostname here, the manage_etc_hosts will update the hosts file entries as well
preserve_hostname: false
hostname: ${CLUSTER_MEMBER}
fqdn: ${CLUSTER_MEMBER}.${FQDN}
manage_etc_hosts: True

# This expands the root volume to the entire SD Card, similar to what the raspbian images did on first boot.
# This doesn't seem to be required, its more here for posterity in understanding what is going on
resize_rootfs: true
growpart:
    mode: auto
    devices: ["/"]
    ignore_growroot_disabled: false

# Set the locale of the system
locale: ${LOCALE}

# Set the timezone
# Value of 'timezone' must exist in /usr/share/zoneinfo
timezone: ${TIMEZONE}

# You could modify this for your own user information
# https://cloudinit.readthedocs.io/en/0.7.9/topics/modules.html#users-and-groups
users:
  - name: ${CLUSTER_MEMBER}
    gecos: ${CLUSTER_MEMBER}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    lock_passwd: true
    ssh-authorized-keys:
      - ${SSH_PUBLIC_KEY}
    #plain_text_passwd: hypriot
    #lock_passwd: false
    #ssh_pwauth: true
    #chpasswd: { expire: false }

apt:
  sources:
    kubernetes.list:
      keyid: "54A647F9048D5688D7DA2ABE6A030B21BA07F4FB"
      source: "deb https://apt.kubernetes.io/ kubernetes-xenial main"
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        xsBNBFrBaNsBCADrF18KCbsZlo4NjAvVecTBCnp6WcBQJ5oSh7+E98jX9YznUCrN
        rgmeCcCMUvTDRDxfTaDJybaHugfba43nqhkbNpJ47YXsIa+YL6eEE9emSmQtjrSW
        IiY+2YJYwsDgsgckF3duqkb02OdBQlh6IbHPoXB6H//b1PgZYsomB+841XW1LSJP
        YlYbIrWfwDfQvtkFQI90r6NknVTQlpqQh5GLNWNYqRNrGQPmsB+NrUYrkl1nUt1L
        RGu+rCe4bSaSmNbwKMQKkROE4kTiB72DPk7zH4Lm0uo0YFFWG4qsMIuqEihJ/9KN
        X8GYBr+tWgyLooLlsdK3l+4dVqd8cjkJM1ExABEBAAHNQEdvb2dsZSBDbG91ZCBQ
        YWNrYWdlcyBBdXRvbWF0aWMgU2lnbmluZyBLZXkgPGdjLXRlYW1AZ29vZ2xlLmNv
        bT7CwHgEEwECACwFAlrBaNsJEGoDCyG6B/T7AhsPBQkFo5qABgsJCAcDAgYVCAIJ
        CgsEFgIDAQAAJr4IAM5lgJ2CTkTRu2iw+tFwb90viLR6W0N1CiSPUwi1gjEKMr5r
        0aimBi6FXiHTuX7RIldSNynkypkZrNAmTMM8SU+sri7R68CFTpSgAvW8qlnlv2iw
        rEApd/UxxzjYaq8ANcpWAOpDsHeDGYLCEmXOhu8LmmpY4QqBuOCM40kuTDRd52PC
        JE6b0V1t5zUqdKeKZCPQPhsS/9rdYP9yEEGdsx0V/Vt3C8hjv4Uwgl8Fa3s/4ag6
        lgIf+4SlkBAdfl/MTuXu/aOhAWQih444igB+rvFaDYIhYosVhCxP4EUAfGZk+qfo
        2mCY3w1pte31My+vVNceEZSUpMetSfwit3QA8EE=
        =RwDt
        -----END PGP PUBLIC KEY BLOCK-----

# Update our packages on first boot, saves us some time
#package_update: true
#package_upgrade: true
#package_reboot_if_required: true

# Install any additional packages you need here
# https://cloudinit.readthedocs.io/en/0.7.9/topics/examples.html#run-apt-or-yum-upgrade
#apt_pipelining: false
#preserve_sources_list: false
#packages:
#  - ntp
#  - vim
#  - curl 
#  - gnupg2
#  - kubelet
#  - kubeadm
#  - kubectl
#  - isc-dhcp-server

#write_files:
  # Network interfaces
  #- content: |
  #    network: {config: disabled}
  #  path: /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
  
  #- content: |
  #    allow-hotplug wlan0
  #    iface wlan0 inet static
  #    address 192.168.1.60
  #    netmask 255.255.255.0
  #    broadcast 192.168.1.255
  #    gateway 192.168.1.1
  #    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
  #    iface default inet static
  #  path: /etc/network/interfaces.d/wlan0
  
  #- content: |
  #    allow-hotplug eth0
  #    iface eth0 inet static
  #    address 10.0.0.1
  #    netmask 255.255.255.0
  #    broadcast 10.0.0.255
  #    gateway 10.0.0.1
  #  path: /etc/network/interfaces.d/eth0

  # Please note, that you can either use your WiFi password directly or encrypted with wpa_passphrase OK
  #- content: |
  #    country=${COUNTRY_CODE}
  #    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
  #    update_config=1
  #    network={
  #    ssid=${SSID}
  #    psk=${WIFI_PASSWORD}
  #    proto=RSN
  #    key_mgmt=WPA-PSK
  #    pairwise=CCMP
  #    auth_alg=OPEN
  #    }
  #  path: /etc/wpa_supplicant/wpa_supplicant.conf
  
  # NAT subnet OK
  #- content: |
  #    # option definitions common to all supported networks...
  #    option domain-name "cluster.home";
  #    option domain-name-servers 8.8.8.8, 8.8.4.4;
  #    # If this DHCP server is the official DHCP server for the local
  #    # network, the authoritative directive should be uncommented.
  #    authoritative;
  #    # A slightly different configuration for an internal subnet.
  #    subnet 10.0.0.0 netmask 255.255.255.0 {
  #    range 10.0.0.2 10.0.0.10;
  #    option domain-name-servers 8.8.8.8, 8.8.4.4;
  #    option domain-name "cluster.home";
  #    option routers 10.0.0.1;
  #    option broadcast-address 10.0.0.255;
  #    default-lease-time 600;
  #    max-lease-time 7200;
  #    }
  #  path: /etc/dhcp/dhcpd.conf

  # Kubernetes CRI net conf OK
  #- content: |
  #    net.bridge.bridge-nf-call-iptables=1
  #    net.ipv4.ip_forward=1
  #    net.bridge.bridge-nf-call-ip6tables=1
  #    net.netfilter.nf_conntrack_max=1000000
  #  path: /etc/sysctl.d/99-kubernetes-cri.conf

  # br_netfilet OK
  #- content: |
  #    br_netfilter
  #  path: /etc/modules-load.d/netfilter.conf

  # isc-dhcp-server config OK
  #- content: |
  #    INTERFACESv4="eth0"
  #    INTERFACESv6=""
  #  path: /etc/default/isc-dhcp-server

  # CNI plugins network conf OK
  #- content: |
  #    {
  #      "cniVersion": "0.2.0",
  #      "name": "mynet",
  #      "type": "bridge",
  #      "bridge": "cni0",
  #      "isGateway": true,
  #      "ipMasq": true,
  #      "ipam": {
  #        "type": "host-local",
  #        "subnet": "10.22.0.0/16",
  #        "routes": [
  #            { "dst": "0.0.0.0/0" }
  #        ]
  #      }
  #    }
  #  path: /etc/cni/net.d/10-mynet.conf

  # - content: |
  #     {
  #     "cniVersion": "0.4.0",
  #     "name": "containerd-net",
  #     "plugins": [
  #       {
  #         "type": "bridge",
  #         "bridge": "cni0",
  #         "isGateway": true,
  #         "ipMasq": true,
  #         "promiscMode": false,
  #         "hairpinMode": true,
  #         "ipam": {
  #           "type": "host-local",
  #           "subnet": "10.88.0.0/16",
  #           "routes": [
  #             { "dst": "0.0.0.0/0" }
  #           ]
  #         }
  #       },
  #       {
  #         "type": "portmap",
  #         "capabilities": {"portMappings": true}
  #       }
  #     ]
  #   path: /etc/cni/net.d/10-mynet.conf
  
  #- content: |
  #    {
  #      "cniVersion": "0.2.0",
  #      "name": "lo",
  #      "type": "loopback"
  #    }
  #  path: /etc/cni/net.d/99-loopback.conf

  # Docker daemon OK
  #- content: |
  #      {
  #        "exec-opts": ["native.cgroupdriver=systemd"],
  #        "live-restore": true,
  #        "log-driver": "json-file",
  #        "log-opts": {
  #          "max-size": "10m",
  #          "max-file": "5"
  #        },
  #        "storage-driver": "overlay2"
  #      }
  #  path: /etc/docker/daemon.json

# These commands will be ran once on first boot only
runcmd:
  # Enable cgroups limit support
  # Append the cgroups and swap options to the kernel command line
  # Note the space before "cgroup_enable=cpuset", to add a space after the last existing item on the line
  #- sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/' /boot/cmdline.txt

  # Add nodes to /etc/hosts CAUTION
  - echo -e "10.0.0.1 master\n10.0.0.2 node1\n10.0.0.3 node2\n10.0.0.4 node3" | tee -a /etc/cloud/templates/hosts.debian.tmpl

  # Pickup the hostname changes OK
  - [systemctl, restart, avahi-daemon]

  # Ensure dhcpcd service is disabled to avoid duplicate default route OK
  - [systemctl, disable, dhcpcd]

  # Configure PKI for user
  #- echo CLUSTER_SSH_PRIVATE_KEY | tr -d '\r' > /home/${CLUSTER_MEMBER}/.ssh/id_rsa && chmod 600 /home/${CLUSTER_MEMBER}/.ssh/id_rsa
  #- echo ${CLUSTER_SSH_PUBLIC_KEY} > /home/${CLUSTER_MEMBER}/.ssh/id_rsa.pub && chmod 644 /home/${CLUSTER_MEMBER}/.ssh/id_rsa.pub

  # NAT option 1 -> iptables
  - iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
  - iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
  - iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

  # NAT option 2 -> firewalld
  # - firewall-cmd --add-service=dhcp --permanent
  # - firewall-cmd --add-masquerade --permanent
  # - firewall-cmd reload

  # Activate WiFi interface
  - ifup wlan0

  # Allow iptables to see bridged traffic
  #- modprobe br_netfilter
  #- sysctl --quiet --system

  # Intall packages
  #- apt-get update
  #- DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
  #- DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -yq
  #- DEBIAN_FRONTEND=noninteractive apt-get autoclean -yq
  #- DEBIAN_FRONTEND=noninteractive apt-get autoremove -yq
  #- DEBIAN_FRONTEND=noninteractive apt-get install -yq ipset iptables arptables ebtables apt-transport-https nfs-common
  #- DEBIAN_FRONTEND=noninteractive apt-get install -y ntp vim curl, gnupg2, kubelet, kubeadm, kubectl, isc-dhcp-server
  
  # Keep kube* packages version
  #- apt-mark hold kubelet kubeadm kubectl

  # Update eeprom
  #- rpi-eeprom-update -a

  # Ensure swapfile is disabled
  #- dphys-swapfile uninstall && update-rc.d dphys-swapfile remove
  # Debian only
  #- systemctl disable dphys-swapfile
  # This should now show no entries
  # sudo swapon --summary

  # Install CNI plugins
  ####### - mkdir -p /opt/cni/bin
  ####### - wget https://github.com/containernetworking/plugins/releases/download/v${cni_plugins_version}/cni-plugins-linux-amd64-v${cni_plugins_version}.tgz -O cni.tgz \
  ####### - tar -C /opt/cni/bin -xf cni.tgz \
  ####### - rm cni.tgz

  # Init cluster
  ####### - kubeadm init --config /etc/kubernetes/kubeadm.config.yaml  --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address 10.0.0.1 --apiserver-cert-extra-sans kubernetes.cluster.home --token-ttl 0 --token ${TOKEN} --node-name=$(hostname -f)
  ####### - mkdir -p /home/${CLUSTER_MEMBER}/.kube
  ####### - cp -i /etc/kubernetes/admin.conf /home/${CLUSTER_MEMBER}/.kube/config
  ####### - chown ${CLUSTER_MEMBER}:${CLUSTER_MEMBER} /home/${CLUSTER_MEMBER}/.kube/config
  ####### - export KUBECONFIG=/etc/kubernetes/admin.conf
  ####### - curl -s https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml -O
  ####### - sed -i -e "s?10.244.0.0/16?${pod_network_cidr}?g" kube-flannel.yml
  ####### - kubectl apply -f kube-flannel.yml
  ####### - kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.12/deploy/local-path-storage.yaml
  ####### - "kubectl patch storageclass local-path -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}'"

  # Init a swarm, because why not
  ####### - [docker, swarm, init ]

  # Run portainer, so we can see our logs and control stuff from a UI
  ####### - [
  #######     docker, service, create, 
  #######     "--detach=false", 
  #######     "--name", "portainer", 
  #######     "--publish", "9000:9000", 
  #######     "--mount", "type=volume,src=portainer_data,dst=/data", 
  #######     "--mount", "type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock", 
  #######     "portainer/portainer", "-H", "unix:///var/run/docker.sock", "--no-auth"
  #######   ]

  # Create a specific directory to store all the data, this way you could mount an external drive later (coming soon!)
  ####### - [mkdir, "-p", "/var/cloud/data" ]

  # This gives the nextcloud permissions to write to this directory since it runs as www-data
  ####### - [setfacl, "-m", "u:www-data:rwx", "/var/cloud/data" ]

  # Create the nextcloud instance configuring it on startup - you should change the user/password below to something less obvious or use the config UI
  ####### - [
  #######     docker, service, create, 
  #######     "--detach=false", 
  #######     "--name", "nextcloud", 
  #######     "--publish", "80:80", 
  #######     "--mount", "type=volume,src=nextcloud,dst=/var/www/html", 
  #######     "--mount", "type=bind,src=//var/cloud/data,dst=/var/www/html/data", 
  #######     "--env", "SQLITE_DATABASE=nextcloud", 
  #######     "--env", "NEXTCLOUD_ADMIN_USER=pirate", 
  #######     "--env", "NEXTCLOUD_ADMIN_PASSWORD=hypriot", 
  #######     "nextcloud:latest" 
  #######   ]

  - export UPTIME=`uptime -s`

final_message: "The system is finally up, after $UPTIME seconds"
