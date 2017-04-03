# Framework
The framework of this realization looks like the Docker, and that is exactly what the idea comes from. The container-style framework.

![Framework Image](https://rawgithub.com/Harinlen/FPGA_VGA/master/doc/Framework.svg)

## Container Manager.

Each function will be treated as a container. Each container will has its own keypad processor, memory and graphics processor. Some functions will embedded graphics processor into keypad processor because it is too simple.

A switcher keypad will be directly connect to container manager to swithch the function. This is the realization for function 4.

## Function 1

The keypad processor will translate the R, G, B into the color directly, which is the case that embedded the graphics processor into the keypad processor. It will directly write the color to the video RAM, and the container will directly access the color in the RAM.

Because the requirement is quite simple, over design might affect the effeciency.

## Function 2

The keypad processor will translate the button into instruction. The instruction matching map is written in the keypad source file as a part of comments.

The graphics processor will process the image according to the instruction provided by the keypad processor. The image data will get from the Image ROM which is shared with the GPU of function 3. The GPU of function 2 will be responsed to output the image data to the container manager.

[Back to Home](Home.md)