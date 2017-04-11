# Function 3 Framework

## Overview

The function 3 has its own keypad processor, GPU and RAM. It will use an port of the graphics ROM.

## Framework
![Function 3 Framework](Function_3_Framework.png)

## Component Chips
The total container is contructed by three chips: key processor, GPU, the pixel mapper and its own RAM. The major chips of the function 3 is its GPU.

### Key Processor
The same as function 2. Translate the button pressed state or its combination to the instructions.

### GPU
This is the main part of the whole container. The missions of the GPU is the following:

1. Identify the instruction.
2. Check the scramble state,
3. If scramble is off, change the cursor position;
4. Or else, change the offset of the image in the RAM.
5. When the RAM send the complete signal, all the instruction won't be executed until the restart game signal meets an negedge.

All the realization could be found at the `f3_gpu.v` file.

### RAM
The memory will save the offset of each row and column. When all the data is 0, it will automatically sends a complete signal. 

[Back to Home](Home.md)