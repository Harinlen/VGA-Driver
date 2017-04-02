module vgadriver(
//Switcher button
input wire change_button,
//Function 1 input
input wire R, 
input wire G, 
input wire B,
input wire set,
//Function 2 input,
input wire East,
input wire West,
input wire North,
input wire South,
//System clock
input wire sysclk,
//VGA outputs
output wire VGA_R,
output wire VGA_G,
output wire VGA_B,
output wire VGA_HS,
output wire VGA_VS);

// Container for Function 1
// Wires
wire [2:0] f1_keyproc_color, f1_vram_read_color;
wire f1_keyproc_write;
// Container for Function 2
// Wires
wire [2:0] f2_instruction, f2_image_index, f2_gpu_read_color, f2_gpu_display_color;
wire [7:0] f2_gpu_read_addr;
wire [19:0] f2_gpu_display_addr;
//Container to VGA output.
// Wires
wire [2:0] container_write_color;
wire [19:0] container_read_addr;

// Function 1 chips.
f1_keyproc function1_keyproc(
.R(R),
.G(G),
.B(B),
.set(set),
.sysclk(sysclk),
.color(f1_keyproc_color),
.write(f1_keyproc_write));

f1_vram function1_vram(
.write_color(f1_keyproc_color),
.write(f1_keyproc_write),
.read_color(f1_vram_read_color));

//Function 2 chips.
f2_keyproc function2_keyproc(
.East(East),
.West(West),
.North(North),
.South(South),
.sysclk(sysclk),
.instruction(f2_instruction));

f2_vram function2_ram(
.pixel_addr(f2_gpu_read_addr),
.image_index(f2_image_index),
.pixel_data(f2_gpu_read_color));

f2_gpu function2_gpu(
.sysclk(sysclk),
.instruction(f2_instruction),
.display_addr(f2_gpu_display_addr),
.pixel_data(f2_gpu_read_color),
.pixel_addr(f2_gpu_read_addr),
.image_index(f2_image_index),
.display_data(f2_gpu_display_color));

//Container Manager
container_switcher container(
.change_button(change_button),
.sysclk(sysclk),
.f1_vram_read(f1_vram_read_color),
.f2_gpu_display_addr(f2_gpu_display_addr),
.f2_gpu_display_color(f2_gpu_display_color),
.display_addr(container_read_addr),
.display_color(container_write_color));

vgaout vgaport(
.sysclk(sysclk),
.pixel_data(container_write_color),
.pixel_addr(container_read_addr),
.VGA_R(VGA_R),
.VGA_G(VGA_G),
.VGA_B(VGA_B),
.VGA_HS(VGA_HS),
.VGA_VS(VGA_VS));

endmodule