module f1_vram(
input wire [2:0] write_color,
input wire write,
output reg [2:0] read_color);

reg [2:0] color;

initial begin
	// Reset the memory.
	color = 3'b0;
end

always @(*) begin
	// Save the new color.
	if(write) begin
		color = write_color;
	end
	// Write the vram color to output data.
	read_color = color;
end

endmodule