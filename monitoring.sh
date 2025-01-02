#!/bin/bash

# --- System Information Gathering ---

# Get the system architecture information.
# uname: prints system information
#   -s: kernel name
#   -r: kernel release
#   -v: kernel version
#   -m: machine hardware name
#   -o: operating system
ARCH=$(uname -srvmo)

# Count the number of unique physical CPU IDs.
# grep: searches for lines containing a pattern
#   'physical id': the pattern to search for in /proc/cpuinfo
# /proc/cpuinfo: a file containing CPU information
# uniq: filters out repeated lines (we only want unique physical IDs)
# wc: counts words, lines, or characters
#   -l: count lines
PCPU=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)

# Count the number of virtual (logical) processors.
# grep: searches for lines containing a pattern
#   'processor': the pattern to search for in /proc/cpuinfo
# /proc/cpuinfo: a file containing CPU information
# uniq: filters out repeated lines (although processor IDs are usually unique)
# wc: counts words, lines, or characters
#   -l: count lines
VCPU=$(grep 'processor' /proc/cpuinfo | uniq | wc -l)

# Get total RAM in human-readable format (e.g., GiB).
# free: displays information about memory usage
#   -h: output in human-readable format
# grep: searches for lines containing a pattern
#   'Mem': the pattern to search for (the line containing memory information)
# awk: a pattern scanning and processing language
#   '{print $2}': prints the second field (total memory)
RAM_TOTAL=$(free -h | grep 'Mem' | awk '{print $2}')

# Get used RAM in human-readable format.
# free: displays information about memory usage
#   -h: output in human-readable format
# grep: searches for lines containing a pattern
#   'Mem': the pattern to search for (the line containing memory information)
# awk: a pattern scanning and processing language
#   '{print $3}': prints the third field (used memory)
RAM_USED=$(free -h | grep 'Mem' | awk '{print $3}')

# Calculate the percentage of RAM used.
# free: displays information about memory usage
#   -k: output in kilobytes (for more precise percentage calculation)
# grep: searches for lines containing a pattern
#   'Mem': the pattern to search for (the line containing memory information)
# awk: a pattern scanning and processing language
#   '{printf("%.2f%%"), $3 / $2 * 100}': calculates and formats the percentage
#     $3: used memory (third field)
#     $2: total memory (second field)
#     * 100: multiply by 100 to get the percentage
#     printf("%.2f%%"): formats the output to two decimal places followed by a percentage sign
RAM_PERC=$(free -k | grep 'Mem' | awk '{printf("%.2f%%"), $3 / $2 * 100}')

# Get total disk space in human-readable format.
# df: reports file system disk space usage
#   -h: print sizes in human-readable format (e.g., 1K, 234M, 2G)
#   --total: produce a grand total
# grep: searches for lines containing a pattern
#   'total': the pattern to search for (the line containing total disk space)
# awk: a pattern scanning and processing language
#   '{print $2}': prints the second field (total disk space)
DISK_TOTAL=$(df -h --total | grep 'total' | awk '{print $2}')

# Get used disk space in human-readable format.
# df: reports file system disk space usage
#   -h: print sizes in human-readable format
#   --total: produce a grand total
# grep: searches for lines containing a pattern
#   'total': the pattern to search for (the line containing total disk space)
# awk: a pattern scanning and processing language
#   '{print $3}': prints the third field (used disk space)
DISK_USED=$(df -h --total | grep 'total' | awk '{print $3}')

# Get the percentage of disk space used.
# df: reports file system disk space usage
#   -k: print sizes in 1K blocks
#   --total: produce a grand total
# grep: searches for lines containing a pattern
#   'total': the pattern to search for (the line containing total disk space)
# awk: a pattern scanning and processing language
#   '{print $5}': prints the fifth field (percentage of disk space used)
DISK_PERC=$(df -k --total | grep 'total' | awk '{print $5}')

