module img_mapper(
input wire [21:0] display_addr,
output reg [3:0] pixel_x,
output reg [3:0] pixel_y);

reg [10:0] display_x, display_y;

always @(*) begin
	// Get the pixel position on the display.
	display_x = display_addr[21:11];
	display_y = display_addr[10:0];
	// Calculate the image pixel position from display position.
	if (display_x < 261) pixel_x = 0;
	else if (display_x < 291) pixel_x = 1;
	else if (display_x < 321) pixel_x = 2;
	else if (display_x < 351) pixel_x = 3;
	else if (display_x < 381) pixel_x = 4;
	else if (display_x < 411) pixel_x = 5;
	else if (display_x < 441) pixel_x = 6;
	else if (display_x < 471) pixel_x = 7;
	else if (display_x < 501) pixel_x = 8;
	else if (display_x < 531) pixel_x = 9;
	else if (display_x < 561) pixel_x = 10;
	else if (display_x < 591) pixel_x = 11;
	else if (display_x < 621) pixel_x = 12;
	else if (display_x < 651) pixel_x = 13;
	else if (display_x < 681) pixel_x = 14;
	else pixel_x = 15;
	
	if (display_y < 66) pixel_y = 0; 
	else if (display_y < 96) pixel_y = 1; 
	else if (display_y < 126) pixel_y = 2;
	else if (display_y < 156) pixel_y = 3;
	else if (display_y < 186) pixel_y = 4;
	else if (display_y < 216) pixel_y = 5;
	else if (display_y < 246) pixel_y = 6;
	else if (display_y < 276) pixel_y = 7;
	else if (display_y < 306) pixel_y = 8;
	else if (display_y < 336) pixel_y = 9;
	else if (display_y < 366) pixel_y = 10;
	else if (display_y < 396) pixel_y = 11;
	else if (display_y < 426) pixel_y = 12;
	else if (display_y < 456) pixel_y = 13;
	else if (display_y < 486) pixel_y = 14;
	else pixel_y = 15;
end

endmodule