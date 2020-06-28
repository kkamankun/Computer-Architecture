`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:25:26 07/31/2019 
// Design Name: 
// Module Name:    PC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PC(i_clk,i_rst_n, i_next_pc,o_pc);
	input i_clk,i_rst_n;      //input 1bit clock, reset
	input [31:0] i_next_pc;   //input 32bit next_pc
	output [31:0] o_pc;       //output 32bit current_pc

	reg [31:0] o_pc;

	always@ (posedge i_clk or negedge i_rst_n) begin
		if(i_rst_n==0)    o_pc = 31'd0;
		else    o_pc = i_next_pc;
	end
endmodule
