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
reg [24:0] flash_counter;
integer i;
reg scramble, flash_negative;

initial begin
	// Clear the scramble boolean data.
	scramble = 0;
	// Reset the cursor.
	cursor_x = 0;
	cursor_y = 0;
	// Clear the flash parameter.
	flash_counter = 0;
	flash_negative = 0;
	// Reset the offset array.
	for (i=0; i<15; i=i+1) begin
		x_offsets[i] = 0;
		y_offsets[i] = 0;
	end
end

always @(posedge sysclk) begin
	// Update the flash state.
	flash_counter <= flash_counter + 1'b1;
	// Update the clock.
	if (flash_counter == 25'b0) begin
		flash_negative <= ~flash_negative;
	end
	// Check the scramble state.
	if (scramble) begin
		// Check the instruction according to the instruction.
		//!FIXME: Add codes here.
	end
	else begin
		// Move the cursor according to the insturction.
		case (instruction)
			// Move Up
			1: begin
				if (cursor_y == 0)
					cursor_y <= `MAX_IMAGE_SIZE;
				else
					cursor_y <= cursor_y - 1'b1;
			end
			// Move Right.
			2: begin
				if (cursor_x == `MAX_IMAGE_SIZE)
					cursor_x <= 0;
				else
					cursor_x <= cursor_x + 1'b1;
			end
			// Move left.
			3: begin
				if (cursor_x == 0)
					cursor_x <= `MAX_IMAGE_SIZE;
				else
					cursor_x <= cursor_x - 1'b1;
			end
			// Move Down.
			4: begin
				if (cursor_y == `MAX_IMAGE_SIZE) 
					cursor_y <= 0;
				else
					cursor_y <= cursor_y + 1'b1;
			end
			// Change Scramble state.
			5: begin
				scramble <= ~scramble;
			end
		endcase
	end
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
		pixel_x = mapper_pixel_x + x_offsets[mapper_pixel_x];
		pixel_y = mapper_pixel_y + y_offsets[mapper_pixel_y];
		// Set the pixel addr.
		pixel_addr = {pixel_y, pixel_x};
		// Set the normal display pixel data.
		if (flash_negative && pixel_x == cursor_x && pixel_y == cursor_y)
			display_data = ~pixel_data;
		else
			display_data = pixel_data;
	end
end

endmodule