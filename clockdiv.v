module clockdiv(
input wire clk,
input wire reset,
output reg beat);

reg [17:0] count;

always @(posedge clk) begin
   case(reset)
		1: begin
			beat <= 1'b0;
			count <= 18'h0;
      end 
		default: begin
			case(count) 
				18'h10: begin
					beat <= 1'b1;
					count <= count + 1'b1;
				end
            default: begin
					beat <= 1'b0;
					count <= count + 1'b1;
				end
			endcase
		end
	endcase
end

endmodule