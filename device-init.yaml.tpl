# vim: syntax=yaml
# optional wireless network settings
# To make wifi work with RPi3 and RPi0
# you also have to set "enable_uart=0" in config.txt
# See no-uart-config.txt for an example.
wifi:
  interfaces:
    wlan0:
      ssid: ${SSID}
      password: ${WIFI_PASSWORD}
