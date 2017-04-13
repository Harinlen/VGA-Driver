module button_debouncer(
input wire inp,
input wire clk,
input wire clr,
output wire outp);

// Delay data save register.
reg delay1;
reg delay2;
reg delay3;
// Counter and beat generator.
reg [17:0] count;
reg beat;
// New slower checking clock.
wire slower_clk;

initial begin
    delay1 = 1'b0;
    delay2 = 1'b0;
    delay3 = 1'b0;
end

assign slower_clk = beat;
always @(posedge clk) begin
	// Check the reset first.
   if (clr) begin
		beat <= 1'b0;
		count <= 18'h0;
   end 
	else begin
		case(count)
			//Set any value. 
			18'h1: begin
				// Give an posedge.
				beat <= 1'b1;
				count <= count + 1'b1;
			end
			// Ignore, continue add.
         default: begin
				beat <= 1'b0;
				count <= count + 1'b1;
			end
		endcase
	end
end

always @(posedge slower_clk or posedge clr) begin
	// Check reset first.
	if (clr) begin
		// Clear all the delay data.
      delay1 <= 1'b0;
      delay2 <= 1'b0;
      delay3 <= 1'b0;
   end
   else begin
		// Left shift all the data.
      delay1 <= inp;
      delay2 <= delay1;
      delay3 <= delay2;
   end
end

assign outp = delay1 & delay2 & delay3;

endmodule