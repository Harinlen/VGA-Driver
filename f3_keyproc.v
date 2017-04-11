module f3_keyproc(
input wire [4:0] func3_keys,
output reg scramble,
output reg [3:0] instruction);

//Defines the instruction for function 3.
// 0 = None
// 1 = North
// 2 = East
// 3 = West
// 4 = South
// 5 = Restart the game.
// Scramble will use an independent wire to process.

initial begin
	instruction = 4'd0;
end

always @(*) begin
	// Check all the keys.
	if (func3_keys[4]) begin
		// East button pressed.
		// Check whether West button is pressed as well, we will output restart command instead.
		if (func3_keys[3]) begin
			instruction = 4'd5;
		end
		else begin
			instruction = 4'd2;
		end
	end
	else if (func3_keys[3]) begin
		// West button.
		// Check East button is pressed as well, we will output restart command instead.
		if (func3_keys[4]) begin
			instruction = 4'd5;
		end
		else begin
			instruction = 4'd3;
		end
	end
	else if (func3_keys[2]) begin
		// North button.
		instruction = 4'd1;
	end
	else if (func3_keys[1]) begin
		// South button.
		instruction = 4'd4;
	end
	else begin
		instruction = 4'd0;
	end
	//Save the scramble state.
	scramble = func3_keys[0];
end

endmodule