# Calculate the CPU load average (user + system time).
# top: displays dynamic real-time view of running processes
#   -b: batch mode (non-interactive)
#   -n1: update only once and then exit
# grep: searches for lines containing a pattern
#   '^%Cpu': the pattern to search for (lines starting with '%Cpu')
# xargs: builds and executes command lines from standard input
# awk: a pattern scanning and processing language
#   '{printf("%.1f%%"), $2 + $4}': calculates and formats the CPU load
#     $2: user CPU time (second field)
#     $4: system CPU time (fourth field)
#     $2 + $4: sum of user and system CPU time
#     printf("%.1f%%"): formats the output to one decimal place followed by a percentage sign
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')

# Get the date and time of the last system boot.
# who: shows who is logged in
#   -b: time of last system boot
# awk: a pattern scanning and processing language
#   '{print($3 " " $4)}': prints the third and fourth fields (date and time)
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')

# Check if Logical Volume Management (LVM) is in use.
# lsblk: lists block devices
# grep: searches for lines containing a pattern
#   'lvm': the pattern to search for (lines containing 'lvm' indicate LVM usage)
# wc: counts words, lines, or characters
#   -l: count lines
# -eq: shell comparison operator, equal to
# if [ ... -eq 0 ]; then ... else ... fi: conditional statement in shell script
LVM=$(if [ $(lsblk | grep 'lvm' | wc -l) -eq 0 ]; then echo 'no'; else echo 'yes'; fi)

# Get the number of established TCP connections.
# /proc/net/sockstat: a file containing socket statistics
# grep: searches for lines containing a pattern
#   'TCP': the pattern to search for (lines related to TCP)
# awk: a pattern scanning and processing language
#   '{print $3}': prints the third field (number of established TCP connections)
TCP=$(grep 'TCP' /proc/net/sockstat | awk '{print $3}')

# Count the number of currently logged-in users.
# who: shows who is logged in
# wc: counts words, lines, or characters
#   -l: count lines
USER_LOG=$(who | wc -l)

# Get the primary IP address of the system.
# hostname: shows or sets the system's host name
#   -I: all network addresses of the host
# awk: a pattern scanning and processing language
#   '{print $1}': prints the first field (the first IP address)
IP_ADDR=$(hostname -I | awk '{print $1}')

# Get the MAC address of the primary network interface.
# ip: shows or manipulates routing, devices, policy routing, and tunnels
#   link show: display link status
# grep: searches for lines containing a pattern
#   'link/ether': the pattern to search for (lines containing MAC addresses)
# awk: a pattern scanning and processing language
#   '{print $2}': prints the second field (the MAC address)
MAC_ADDR=$(ip link show | grep 'link/ether' | awk '{print $2}')

# Count the number of sudo commands executed.
# /var/log/sudo/sudo.log: a log file containing sudo command history
# grep: searches for lines containing a pattern
#   'COMMAND': the pattern to search for (lines indicating executed commands)
# wc: counts words, lines, or characters
#   -l: count lines
SUDO_LOG=$(grep 'COMMAND' /var/log/sudo/sudo.log | wc -l)

# --- Output to All Logged-In Users (wall) ---

# Display the gathered system information using the 'wall' command.
# wall: sends a message to all currently logged-in users
wall "
       Architecture    : $ARCH
       Physical CPUs   : $PCPU
       Virtual CPUs    : $VCPU
       Memory Usage    : $RAM_USED/$RAM_TOTAL ($RAM_PERC)
       Disk Usage      : $DISK_USED/$DISK_TOTAL ($DISK_PERC)
       CPU Load        : $CPU_LOAD
       Last Boot       : $LAST_BOOT
       LVM use         : $LVM
       TCP Connections : $TCP established
       Users logged    : $USER_LOG
       Network         : $IP_ADDR ($MAC_ADDR)
       Sudo            : $SUDO_LOG commands used"
