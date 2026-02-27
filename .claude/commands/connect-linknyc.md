Connect to the LinkNYC Free Wi-Fi network.

Steps:
1. Rescan for available WiFi networks using `nmcli device wifi rescan`
2. Attempt to connect with `nmcli device wifi connect "LinkNYC Free Wi-Fi"`
3. If the connection fails (SSID not found), run `nmcli device wifi list | grep -i link` to check if any LinkNYC networks are visible
4. If no LinkNYC networks are visible, inform the user they may be out of range of a LinkNYC kiosk
5. If connection succeeds, remind the user to open a browser to accept the captive portal terms if needed
