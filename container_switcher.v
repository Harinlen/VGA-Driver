module container_switcher(
input wire [1:0] current_function,
input wire [21:0] display_addr,
input wire [2:0] func1_color,
input wire [2:0] func2_color,
input wire [2:0] func3_color,
output reg [21:0] func2_addr,
output reg [21:0] func3_addr,
output reg [2:0] display_color);

always @(*) begin
	case (current_function)
		// Function 1, directly get color from vram.
		2'd0: display_color = func1_color;
		// Function 2, get color from function 2 GPU.
		2'd1: begin
			func2_addr = display_addr;
			display_color = func2_color;
		end
		2'd2: begin
			func3_addr = display_addr;
			display_color = func3_color;
		end
	endcase
end

endmodule