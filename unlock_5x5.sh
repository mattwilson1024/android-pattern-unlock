#!/bin/sh
#
# Android pattern unlock
# Author: Matt Wilson 
# Modified: einsiedlerkrebs
# Licence: Free to use and share. If this helps you please buy me a beer :)
#
# This script sends simulated touch input over ADB for remotely swiping on Android's pattern lockscreen.
# This allows you to unlock the device even if the touch screen is broken.
#
# Note: You must have USB debugging enabled on your device for this script to work (in the developer options).
# This script will not work unless this option is enabled. I recommend turning it on to make life easier if you drop your phone.
# Note: The device does not need to be rooted for this method to work.
#
# You need to have adb on your PATH to run this script.
# E.g. on Mac add to ~/.bash_profile: export PATH="/Users/username/Library/Android/sdk/platform-tools:$PATH"
#
# Customise the variables in the top section of the script with your phone's unlock code and coordinates
#
# Usage:
# chmod +x unlock_5x5.sh
# ./unlock_5x5.sh

# =======================================================================================================================

# Variables
#
# Coordinates will vary depending on the screen resolution of your device (defaults are for Nexus 4 at 768x1280)
# The pattern should be set based on the following layout:

#  1   2   3   4   5

#  6   7   8   9  10

# 11  12  13  14  15

# 16  17  18  19  20

# 21  22  23  24  25

PATTERN="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25" # The unlock pattern to draw, space seperated

COL_1=138                   # X coordinate of column 1 (in pixels)
COL_2=260                   # X coordinate of column 2 (in pixels)
COL_3=382                   # X coordinate of column 3 (in pixels)
COL_4=502                   # X coordinate of column 4 (in pixels)
COL_5=626                   # X coordinate of column 5 (in pixels)

ROW_1=502                   # Y coordinate of row 1 (in pixels)
ROW_2=626                   # Y coordinate of row 2 (in pixels)
ROW_3=748                   # Y coordinate of row 3 (in pixels)
ROW_4=870                   # Y coordinate of row 4 (in pixels)
ROW_5=992                   # Y coordinate of row 5 (in pixels)


MULTIPLIER=2                # Multiplication factor for coordinates. For Nexus 4, set this to 2. For low res phones such as
                            # Samsung Galaxy S2, set this to 1. Experiment with this value if you can't see anything happening.

WAKE_SCREEN_ENABLED=true    # If true, the script will start by sending the power button press event

SWIPE_UP_ENABLED=false       # If true, the script will swipe upwards before drawing the pattern (e.g. for lollipop lockscreen)
SWIPE_UP_X=450              # X coordinate for initial upward swipe. Only used if SWIPE_UP_ENABLED is true
SWIPE_UP_Y_FROM=1000        # Start Y coordinate for initial upward swipe. Only used if SWIPE_UP_ENABLED is true
SWIPE_UP_Y_TO=200           # End Y coordinate for initial upward swipe. Only used if SWIPE_UP_ENABLED is true

# =======================================================================================================================

# Define X&Y coordinates for each of the 25 positions.

X[1]=$(( ${COL_1} * ${MULTIPLIER} ))
X[2]=$(( ${COL_2} * ${MULTIPLIER} ))
X[3]=$(( ${COL_3} * ${MULTIPLIER} ))
X[4]=$(( ${COL_4} * ${MULTIPLIER} ))
X[5]=$(( ${COL_5} * ${MULTIPLIER} ))
X[6]=$(( ${COL_1} * ${MULTIPLIER} ))
X[7]=$(( ${COL_2} * ${MULTIPLIER} ))
X[8]=$(( ${COL_3} * ${MULTIPLIER} ))
X[9]=$(( ${COL_4} * ${MULTIPLIER} ))
X[10]=$(( ${COL_5} * ${MULTIPLIER} ))
X[11]=$(( ${COL_1} * ${MULTIPLIER} ))
X[12]=$(( ${COL_2} * ${MULTIPLIER} ))
X[13]=$(( ${COL_3} * ${MULTIPLIER} ))
X[14]=$(( ${COL_4} * ${MULTIPLIER} ))
X[15]=$(( ${COL_5} * ${MULTIPLIER} ))
X[16]=$(( ${COL_1} * ${MULTIPLIER} ))
X[17]=$(( ${COL_2} * ${MULTIPLIER} ))
X[18]=$(( ${COL_3} * ${MULTIPLIER} ))
X[19]=$(( ${COL_4} * ${MULTIPLIER} ))
X[20]=$(( ${COL_5} * ${MULTIPLIER} ))
X[21]=$(( ${COL_1} * ${MULTIPLIER} ))
X[22]=$(( ${COL_2} * ${MULTIPLIER} ))
X[23]=$(( ${COL_3} * ${MULTIPLIER} ))
X[24]=$(( ${COL_4} * ${MULTIPLIER} ))
X[25]=$(( ${COL_5} * ${MULTIPLIER} ))

