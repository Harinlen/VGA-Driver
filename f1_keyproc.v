module f1_keyproc(
input wire [3:0] func1_keys,
input wire sysclk,
output reg [2:0] color,
output reg write);

always @(posedge sysclk) begin
	if (func1_keys[0]) begin
		write <= 1'b1;
		// The keys is right in RGB mode, output the data
		color <= func1_keys[3:1];
	end
	else
		write <= 1'b0;
end

endmodule