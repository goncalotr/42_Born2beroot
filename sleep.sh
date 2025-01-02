#!/bin/bash
# Line above specifies the interpreter that will execute the script

# Get boot time minutes and seconds
BOOT_MIN=$(uptime -s | cut -d ":" -f 2)
BOOT_SEC=$(uptime -s | cut -d ":" -f 3)

# Calculate number of seconds between the nearest 10th minute of the hour and boot time:
# BOOT_MIN % 10 -> Remainder of division by 10
# multiply by 60 to convert to seconds
# -
# bc stands for "Basic Calculator" (or "Bench Calculator").
# It's a command-line utility in Unix-like systems that provides arbitrary-precision arithmetic.
DELAY=$(bc <<< $BOOT_MIN%10*60+$BOOT_SEC)
#DELAY=$((BOOT_MIN % 10 * 60 + BOOT_SEC))
#echo "Calculated DELAY: $DELAY"

# Wait that number of seconds
#echo "before sleep"
sleep $DELAY
#echo "after sleep"
