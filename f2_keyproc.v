module f2_keyproc(
input wire East,
input wire West,
input wire North,
input wire South,
input wire sysclk,
output reg [2:0] instruction);

//Defines the instruction for function 2.
// 0 = None
// 1 = Move forward
// 2 = Move backward
// 3 = Rotate 90 degree
// 4 = Nevigate

initial begin
	instruction = 3'd0;
end

always @(posedge sysclk) begin
	if (East)
		instruction <= 3'd1;
	else
		if (West)
			instruction <= 3'd2;
		else
			if (North)
				instruction <= 3'd3;
			else
				if (South)
					instruction <= 3'd4;
				else
					instruction <= 3'd0;
end

endmodule