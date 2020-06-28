`timescale 1ns / 1ps

module IR(i_clk, IRWrite, i_Instr, o_Instr);
	input [31:0] i_Instr;
	input i_clk, IRWrite;
	output reg [31:0] o_Instr;
	
	always@(posedge i_clk)begin
			if(IRWrite)
				o_Instr 	<= i_Instr;
			else
				o_Instr	<= o_Instr;
	end
	
endmodule
