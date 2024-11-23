#!/bin/bash


find_wifi_interface() {
    local interface
    interface=$(nmcli device status | awk '$2 == "wifi" {print $1}')

    if [ -n "$interface" ]; then
        echo "Wi-Fi interface found: $interface"
        WIFI_INTERFACE="$interface"
    else
        echo "No Wi-Fi interface found. Exiting."
        exit 1
    fi
}

enable_wifi_interface() {
    if [ "$(nmcli device status | awk -v iface="$WIFI_INTERFACE" '$1 == iface {print $3}')" != "connected" ]; then
        echo "Enabling Wi-Fi interface..."
        nmcli device connect "$WIFI_INTERFACE"
    else
        echo "Wi-Fi interface is already enabled."
    fi
}


list_wifi() {
   if [ -z "$WIFI_INTERFACE" ]; then
        echo "No Wi-Fi interface found. Exiting."
        exit 1
    fi

    echo "Scanning for available Wi-Fi networks..."
   
    mapfile -t wifi_networks < <(nmcli --fields SSID device wifi list ifname "$WIFI_INTERFACE" | tail -n +2 | awk '$1 != "--" && $1 != "" {print $1}' | sort | uniq)

    if [ "${#wifi_networks[@]}" -eq 0 ]; then
        echo "No Wi-Fi networks found."
        exit 1
    fi

    echo "Available Wi-Fi networks:"
    for i in "${!wifi_networks[@]}"; do
        echo "[$((i+1))] ${wifi_networks[$i]}"
    done

    local selection
    read -p "Select the Wi-Fi network number: " selection

    if [[ "$selection" -gt 0 && "$selection" -le "${#wifi_networks[@]}" ]]; then
        SELECTED_WIFI="${wifi_networks[$((selection - 1))]}"
        SSID="$SELECTED_WIFI"
        echo "Selected Wi-Fi: $SSID"
    else
        echo "Invalid selection. Exiting."
        exit 1
    fi
}



connect_to_wifi() {
    local ssid="$1"
    echo "Connecting to Wi-Fi network: $ssid"

   
    read -sp "Enter the Wi-Fi password for $ssid: " wifi_password
    echo

    nmcli device wifi connect "$ssid" password "$wifi_password" ifname "$WIFI_INTERFACE"

    if [ $? -eq 0 ]; then
        echo "Successfully connected to $ssid."
    else
        echo "Failed to connect to $ssid. Please check your password or try again."
        exit 1
    fi
}





if command -v nmcli &> /dev/null
then
    echo "nmcli found, proceeding with Wi-Fi connection setup..."
    find_wifi_interface
    enable_wifi_interface
    list_wifi
    connect_to_wifi "$SELECTED_WIFI"
else
    echo "nmcli not found, proceeding with iwconfig..."
fi
