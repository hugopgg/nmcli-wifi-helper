# nmcli-wifi-helper

- ##### Author:

  Hugo Perreault Gravel

- ##### Description:
A Bash utility to connect to Wi-Fi networks directly from the command line using nmcli. It lists available networks, prompts for selection, and handles connection details—all without a graphical interface.

## Prerequisites

- nmcli (NetworkManager Command Line Interface)

## Usage

Usage:

Make the script executable:

```
chmod +x wific.sh
```
To use as a command from anywhere, move/copy it to /usr/local/bin:
```
sudo mv wific.sh /usr/local/bin/wific
```
or:

```
sudo cp wific.sh /usr/local/bin/wific
```

Now you can connect to Wi-Fi with:
```
wific
```

