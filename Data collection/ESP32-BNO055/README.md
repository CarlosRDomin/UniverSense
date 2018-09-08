# Shelf-hub (ESP32)
This repository contains everything related to our Arduino ESP32-based shelf-hub.

## Hardware
TODO: Add link/image of circuit diagram for:
 * LAN8720 (eth)
 * Accelerometer (I2C)

## Instructions

### Installing 3rd-party libraries
In order to make it easier to install all libraries, plugins and the Esp32 core, I added a Python script called `setup.py` (which uses `git submodule` to fetch the right version of each library). To make it easier to read the output of the script, it uses the `coloredlogs` library so messages are color-coded (there should be no red messages unless something went wrong ;P). The steps are:
  1. Open a Terminal console and install the helper Python libraries:
     ```sh
     pip install coloredlogs verboselogs
     ```
  2. Navigate to the root folder in this repo (_e.g._ `cd shelf-hub_esp32`)
  3. Execute the installation script:
     ```sh
     python setup.py -i
     ```
  **NOTE**: this would install the libraries and the board into the **default Arduino folder** (_e.g._ for Mac: `~/Documents/Arduino`). If your `Arduino` folder is somewhere else, specify such path as an argument to the Python script like this: `python setup.py -i -p <PATH>`

  **NOTE 2**: If you get an error like `IOError: [Errno socket error] [SSL: TLSV1_ALERT_PROTOCOL_VERSION] tlsv1 alert protocol version (_ssl.c:590)`, follow these steps:
   1. Install Miniconda2:
      1. Download the [installation script](https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh)
	  2. Execute it:
		 ```sh
		 bash Miniconda2-latest-MacOSX-x86_64.sh
		 ```
	  3. Prepend miniconda to your `PATH` on `~/.bash_profile` by adding the line: `export PATH="$HOME/miniconda2/bin:$PATH"`
	  4. Reopen the terminal (or open a new tab) so changes take place (_e.g._, `which python` should point to `$HOME/miniconda2/bin/python`)
   2. Try installing the 3rd-party libraries again (`python setup.py -i`)

### Installing the USB drivers
The Arduino ESP32 uses a CP210x chip instead of the more common FTDI. Therefore, the right drivers need to be installed in order for the board to show up when you plug it in through USB. Driver file (for Mac) is available under `Datasheets and useful info/CP210x drivers Mac.pkg` (for other platforms, download link is [here](https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers)). Simply double click and follow the on-screen instructions (might need to reboot).

### Flashing the firmware
 1. Open the file `shelf-hub_esp32.ino` in the Arduino IDE.
 2. Plug in the ESP32 through USB, select the right port on `Tools > Port` (_eg_: `/dev/cu.SLAB_USBtoUART`) and configure the board as:
    - Board: WEMOS LOLIN32
    - Partition scheme: Default
    - Flash frequency: 80MHz
    - Upload speed: 921600
 3. Upload the sketch (`Sketch > Upload`)

### Complying with gRPC protos
Unfortunately, I haven't been able to compile the gRPC libraries with the `xtensa-esp32-elf-g++` compiler. For now, the approach is to use NanoPB to comply with the sensing proto-contracts, and rely on a middleware server to parse and forward the data to a gRPC call.

This middleware server is implemented in `go` at `../mod-hub_server/server.go`. It starts a TCP server which waits for clients (shelf-hubs) to connect. Once a client is connected, it opens a gRPC call to the sensor-router and begins to forward any data coming from the ESP32. Since we are using NanoPB to serialize sensor data, the message format between the ESP32 and the mod-hub server is really simple: the first 2 Bytes determine the nanopb buffer length, _L_, and then exactly _L_ Bytes are read, parsed and forwarded to the sensor-router. To run the middleware server, `cd` to `../mod-hub_server` and run:
```sh
go run server.go --grpcAddr <address of sensor-router>
```

Also note that currently, the middleware server's IP needs to be hardcoded in the ESP32 (we should soon allow config updates over ethernet to overcome this). This means that until then, the firmware needs to be reflashed every time the server's IP changes :(
