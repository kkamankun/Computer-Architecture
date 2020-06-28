`timescale 1ns / 1ps

module MDR(i_clk,i_data, o_data); //Nonarchitectural Register
	input [31:0] i_data;
	input i_clk;
	output reg[31:0] o_data;
	
	always@(posedge i_clk )begin
			o_data <= i_data;
	end
endmodule
