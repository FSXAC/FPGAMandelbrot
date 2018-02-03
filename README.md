## Mandelbrot Set

The Mandelbrot set produces a fractal and is a set of complex numbers for which a [particular function](https://en.wikipedia.org/wiki/Mandelbrot_set) does not converge for some iterations.

![fractal](https://raw.githubusercontent.com/FSXAC/FPGAMandelbrot/master/docs/hslcolored.JPG)

## FPGA

This project is made on the FPGA development board DE1-SoC; Written in SystemVerilog; compiled and tested in Quartus 17 and ModelSim.

### VGA Core

The VGA core is from University of Toronto, source is [here](http://www.eecg.utoronto.ca/~jayar/ece241_07F/vga/). The VGA core supports either 160x120 or 320x240.

For this project, I went with 320x240 (although I have compiler directives for using 160x120). Because of the higher resolution, colors are only limited to 3 bits or 8 different colors.

## Requirements

DE1-SoC FPGA development board, compiler and toolchains for synthesizing SystemVerilog, and a VGA compatible monitor with cables.

## Usage

### Compile and Load

- Create new project in Quartus New Project Wizard and add all the non testbench Verilog files
- Select hardware `5CSEMA5F31C6N`
- Import pin assignmnet from `DE1-SoC.qsf`
- Compile
- Load the bitstream `output_files/top_module.sof` to FPGA via programmer

### Interactions

The leftmost pushbutton (`KEY[3]`) is used for reset. Push this to refresh the screen.

There are 3 switches to control the zoom, 3 switches to control horizontal offset, and 3 switches to control the vertical offset. SW2 to SW0 controls the zoom. SW5 to SW3 controls horizontal offset. And SW8 to SW6 controls the vertical offset.

The mapping of the switches are as follows:

| Switches | Zoom          | H. Offset | V. Offset |
| -------- | ------------- | --------- | --------- |
| 000      | 10 (1x)       | +3.5      | +2        |
| 001      | 4 (2.5x)      | +2.75     | +1.5      |
| 010      | 2 (5x)        | +2        | +1        |
| 011      | 1 (10x)       | +1.5      | +0.5      |
| 100      | 0.75 (13.3x)  | +1        | **0**     |
| 101      | 0.5 (20x)     | +0.25     | -0.5      |
| 110      | 0.325 (30.8x) | **0**     | -1        |
| 111      | 0.25 (40x)    | -0.5      | -1.5      |

Have fun.

## Sample

Here are some photos of the monitor (because I don't know how to capture directly from hardware ;_;). The following is the fractal centered around (0, 0) with zoom level set to 2.5x.

![1](https://raw.githubusercontent.com/FSXAC/FPGAMandelbrot/master/docs/0.jpg)

Zoomed out

![2](https://raw.githubusercontent.com/FSXAC/FPGAMandelbrot/master/docs/1.jpg)

And zoomed in centered at (-2.75, 0) with a zoom level of 40x.

![3](https://raw.githubusercontent.com/FSXAC/FPGAMandelbrot/master/docs/2.jpg)