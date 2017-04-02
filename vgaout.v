module vgaout(
input wire sysclk,
input wire [2:0] pixel_data,
output reg [19:0] pixel_addr,
output wire VGA_R,
output wire VGA_G,
output wire VGA_B,
output wire VGA_HS,
output wire VGA_VS
);

reg [9:0] x_counter;
reg [9:0] y_counter;

reg [2:0] pixel_rgb;

initial begin
	x_counter = 0;
	y_counter = 0;
	pixel_addr = 0;
end

always @(posedge sysclk) begin
	if (x_counter==800) begin
		x_counter = 0;
		if (y_counter==525)
			y_counter = 0;
		else
			y_counter = y_counter + 1;
	end
	else
		x_counter = x_counter + 1;
end

always @(x_counter or y_counter) begin
	pixel_rgb<=pixel_data;
	pixel_addr<={x_counter, y_counter};
end

assign VGA_R = pixel_rgb[2];
assign VGA_G = pixel_rgb[1];
assign VGA_B = pixel_rgb[0];

assign VGA_HS = x_counter > 7 && x_counter < 104;
assign VGA_VS = y_counter > 1 && y_counter < 4;

endmodule