#!/bin/bash

#
# Arduino programming container example
#
# Be sure to change the MY_BOARD variable below to have the appropriate search
# string to find your board in the "arduino-cli board list" output.
#
# Written by Glen Darling, March 2020.
#

echo "*****  Arduino Programming Container Example"

# What board will be used?
MY_BOARD="Arduino Uno"
echo "*****  Board=${MY_BOARD}"

# Get the details for this board (i.e., for an "Arduino Uno")
#  - Port (serial) where your board is mounted is needed for uploading to it
#  - Fully Qualified Board name is needed to identify your board specifically
#  - Core is required so the appropriate support libraries can be included
# The code below extracts these from the "arduino-cli board list" output:
MY_PORT=`arduino-cli board list | grep "${MY_BOARD}" | head -1 | awk '{print $1;}' `
MY_FQBN=`arduino-cli board list | grep "${MY_BOARD}" | head -1 | awk '{print $(NF-1);}' `
MY_CORE=`arduino-cli board list | grep "${MY_BOARD}" | head -1 | awk '{print $(NF);}' `
echo "*****  FQBN=${MY_FQBN}, Port=${MY_PORT}, Core=${MY_CORE}"

echo "*****  Installing the \"core\" support code."
arduino-cli core install "${MY_CORE}"

# Loop forever, installing Blink, then Faster, then repeating
cd /code
while :; do
  echo "*****  Compiling Blink.."
  arduino-cli compile --fqbn "${MY_FQBN}" Blink
  echo "*****  Uploading Blink.."
  arduino-cli upload -p "${MY_PORT}" --fqbn "${MY_FQBN}" Blink
  echo "*****  Sleeping..."
  sleep 30;
  echo "*****  Compiling Faster.."
  arduino-cli compile --fqbn "${MY_FQBN}" Faster
  echo "*****  Uploading Faster.."
  arduino-cli upload -p "${MY_PORT}" --fqbn "${MY_FQBN}" Faster
  echo "*****  Sleeping..."
  sleep 30;
done

