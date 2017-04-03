module f3_keyproc(
input wire East,
input wire West,
input wire North,
input wire South,
input wire Scramble,
input wire sysclk,
output reg set,
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
	set = 0;
end

always @(posedge sysclk) begin
	if (East) begin
		instruction <= 4'd2;
		set <= 1;
	end
	else if (West) begin
		instruction <= 4'd3;
		set <= 1;
	end
	else if (North) begin
		instruction <= 4'd1;
		set <= 1;
	end
	else if (South) begin
		instruction <= 4'd4;
		set <= 1;
	end
	else if (Scramble) begin
		instruction <= 4'd5;
		set <= 1;
	end
	else begin
		instruction <= 4'd0;
		set <= 0;
	end
end

endmodule