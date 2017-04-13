module f2_keyproc(
input wire [3:0] func2_keys,
input wire func2_auto_switch,
input wire sysclk,
output reg [2:0] instruction,
output reg auto_switch);

//Defines the instruction for function 2.
// 0 = None
// 1 = Move forward
// 2 = Move backward
// 3 = Rotate 90 degree to right
// 4 = Negative

initial begin
	// Clear the instruction output.
	instruction = 3'd0;
end

always @(*) begin
	//Sync the auto switch.
	auto_switch = func2_auto_switch;
	// Check all the keys and translate to func2 GPU instruction.
	if (func2_keys[3]) begin
		instruction = 3'd2;
	end
	else if (func2_keys[2]) begin
		instruction = 3'd1;
	end
	else if (func2_keys[1]) begin
		instruction = 3'd3;
	end
	else if (func2_keys[0]) begin
		instruction = 3'd4;
	end
	else begin
		instruction = 3'd0;
	end
end

endmodule