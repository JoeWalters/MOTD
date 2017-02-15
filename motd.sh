#!/bin/bash

# Disk usage percentage to start warning. Numbers only.
MAX=90

# Is this system behind NAT? 1 = yes
NAT=1

# Generate active NIC/IP combos
for i in $(ip -4 addr | grep "^[0-9]" | grep -v lo| awk '{ print $2}'); do IP="$i$(ip -4 a show $i| grep inet| awk '{ print $2 }' | sed 's/\/.*//') $IP"; if [ $NAT -eq 1 ]; then IP="$IP WAN:$(wget -q -O - http://icanhazip.com/)"; fi; done

# Calculating Uptime
upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

#Get CPU Temp
cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0/1000))
cpuTemp2=$(($cpuTemp0/100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))
cpuTemp=$cpuTemp1"."$cpuTempM"ºC"

# Get the load averages
read one five fifteen rest < /proc/loadavg

# RAM Info
RAM=$(free -m | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }')

echo "$(tput setaf 2)
 $(date +"%A, %e %B %Y, %r")
 $(uname -srmo)$(tput setaf 1)
    
 Hostname...........: $(hostname)
 Uptime.............: $UPTIME
 Memory.............: $RAM
 Load Averages......: $one, $five, $fifteen (1, 5, 15 min)
 IP Addresses.......: $IP
 CPU Temp...........: $cpuTemp
$(tput sgr0)"

# Check for disks above $MAX percent
for i in $(df -h | egrep "^/dev" | awk '{ print $6}'); do j=$(df -h $i | grep ^/dev | awk '{ print $5}' | sed 's/%//'); if [ $j -ge $MAX ]; then echo "$(tput setaf 1)Warning! $i is $j% full.
$(tput sgr0)"; fi; done


