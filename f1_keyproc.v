module f1_keyproc(
input wire R,
input wire G,
input wire B,
input wire set,
input wire sysclk,
output reg [2:0] color,
output reg write);

always @(posedge sysclk) begin
	if (set) begin
		write <= 1'b1;
		color <= {{R, G}, B};
	end
	else
		write <= 1'b0;
end

endmodule