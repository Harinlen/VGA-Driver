module container_switcher(
input wire change_button,
input wire sysclk,
input wire [19:0] display_addr,
input wire [2:0] f1_vram_read,
input wire [2:0] f2_gpu_display_color,
output reg [19:0] f2_gpu_display_addr,
output reg [2:0] display_color);

reg [1:0] current_function;

initial begin
	current_function = 2'd0;
end

always @(posedge sysclk) begin
	if(change_button) begin
		if(current_function==2'd2)
			current_function=2'd0;
		else
			current_function=current_function+2'd1;
	end
	case (current_function)
		2'd0: display_color = f1_vram_read;
		2'd1: begin
			f2_gpu_display_addr = display_addr;
			display_color = f1_vram_read;
		end
		2'd2: display_color = f1_vram_read;
	endcase
end

endmodule