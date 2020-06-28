`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:28:17 07/31/2019
// Design Name:   SingleCycle
// Module Name:   C:/Xilinx/Projects/SCPU_ver1/tb_SingleCycle.v
// Project Name:  SCPU_ver1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SingleCycle
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_SingleCycle;
	reg tb_i_clk;
	reg tb_i_rst_n;

	wire [31:0] tb_out_rf_data, tb_out_pc;

	parameter STEP =10;
	always #(STEP/2) tb_i_clk=~tb_i_clk;  // clock assign

	SingleCycle abcdefg(tb_i_clk,tb_i_rst_n, tb_out_rf_data, tb_out_pc);

	initial	begin
		tb_i_clk=1'b0; tb_i_rst_n=1'b0;	#15; 
		tb_i_rst_n=1'b1;				#240;
		$stop;	  
	end 
endmodule 

