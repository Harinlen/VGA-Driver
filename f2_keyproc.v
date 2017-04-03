module f2_keyproc(
input wire East,
input wire West,
input wire North,
input wire South,
input wire sysclk,
output reg set,
output reg [2:0] instruction);

//Defines the instruction for function 2.
// 0 = None
// 1 = Move forward
// 2 = Move backward
// 3 = Rotate 90 degree to right
// 4 = Nevigate

initial begin
	instruction = 3'd0;
	set = 0;
end

always @(posedge sysclk) begin
	if (East) begin
		instruction <= 3'd1;
		set <= 1;
	end
	else if (West) begin
		instruction <= 3'd2;
		set <= 1;
	end
	else if (North) begin
		instruction <= 3'd3;
		set <= 1;
	end
	else if (South) begin
		instruction <= 3'd4;
		set <= 1;
	end
	else begin
		instruction <= 3'd0;
		set <= 0;
	end
end

endmodule