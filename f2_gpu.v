`include "constant.v"
module f2_gpu(
input wire [2:0] instruction,
input wire [21:0] display_addr,
input wire [2:0] pixel_data,
input wire [3:0] mapper_pixel_x,
input wire [3:0] mapper_pixel_y,
input wire auto_switch,
input wire sysclk,
output reg [21:0] mapper_display_addr,
output reg [7:0] pixel_addr,
output reg [2:0] image_index,
output reg [2:0] display_data);

wire East, West, North, South;

reg [10:0] display_x, display_y;
reg [3:0] pixel_x, pixel_y;
reg [1:0] trans_mode;
reg [7:0] anime_pixel_index;
reg [2:0] current_image;
reg [2:0] command;
reg [15:0] delay_counter;
reg negative, done_flag;

initial begin
	// Display parameter
	display_x = 0;
	display_y = 0;
	pixel_x = 0;
	pixel_y = 0;
	// Reset the transform mode.
	trans_mode = 2'b00;
	// Reset the negative state.
	negative = 0;
	// Reset the key processed flag.
	done_flag = 0;
	// Reset animation parameter.
	anime_pixel_index = 8'b0;
	current_image = 0;
	delay_counter = 4'b1111;
	// Reset the running instruction, which named command here.
	command = 3'b000;
	// Clear the output data.
	display_data = 3'b000;
end

always @(posedge sysclk) begin
	// Check the running state first.
	if (auto_switch) begin
		// An instruction is running, checking the delay counter.
		if (delay_counter == 1'b0) begin
			//Check the image index, move to the next image.
			if (current_image == `MAX_IMAGE_INDEX)
				current_image <= 0;
			else
				current_image <= current_image + 1;
		end
		// Increase the delay counter.
		delay_counter <= delay_counter + 1'b1;
	end
	// Check the command.
	if(instruction == 0) begin
		// Reset the done flag.
		done_flag <= 0;
	end
	else begin
		if (done_flag == 0) begin
			// Check the command
			case (instruction)
				1: begin //Move forward.
					// Check the auto switch state.
					if (auto_switch == 0) begin
						// Check the image index, move to the previous image.
						if (current_image == 0)
							current_image <= `MAX_IMAGE_INDEX;
						else
							current_image <= current_image - 1;
						// Set the done flag.
						done_flag <= 1;
					end
				end
				2: begin // Move backward.
					// Check the auto switch state.
					if (auto_switch == 0) begin
						//Check the image index, move to the next image.
						if (current_image == `MAX_IMAGE_INDEX)
							current_image <= 0;
						else
							current_image <= current_image + 1;
						// Set the done flag.
						done_flag <= 1;
					end
				end
				3: begin // Rotate.
					//Reset rotation.
					if(trans_mode == 3)
						trans_mode <= 0;
					else
						trans_mode <= trans_mode + 1;
					// Set the done flag.
					done_flag <= 1;
				end
				4: begin // Negative
					// Change the negative state.
					negative <= ~negative;
					// Set the done flag.
					done_flag <= 1;
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
		pixel_x = mapper_pixel_x;
		pixel_y = mapper_pixel_y;
		
		// Apply rotation.
		case (trans_mode)
			0: pixel_addr = {pixel_y, pixel_x};
			1: pixel_addr = {pixel_x, 4'd`MAX_IMAGE_SIZE - pixel_y};
			2: pixel_addr = {4'd`MAX_IMAGE_SIZE - pixel_y, 4'd`MAX_IMAGE_SIZE - pixel_x};
			3: pixel_addr = {4'd`MAX_IMAGE_SIZE - pixel_x, pixel_y};
		endcase
		// Always current image.
		image_index = current_image;
		// Check negative.
		if (negative)
			//Set the invert display pixel data.
			display_data = ~pixel_data;
		else
			//Set the normal display pixel data.
			display_data = pixel_data;
	end
end

endmodule