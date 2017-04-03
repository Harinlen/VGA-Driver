`include "constant.v"
module f2_gpu(
input wire [2:0] instruction,
input wire set,
input wire [19:0] display_addr,
input wire [2:0] pixel_data,
input wire sysclk,
output reg [7:0] pixel_addr,
output reg [2:0] image_index,
output reg [2:0] display_data);

reg [9:0] display_x, display_y;
reg [3:0] pixel_x, pixel_y;
reg [1:0] trans_mode;
reg [7:0] anime_pixel_index;
reg [2:0] current_image;
reg [2:0] command;
reg [3:0] delay_counter;
reg state, negative;

initial begin
	// Display parameter
	display_x = 10'b0;
	display_y = 10'b1;
	pixel_x = 4'b0;
	pixel_y = 4'b0;
	// Reset working state.
	state = 0;
	// Reset the transform mode.
	trans_mode = 2'b00;
	// Reset the negative state.
	negative = 0;
	// Reset animation parameter.
	anime_pixel_index = 8'b0;
	current_image = 0;
	delay_counter = 4'b1111;
	// Reset the command.
	command=3'b0;
end

always @(posedge set) begin
	// Check state.
	if (!state) begin
		// Save the current instruction.
		command = instruction;
		// Change the state to working.
		state = 1;
	end
	//Check the state.
	if (state) begin
		case (command)
			0: begin //For None command, ignore the operation.
				state = 1'b0;
			end
			1: begin // Move forward.
				//Reset rotation.
				trans_mode = 2'b00;
				//Reset nagative.
				negative = 0;
				//Check the image index, move to the previous image.
				if (current_image == 0)
					current_image = `MAX_IMAGE_INDEX;
				else
					current_image = current_image - 1;
			end
			2: begin // Move backward.
				//Reset rotation.
				trans_mode = 2'b00;
				//Reset nagative.
				negative = 0;
				//Check the image index, move to the next image.
				if (current_image == `MAX_IMAGE_INDEX)
					current_image = 0;
				else
					current_image = current_image + 1;
			end
			3: begin // Rotate.
				//Reset rotation.
				trans_mode = trans_mode + 1;
				//Clear the state.
				state = 1'b0;
			end
			4: begin // Negative
				// Change the negative state.
				negative = ~negative;
				//Clear the state.
				state = 1'b0;
			end
		endcase
	end
end

always @(posedge sysclk) begin
	if (state) begin
		if (delay_counter == 0)
			case (command)
				1: begin 
					//Moving forward.
					anime_pixel_index <= anime_pixel_index + 1;
					// Check the anime pixel index.
					if (anime_pixel_index == 8'hFF) begin
						// Change state to none.
						state <= 1'b0;
						anime_pixel_index <= 8'h00;
					end
				end
				2: begin
					// Moving backward.
					anime_pixel_index <= anime_pixel_index - 1;
					// Check the anime pixel index.
					if (anime_pixel_index == 8'h00) begin
						// Change state to none.
						state <= 1'b0;
						anime_pixel_index <= 8'hFF;
					end
				end
			endcase
		delay_counter <= delay_counter + 1;
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
	case (trans_mode)
		0: pixel_addr = {pixel_x, pixel_y};
		1: pixel_addr = {pixel_y, 4'd`MAX_IMAGE_SIZE - pixel_x};
		2: pixel_addr = {4'd`MAX_IMAGE_SIZE - pixel_x, 4'd`MAX_IMAGE_SIZE - pixel_y};
		3: pixel_addr = {4'd`MAX_IMAGE_SIZE - pixel_y, pixel_x};
	endcase
	//Set the image index.
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
	if(negative)
		//Set the invert display pixel data.
		display_data = ~pixel_data;
	else
		//Set the normal display pixel data.
		display_data = pixel_data;
end

endmodule