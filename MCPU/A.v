`timescale 1ns / 1ps

module A(i_clk,i_x, o_y); //Nonarchitectural Register
	input [31:0] i_x;
	input i_clk;
	output reg[31:0] o_y;
	
	always@(posedge i_clk )begin
			o_y <= i_x;
	end
endmodule

