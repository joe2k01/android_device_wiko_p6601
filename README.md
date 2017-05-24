# BLU R1HD (p6601)


Device tree of BLU R1 HD (p6601), for building LineageOS 14.1.

# Building

Before building, apply necessary patches by running `./patch.sh` included in the device tree. Don't worry, you can invoke the script with `-R` after building to reverse the patches, keeping your tree clean for other devices.

# Facts

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Quad-core 1.3 GHz Cortex-A53 MT6735
GPU     | Mali-T720
Memory  | 1GB RAM or 2GB RAM
Shipped | Android OS, v6.0 (Marshmallow)
Storage | 8GB or 16GB
Battery | 2500 mAh
Display | 5" 1280 x 720 px
Camera  | 8 MP, f/2.0, autofocus, LED flash

# Acknowledgments

This is based off of the following people's work:

- [olegsvs](https://github.com/olegsvs)
- [DeckerSU](https://github.com/DeckerSU)
- [vampirefo](https://github.com/vampirefo)
- [jianC](https://github.com/jianC)
