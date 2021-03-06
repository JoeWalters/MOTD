
MOTD
==========================================
The abbreviation "motd" stands for "message of the day", and is displayed after a successful login but just before it executes the login shell.

The image below is an example of this message of the day.
![Screenshot](https://raw.githubusercontent.com/JoeWalters/IMG/master/MOTD.PNG)

How it works
-------
The motd.sh file in this repository should go in /etc/profile.d/. Ownership of root:root and 755 permissions will suffice.

The first two variables in this script should be verified/changed prior to using this script. Nothing else should have to be changed.
```
# Disk usage percentage to start warning. Numbers only.
MAX=90

# Is this system behind NAT? 1 = yes
NAT=1
```

* This disk warning message will only display if your disk usage exceeds an amount you set in the script (MAX variable)
* This script will list all interfaces with an IPV4 IP (Excluding loopback) along with your public IP (If NAT=1 in script)

License
-------
This work is licensed under the [GNU GPL v3](http://www.gnu.org/licenses/gpl.html).
