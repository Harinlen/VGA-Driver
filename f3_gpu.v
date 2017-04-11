`include "constant.v"
module f3_gpu(
input wire [3:0] instruction,
input wire [21:0] display_addr,
input wire [2:0] pixel_data,
input wire [3:0] mapper_pixel_x,
input wire [3:0] mapper_pixel_y,
input wire [3:0] offset_x,
input wire [3:0] offset_y,
input wire scramble,
input wire sysclk,
output reg [21:0] mapper_display_addr,
output reg [3:0] offset_pos_x,
output reg [3:0] offset_pos_y,
output reg [7:0] pixel_addr,
output reg [2:0] display_data,
output reg [3:0] ram_write_pos,
output reg ram_write_horizontal,
output reg ram_write_increase,
output reg ram_write,
output reg ram_reset);

reg [10:0] display_x, display_y;
reg [3:0] pixel_x, pixel_y, pixel_offset_x, pixel_offset_y, cursor_x, cursor_y;
reg [24:0] flash_counter;
reg flash_negative, instruction_done, is_cursor;

initial begin
	// Clear the done.
	instruction_done = 0;
	// Reset the cursor.
	cursor_x = 0;
	cursor_y = 0;
	// Clear the flash parameter.
	flash_counter = 0;
	flash_negative = 0;
	// Clear the memory reset.
	ram_reset = 0;
end

always @(posedge sysclk) begin
	// Update the flash state.
	flash_counter <= flash_counter + 1'b1;
	// Update the clock.
	if (flash_counter == 25'b0) begin
		flash_negative <= ~flash_negative;
	end
	// Set RAM write to 0.
	ram_write <= 0;
	// Set RAM reset when the reset instruction is given.
	ram_reset <= (instruction == 5);
	// Check instruction running state.
	if (instruction_done) begin
		// Only when the instruction set to None, we could accept for the next instruction.
		if (instruction == 0) begin
			instruction_done <= 0;
		end
	end
	else begin
		// Check the scramble state.
		if (scramble) begin
			// Check the instruction according to the instruction.
			case (instruction)
				// Ignore for None command.
				// Move Up
				1: begin
					// Set write data.
					ram_write_pos <= cursor_x;
					ram_write_horizontal <= 0;
					ram_write_increase <= 1;
					// Let it write.
					ram_write <= 1;
					//Set done to 1.
					instruction_done <= 1;
				end
				// Move Right
				2: begin
					// Set write data.
					ram_write_pos <= cursor_y;
					ram_write_horizontal <= 1;
					ram_write_increase <= 0;
					// Let it write.
					ram_write <= 1;
					//Set done to 1.
					instruction_done <= 1;
				end
				// Move Left
				3: begin
					// Set write data.
					ram_write_pos <= cursor_y;
					ram_write_horizontal <= 1;
					ram_write_increase <= 1;
					// Let it write.
					ram_write <= 1;
					//Set done to 1.
					instruction_done <= 1;
				end
				// Move Down
				4: begin
					// Set write data.
					ram_write_pos <= cursor_x;
					ram_write_horizontal <= 0;
					ram_write_increase <= 0;
					// Let it write.
					ram_write <= 1;
					//Set done to 1.
					instruction_done <= 1;
				end
			endcase
		end
		else begin
			// Move the cursor according to the insturction.
			case (instruction)
				// Ignore for None command.
				// Move Up
				1: begin
					if (cursor_y == 0)
						cursor_y <= `MAX_IMAGE_SIZE;
					else
						cursor_y <= cursor_y - 1'b1;
					//Set done to 1.
					instruction_done <= 1;
				end
				// Move Right.
				2: begin
					if (cursor_x == `MAX_IMAGE_SIZE)
						cursor_x <= 0;
					else
						cursor_x <= cursor_x + 1'b1;
					//Set done to 1.
					instruction_done <= 1;
				end
				// Move left.
				3: begin
					if (cursor_x == 0)
						cursor_x <= `MAX_IMAGE_SIZE;
					else
						cursor_x <= cursor_x - 1'b1;
					//Set done to 1.
					instruction_done <= 1;
				end
				// Move Down.
				4: begin
					if (cursor_y == `MAX_IMAGE_SIZE) 
						cursor_y <= 0;
					else
						cursor_y <= cursor_y + 1'b1;
					//Set done to 1.
					instruction_done <= 1;
				end
			endcase
		end
	end
end

always @(*) begin
	// Get the pixel position on the display.
	display_x = display_addr[21:11];
	display_y = display_addr[10:0];
	// Check the display x and display y.
	if ((display_x < 231) || (display_x > 711) || (display_y < 36) || (display_y > 516)) begin
		// Always display black.
		display_data = 3'b000;
	end
	else begin
		// Get the pixel x and y.
		mapper_display_addr = display_addr;
		// Check the cursor flashing.
		is_cursor = flash_negative && (mapper_pixel_x == cursor_x) && (mapper_pixel_y == cursor_y);
		// Set the offset pos x and y.
		offset_pos_x = mapper_pixel_x;
		offset_pos_y = mapper_pixel_y;
		// Process the offset.
		pixel_x = mapper_pixel_x + offset_y;
		pixel_y = mapper_pixel_y + offset_x;
		// Set the pixel addr.
		pixel_addr = {pixel_y, pixel_x};
		// Set the display pixel data.
		if (is_cursor)
			display_data = ~pixel_data;
		else
			display_data = pixel_data;
	end
end

endmodule