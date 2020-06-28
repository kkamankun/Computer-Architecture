`timescale 1ns / 1ps


module tb_top;

	// Inputs
	reg i_clk;
	reg i_rst_n;

	// Outputs
	wire [31:0] o_data_out;
	wire [7:0] o_state;

	// Instantiate the Unit Under Test (UUT)
	MultiCycleCPU uut (
		.i_clk(i_clk), 
		.i_rst_n(i_rst_n), 
		.o_data_out(o_data_out), 
		.o_state(o_state)
	);
	always #5 i_clk = ~i_clk;
	initial begin
		// Initialize Inputs
		i_clk = 0;
		i_rst_n = 0;
		#10; i_rst_n=1;
		// Wait 100 ns for global reset to finish
		#500;
		$stop;
		// Add stimulus here

	end
      
endmodule

