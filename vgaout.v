module vgaout(
input wire sysclk,
input wire [2:0] pixel_data,
input wire rst,
output reg [21:0] pixel_addr,
output wire VGA_R,
output wire VGA_G,
output wire VGA_B,
output wire VGA_HS,
output wire VGA_VS);

wire pclk;
reg count;
reg [10:0] x_counter, y_counter;

reg [2:0] pixel_rgb;

initial begin
	count = 0;
	x_counter = 0;
	y_counter = 0;
	pixel_rgb = 3'b000;
end

//25MHz pixel clock from system 100MHz clock.
assign pclk = count;
always @(posedge sysclk or posedge rst) begin
	if (rst) begin
		count <= 0;
	end
	else begin
		count <= ~count;
	end
end

always @(posedge pclk or posedge rst) begin
	if (rst) begin
		x_counter <= 0;
		y_counter <= 0;
	end
	else begin
		//Set the pixel.
		pixel_addr <= {x_counter, y_counter};
		pixel_rgb <= pixel_data;
		//Move to next position.
		if (x_counter == 800) begin
			x_counter <= 0;
			if (y_counter == 521) begin
				y_counter <= 0;
			end
			else begin
				y_counter <= y_counter + 1;
			end
		end
		else
			x_counter <= x_counter + 1;
	end
end

// Set the display pixel.
assign VGA_R = pixel_rgb[2] && (x_counter > 151 && x_counter < 791) && (y_counter > 36 && y_counter < 516);
assign VGA_G = pixel_rgb[1] && (x_counter > 151 && x_counter < 791) && (y_counter > 36 && y_counter < 516);
assign VGA_B = pixel_rgb[0] && (x_counter > 151 && x_counter < 791) && (y_counter > 36 && y_counter < 516);
// Column sync with row.
assign VGA_HS = (x_counter < 8 || x_counter > 103);
// Row counter sync with the field.
assign VGA_VS = (y_counter < 2 || y_counter > 3);

endmodule