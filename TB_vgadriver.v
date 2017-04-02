`timescale 10ns / 10ns

module TB_vgadriver;

// Inputs
// Switcher.
   reg change_button;
// Function1
   reg R;
   reg G;
   reg B;
   reg set;
// Function2
   reg East, West, North, South;

// Output
   wire VGA_R;
   wire VGA_G;
   wire VGA_B;
   wire VGA_HS;
   wire VGA_VS;
   
//other regs
reg clk_50;

// Instantiate the design to be tested
   vgadriver UUT(
		.change_button(change_button),
		.R(R),
		.G(G),
		.B(B),
		.East(East),
		.West(West),
		.North(North),
		.South(South),
		.set(set),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.sysclk(clk_50)
   );
   
   

//create clock at 50MHz
initial begin
$dumpfile("TB_vgadriver.vcd");
$dumpvars(3, TB_vgadriver);
clk_50=0;
forever 
#1 clk_50 = ~clk_50; // every ten nanoseconds invert
end

initial begin // initialisation of signals
	change_button=0;
	R=0;
	G=0;
	B=0;
	West=0;
	East=0;
	North=0;
	South=0;
	set=0;
end

// Signal changes note it is 2 steps to a clock cycle
initial begin
		#2; change_button=0;
		#2; change_button=1;
		#2; change_button=0;
		#3; South=1;
		#5; South=0;
		#3; East=1;
		#5; East=0;
		#3000; $finish;  // terminates simulation
end

endmodule