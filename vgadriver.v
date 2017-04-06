module vgadriver(
//Keyboard 
input wire East,
input wire West,
input wire North,
input wire South,
input wire SW0,
input wire SW1,
input wire SW2,
input wire SW3,
input wire change_button,
//System clock
input wire sysclk,
//VGA outputs
output wire VGA_R,
output wire VGA_G,
output wire VGA_B,
output wire VGA_HS,
output wire VGA_VS);

// System bus data.
wire [1:0] bus_current_function;
wire bus_reset;

// Function 1 wires.
wire [3:0] func1_keys;
wire [2:0] func1_color_out;
wire [2:0] func1_color;
wire func1_write;

// Function 2 chips.
wire [21:0] func2_addr_in;
wire [3:0] func2_keys;
wire [2:0] func2_instruction, func2_color_out;
wire func2_write;

// Image ROM chip.
wire [2:0] vram_color_out, vram_index_in;
wire [7:0] vram_addr_in;

// VGA port.
wire [2:0] vga_color;
wire [21:0] vga_addr;

// Keyboard chips.
keyboard_proc keyboard_processor(
.East(East),
.West(West),
.North(North),
.South(South),
.SW0(SW0),
.SW1(SW1),
.SW2(SW2),
.SW3(SW3),
.change_button(change_button),
.func_index(bus_current_function),
.func1_instruction(func1_keys),
.func2_instruction(func2_keys),
.reset(bus_reset));

// Function 1 chips.
f1_keyproc func1_keyproc(
.func1_keys(func1_keys),
.sysclk(sysclk),
.color(func1_color),
.write(func1_write));

f1_vram func1_vram(
.write_color(func1_color),
.write(func1_write),
.read_color(func1_color_out));

// Function 2 chips.
f2_keyproc func2_keyproc(
.func2_keys(func2_keys),
.sysclk(sysclk),
.write(func2_write),
.instruction(func2_instruction));

f2_gpu func2_gpu(
.instruction(func2_instruction),
.set(func2_write),
.display_addr(func2_addr_in),
.pixel_data(vram_color_out),
.sysclk(sysclk),
.pixel_addr(vram_addr_in),
.image_index(vram_index_in),
.display_data(func2_color_out));

// Image ROM chip.
img_vrom image_rom(
.pixel_addr(vram_addr_in),
.image_index(vram_index_in),
.pixel_data(vram_color_out));

// Container switcher chips.
container_switcher switcher(
.current_function(bus_current_function),
.display_addr(vga_addr),
.func1_color(func1_color_out),
.func2_color(func2_color_out),
.func2_addr(func2_addr_in),
.display_color(vga_color));

// VGA port output.
vgaout vgaport(
.sysclk(sysclk),
.pixel_data(vga_color),
.rst(bus_reset),
.pixel_addr(vga_addr),
.VGA_R(VGA_R),
.VGA_G(VGA_G),
.VGA_B(VGA_B),
.VGA_HS(VGA_HS),
.VGA_VS(VGA_VS));

endmodule