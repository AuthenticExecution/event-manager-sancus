# event-manager-sancus
Docker image to deploy the Sancus Event Manager

## Event Manager code

The EM is not maintained anymore, as it was developed for an outdated version of [sancus-riot](https://github.com/sancus-tee/sancus-riot). However, the source code is provided [here](sancus-em.zip) so that it can be (partially) reused by other developers. This code is licensed as MIT.

## How to run the Event manager

### Flash the correct image on a Sancus node

[How to flash a Sancus image](https://github.com/sancus-tee/sancus-main#xstools-installation).

- `2022-03_sancus-128-8mhz.mcs` is the Sancus image with 128 bits of security, running at 8MHz
    - Node key: `deadbeefcafebabec0defeeddefec8ed`
    - Vendor key (if ID == 0x1234 (4660)): `0b7bf3ae40880a8be430d0da34fb76f0`

### Load the EM application

The docker image takes care to automatically upload the EM application on the Sancus node. Check out the [Makefile](Makefile) and [run.sh](run.sh) for more details.

- Three different ELF files are provided:
    - `reactive.elf` is the latest event manager, with no embedded SMs.
    - `reactive_debug.elf` is the same application, but with more verbose prints so it can be used for debugging purposes
    - `reactive_led.elf` also embeds two SMs (`pmodled` and `led_driver`) for establishing Secure I/O on an LED connected to the Sancus node
        - `led_driver` module key: `2fad83949557b707c1bcedd0a8084ef2` (with the default node and vendor keys)

## Useful commands

### Get vendor key of a node

```bash
sancus-crypto --gen-vendor-key <vendor_id_hex> --key <node_key>
```

### Get module key of an SM

```bash
sancus-crypto <elf_file> --gen-sm-key <module_name> --key <vendor_key>
```

### Check symbols of an SM

```bash
readelf -s --wide reactive.elf | grep <name>
```

- This is particularly useful to check the IDs of outputs/inputs of SMs embedded in the ELF (such as `led_driver`)