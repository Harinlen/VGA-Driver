`include "constant.v"
module f3_gpu(
input wire [3:0] instruction,
input wire set,
input wire [19:0] display_addr,
input wire [2:0] pixel_data,
input wire sysclk,
output reg [7:0] pixel_addr,
output reg [2:0] display_data);

reg [3:0] x_offsets[0:15], y_offsets[0:15];
integer i;
reg scramble;

initial begin
	// Clear the scramble boolean data.
	scramble = 0;
	// Reset the offset array.
	for (i=0; i<15; i=i+1) begin
		x_offsets[i] = 0;
		y_offsets[i] = 0;
	end
end

always @(posedge set) begin
	// Check the scramble state.
	if (scramble) begin
		
	end
end

always @(*) begin
	// Get the pixel position on the display.
	display_x = display_addr[19:10];
	display_y = display_addr[9:0];
	// Calculate the image pixel.
	if (display_x < 152)
		pixel_x = 0;
	else if (display_x < 192)
		pixel_x = 1;
	else if (display_x < 232)
		pixel_x = 2;
	else if (display_x < 272)
		pixel_x = 3;
	else if (display_x < 312)
		pixel_x = 4;
	else if (display_x < 352)
		pixel_x = 5;
	else if (display_x < 392)
		pixel_x = 6;
	else if (display_x < 432)
		pixel_x = 7;
	else if (display_x < 472)
		pixel_x = 8;
	else if (display_x < 512)
		pixel_x = 9;
	else if (display_x < 552)
		pixel_x = 10;
	else if (display_x < 592)
		pixel_x = 11;
	else if (display_x < 632)
		pixel_x = 12;
	else if (display_x < 672)
		pixel_x = 13;
	else if (display_x < 712)
		pixel_x = 14;
	else
		pixel_x = 15;
		
	if (display_y < 37)
		pixel_y = 0;
	else if (pixel_y < 67)
		pixel_y = 1;
	else if (pixel_y < 97)
		pixel_y = 2;
	else if (pixel_y < 127)
		pixel_y = 3;
	else if (pixel_y < 157)
		pixel_y = 4;
	else if (pixel_y < 187)
		pixel_y = 5;
	else if (pixel_y < 217)
		pixel_y = 6;
	else if (pixel_y < 247)
		pixel_y = 7;
	else if (pixel_y < 277)
		pixel_y = 8;
	else if (pixel_y < 307)
		pixel_y = 9;
	else if (pixel_y < 337)
		pixel_y = 10;
	else if (pixel_y < 367)
		pixel_y = 11;
	else if (pixel_y < 397)
		pixel_y = 12;
	else if (pixel_y < 427)
		pixel_y = 13;
	else if (pixel_y < 457)
		pixel_y = 14;
	else if (pixel_y < 487)
		pixel_y = 15;
	
	//Set the pixel addr.
	pixel_addr = {pixel_x, pixel_y};
	//Set the normal display pixel data.
	display_data = pixel_data;
end

endmodule