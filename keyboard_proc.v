module keyboard_proc(
input wire East,
input wire West,
input wire North,
input wire South,
input wire SW0,
input wire SW1,
input wire SW2,
input wire SW3,
input wire change,
input wire sysclk,
output reg [1:0] func_index,
output reg [3:0] func1_instruction,
output reg [3:0] func2_instruction,
output reg [4:0] func3_instruction,
output reg reset);

reg [1:0] current_function;

initial begin
	//To debug function, change the default value.
	current_function = 0;
end

always @(posedge change) begin
	if (current_function == 2)
		current_function <= 0;
	else
		current_function <= current_function + 1;
end

always @(*) begin
	//Set the reset signal.
	reset = SW0;
	//Output the function index.
	func_index = current_function;
	//Check the function index.
	case (current_function)
		2'd0: begin
			//Output function 1 instruction.
			// Format is R, G, B, set
			// R G B are the switches for the SW3, SW2, SW1
			// Set will be the button east.
			func1_instruction = {{{SW3, SW2}, SW1}, East};
			// Clear the function 2.
			func2_instruction = 4'd0;
			// Clear the function 3.
			func3_instruction = 5'd0;
		end
		2'd1: begin
			// Clear the function 1.
			func1_instruction = 4'd0;
			//Output function 2 instruction.
			// Format is East, West, North, South button.
			func2_instruction = {{{East, West}, North}, South};
			// Clear the function 3.
			func3_instruction = 5'd0;
		end
		2'd2: begin
			// Clear the function 1.
			func1_instruction = 4'd0;
			// Clear the function 2.
			func2_instruction = 4'd0;
			//Output function 3 instruction.
			// Format is East, West, North, South, Scramble(SW3) button.
			func3_instruction = {{{{East, West}, North}, South}, SW3};
		end
	endcase
end

endmodule