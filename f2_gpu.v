`include "constant.v"
module f2_gpu(
input wire [2:0] instruction,
input wire set,
input wire [21:0] display_addr,
input wire [2:0] pixel_data,
input wire [3:0] mapper_pixel_x,
input wire [3:0] mapper_pixel_y,
input wire sysclk,
output reg [21:0] mapper_display_addr,
output reg [7:0] pixel_addr,
output reg [2:0] image_index,
output reg [2:0] display_data);

reg [10:0] display_x, display_y;
reg [3:0] pixel_x, pixel_y;
reg [1:0] trans_mode;
reg [7:0] anime_pixel_index;
reg [2:0] current_image;
reg [2:0] command;
reg [3:0] delay_counter;
reg state, negative, is_display;

initial begin
	// Display parameter
	display_x = 0;
	display_y = 0;
	pixel_x = 0;
	pixel_y = 0;
	// Reset working state.
	state = 0;
	// Reset the transform mode.
	trans_mode = 2'b00;
	// Reset the negative state.
	negative = 0;
	// Reset display parameter.
	is_display = 0;
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
	if (state) begin
		// An instruction is running, checking the delay counter.
		if (delay_counter == 0) begin
			// Run the counter.
			case (command)
				// Moving backward.
				1: begin
					anime_pixel_index <= anime_pixel_index - 1;
					// Check the anime pixel index.
					if (anime_pixel_index == 8'h00) begin
						// Change state to none.
						state <= 0;
						anime_pixel_index <= 8'hFF;
					end
				end
				//Moving forward.
				2: begin
					anime_pixel_index <= anime_pixel_index + 1;
					// Check the anime pixel index.
					if (anime_pixel_index == 8'hFF) begin
						// Change state to none.
						state <= 0;
						anime_pixel_index <= 8'h00;
					end
				end
			endcase
		end
		// Increase the delay counter.
		delay_counter <= delay_counter + 1;
	end
	else begin
		// Checking the set state.
		if (set) begin
			// A new command should be set, save the command.
			command <= instruction;
			// Clear the state as default.
			state <= 0;
			// Check the command
			case (command)
				1: begin //Move forward.
					// Reset rotation.
					trans_mode <= 0;
					// Reset the nagative.
					negative = 0;
					// Check the image index, move to the previous image.
					if (current_image == 0)
						current_image <= `MAX_IMAGE_INDEX;
					else
						current_image <= current_image - 1;
					// Reset the animation.
					anime_pixel_index <= 8'hFF;
					// Set the state.
					state <= 1;
				end
				2: begin // Move backward.
					// Reset rotation.
					trans_mode = 0;
					// Reset the nagative.
					negative = 0;
					//Check the image index, move to the next image.
					if (current_image == `MAX_IMAGE_INDEX)
						current_image <= 0;
					else
						current_image <= current_image + 1;
					// Reset the animation.
					anime_pixel_index <= 8'h00;
					// Set the state.
					state <= 1;
				end
				3: begin // Rotate.
					//Reset rotation.
					trans_mode <= trans_mode + 1;
				end
				4: begin // Negative
					// Change the negative state.
					negative = ~negative;
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
			0: pixel_addr = {pixel_x, pixel_y};
			1: pixel_addr = {pixel_y, 4'd`MAX_IMAGE_SIZE - pixel_x};
			2: pixel_addr = {4'd`MAX_IMAGE_SIZE - pixel_x, 4'd`MAX_IMAGE_SIZE - pixel_y};
			3: pixel_addr = {4'd`MAX_IMAGE_SIZE - pixel_y, pixel_x};
		endcase
		
		// Apply animation.
		if (state)
			if (pixel_addr < anime_pixel_index)
				// Previous image, this should depend on the command
				if (command == 1)
					// Move previous, its image should be the next one.
					if (current_image == `MAX_IMAGE_INDEX)
						image_index = 0;
					else
						image_index = current_image + 1;
				else
					// Move next, its pirevous image should be the previous one.
					if (current_image == 0)
						image_index = `MAX_IMAGE_INDEX;
					else
						image_index = current_image - 1;
			else
				// Current image.
				image_index = current_image;
		else
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