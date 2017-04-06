module f3_keyproc(
input wire [4:0] func3_keys,
input wire sysclk,
output reg write,
output reg [3:0] instruction);

//Defines the instruction for function 3.
// 0 = None
// 1 = North
// 2 = East
// 3 = West
// 4 = South
// 5 = Scramble

initial begin
	instruction = 4'd0;
	write = 0;
end

always @(posedge sysclk) begin
	// Check all the keys.
	if (func3_keys[4]) begin
		instruction <= 4'd2;
		write <= 1;
	end
	else if (func3_keys[3]) begin
		instruction <= 4'd3;
		write <= 1;
	end
	else if (func3_keys[2]) begin
		instruction <= 4'd1;
		write <= 1;
	end
	else if (func3_keys[1]) begin
		instruction <= 4'd4;
		write <= 1;
	end
	else if (func3_keys[0]) begin
		instruction <= 4'd5;
		write <= 1;
	end
	else begin
		instruction <= 4'd0;
		write <= 0;
	end
end

endmodule