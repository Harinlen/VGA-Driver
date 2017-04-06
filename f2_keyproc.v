module f2_keyproc(
input wire [3:0] func2_keys,
input wire sysclk,
output reg write,
output reg [2:0] instruction);

//Defines the instruction for function 2.
// 0 = None
// 1 = Move forward
// 2 = Move backward
// 3 = Rotate 90 degree to right
// 4 = Nevigate

initial begin
	// Clear the instruction output.
	instruction = 3'd0;
	// Reset the set to no.
	write = 0;
end

always @(posedge sysclk) begin
	// Check all the keys and translate to func2 GPU instruction.
	if (func2_keys[3]) begin
		instruction <= 3'd1;
		write <= 1;
	end
	else if (func2_keys[2]) begin
		instruction <= 3'd2;
		write <= 1;
	end
	else if (func2_keys[1]) begin
		instruction <= 3'd3;
		write <= 1;
	end
	else if (func2_keys[0]) begin
		instruction <= 3'd4;
		write <= 1;
	end
	else begin
		instruction <= 3'd0;
		write <= 0;
	end
end

endmodule