module f1_vram(
input wire [2:0] write_color,
input wire write,
output reg [2:0] read_color
);

reg [2:0] color;

initial begin
	color = 3'b0;
end

always @(*) begin
	if(write) begin
		color = write_color;
	end
	read_color = color;
end

endmodule