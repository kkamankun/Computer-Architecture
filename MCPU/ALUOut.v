`timescale 1ns / 1ps

module ALUOut(i_clk, i_alu_result, o_alu_out);
	
	input [31:0] i_alu_result;
	input i_clk;
	output reg[31:0] o_alu_out;
	
	always@(posedge i_clk)
	begin
		o_alu_out <= i_alu_result;
	end
endmodule

