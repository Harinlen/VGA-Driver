`include "constant.v"
module f3_gpu(
input wire [3:0] instruction,
input wire [21:0] display_addr,
input wire [2:0] pixel_data,
input wire [3:0] mapper_pixel_x,
input wire [3:0] mapper_pixel_y,
input wire sysclk,
output reg [21:0] mapper_display_addr,
output reg [7:0] pixel_addr,
output reg [2:0] display_data);

reg [10:0] display_x, display_y;
reg [3:0] pixel_x, pixel_y, x_offsets[0:15], y_offsets[0:15], cursor_x, cursor_y;
integer i;
reg scramble;

initial begin
	// Clear the scramble boolean data.
	scramble = 0;
	// Reset the cursor.
	cursor_x = 0;
	cursor_y = 0;
	// Reset the offset array.
	for (i=0; i<15; i=i+1) begin
		x_offsets[i] = 0;
		y_offsets[i] = 0;
	end
end

always @(posedge sysclk) begin
	// Save the scramble value.
	scramble <= instruction[0];
	
end

always @(*) begin
	// Get the pixel position on the display.
	display_x = display_addr[19:10];
	display_y = display_addr[9:0];
	// Check the display x and display y.
	if ((display_x < 231) || (display_x > 711) || (display_y < 36) || (display_y > 516)) begin
		// Always display black.
		display_data = 3'b000;
	end
	else begin
		// Get the pixel x and y.
		mapper_display_addr = display_addr;
		pixel_x = mapper_pixel_x;
		pixel_y = mapper_pixel_y;
		// Set the pixel addr.
		pixel_addr = {pixel_x + x_offsets[pixel_x], pixel_y + y_offsets[pixel_y]};
		// Set the normal display pixel data.
		display_data = pixel_data;
	end
end

endmodule