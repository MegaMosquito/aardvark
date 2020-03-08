FROM ubuntu:bionic

# This example uses the Arduino CLI, which is well documented here:
#    https://arduino.github.io/arduino-cli/

# Install curl
RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*

# Install the Arduino CLI
RUN mkdir /arduino
WORKDIR /arduino
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
RUN mv /arduino/bin/arduino-cli /bin
WORKDIR /
RUN rmdir /arduino/bin
RUN rmdir /arduino
# Validate the install
RUN arduino-cli version

# Scan for attached boards, show list of attached boards
RUN arduino-cli core update-index
RUN arduino-cli board list
# My Uno board looks like this in that list:
#   Port         Type              Board Name  FQBN            Core       
#   /dev/ttyACM0 Serial Port (USB) Arduino Uno arduino:avr:uno arduino:avr
# Notes:
#   - 1st column is serial Port for this board (e.g.: "/dev/ttyACM0")
#   - 4th column is Fully Qualified Board Name (FQBN) (e.g.: "arduino:avr:uno")
#   - 5th column is board Core (e.g.: "arduino:avr")
#   - the example.sh code parses these out of that line for you
# You will need to:
#   1. install the core for your board, e.g.:
#        arduino-cli core install arduino.avr
#        arduino-cli core update-index
#      validate with:
#        arduino-cli core list
#   2. Put your .ino file in a directory by itself
#        $  Blink
#        Blink.ino
#        $ 
#   3. compile the code for this FQBN, by passing the source directory, e.g.:
#        arduino-cli compile --fqbn arduino:avr:uno Blink
#      validate (should see 3 generated files beside your .ino file):
#        $  ls -1 Blink
#        Blink.arduino.avr.uno.elf
#        Blink.arduino.avr.uno.hex
#        Blink.arduino.avr.uno.with_bootloader.hex
#        Blink.ino
#        $ 
#   4. upload the code to this port and FQBN, passing the same directory, e.g.:
#        arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno Blink

# Copy the Blink sketch
WORKDIR /code
RUN mkdir -p /code/Blink
COPY sketches/Blink.ino /code/Blink
RUN mkdir -p /code/Faster
COPY sketches/Faster.ino /code/Faster

# Copy the example reprogrammer code and run it as the default CMD
# It repeatedly programs the Uno with the Blink.ino code, then reprograms it
# with the Faster.ino code, and repeats (pausing between each of these steps).
WORKDIR /code
COPY example.sh /code
CMD ./example.sh