Y[1]=$(( ${ROW_1} * ${MULTIPLIER} ))
Y[2]=$(( ${ROW_1} * ${MULTIPLIER} ))
Y[3]=$(( ${ROW_1} * ${MULTIPLIER} ))
Y[4]=$(( ${ROW_1} * ${MULTIPLIER} ))
Y[5]=$(( ${ROW_1} * ${MULTIPLIER} ))
Y[6]=$(( ${ROW_2} * ${MULTIPLIER} ))
Y[7]=$(( ${ROW_2} * ${MULTIPLIER} ))
Y[8]=$(( ${ROW_2} * ${MULTIPLIER} ))
Y[9]=$(( ${ROW_2} * ${MULTIPLIER} ))
Y[10]=$(( ${ROW_2} * ${MULTIPLIER} ))
Y[11]=$(( ${ROW_3} * ${MULTIPLIER} ))
Y[12]=$(( ${ROW_3} * ${MULTIPLIER} ))
Y[13]=$(( ${ROW_3} * ${MULTIPLIER} ))
Y[14]=$(( ${ROW_3} * ${MULTIPLIER} ))
Y[15]=$(( ${ROW_3} * ${MULTIPLIER} ))
Y[16]=$(( ${ROW_4} * ${MULTIPLIER} ))
Y[17]=$(( ${ROW_4} * ${MULTIPLIER} ))
Y[18]=$(( ${ROW_4} * ${MULTIPLIER} ))
Y[19]=$(( ${ROW_4} * ${MULTIPLIER} ))
Y[20]=$(( ${ROW_4} * ${MULTIPLIER} ))
Y[21]=$(( ${ROW_5} * ${MULTIPLIER} ))
Y[22]=$(( ${ROW_5} * ${MULTIPLIER} ))
Y[23]=$(( ${ROW_5} * ${MULTIPLIER} ))
Y[24]=$(( ${ROW_5} * ${MULTIPLIER} ))
Y[25]=$(( ${ROW_5} * ${MULTIPLIER} ))

# Function definitions

WakeScreen() {
	if [ "$WAKE_SCREEN_ENABLED" = true ]; then
		adb shell input keyevent 26
	fi
}

SwipeUp() {
	if [ "$SWIPE_UP_ENABLED" = true ]; then
		adb shell input swipe ${SWIPE_UP_X} ${SWIPE_UP_Y_FROM} ${SWIPE_UP_X} ${SWIPE_UP_Y_TO}
	fi
}

StartTouch() {
	adb shell sendevent /dev/input/event2 3 57 14
}

SendCoordinates () {
	adb shell sendevent /dev/input/event2 3 53 $1
	adb shell sendevent /dev/input/event2 3 54 $2
	adb shell sendevent /dev/input/event2 3 58 57
	adb shell sendevent /dev/input/event2 0 0 0
}

FinishTouch() {
	adb shell sendevent /dev/input/event2 3 57 4294967295
	adb shell sendevent /dev/input/event2 0 0 0
}

SwipePattern() {
	for NUM in $PATTERN
	do
	   echo "Sending $NUM: ${X[$NUM]}, ${Y[$NUM]}"
	   SendCoordinates ${X[$NUM]} ${Y[$NUM]}
	done
}

# Actions

WakeScreen
SwipeUp
StartTouch
SwipePattern
FinishTouch
