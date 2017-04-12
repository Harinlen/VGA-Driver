`timescale 10ns / 10ns

module TB_vgadriver;

// Inputs
// Switcher.
   reg change_button;
// Buttons and switches.
   reg East, West, North, South;
   reg SW0, SW1, SW2, SW3;
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
		.East(East),
		.West(West),
		.North(North),
		.South(South),
		.SW0(SW0),
		.SW1(SW1),
		.SW2(SW2),
		.SW3(SW3),
		.func_switch(change_button),
		.sysclk(clk_50),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS));

//create clock at 50MHz
initial begin
	$dumpfile("TB_vgadriver.vcd");
	$dumpvars(3, TB_vgadriver);
	clk_50=0;
forever 
	#1 clk_50 = ~clk_50; // every ten nanoseconds invert
end

initial begin // initialisation of signals
	change_button = 0;
	East = 0;
	West = 0;
	North = 0;
	South = 0;
	SW0 = 0;
	SW1 = 0;
	SW2 = 0;
	SW3 = 0;
end

// Signal changes note it is 2 steps to a clock cycle
initial begin
	#2; change_button = 0;
	#3; change_button = 1;
	#1520; change_button = 0;
	//#3; change_button = 1;
	//#6000; change_button = 0;
	#5; North=1;
	#5; South=1;
	#2; South=0;
	#3000; $finish;  // terminates simulation
end

endmodule