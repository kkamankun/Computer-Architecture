`timescale 1ns / 1ps

module PC(o_pc, i_next_pc, i_clk, i_rst_n, i_pc_w_c);
	input [31:0] i_next_pc;
	input i_clk, i_rst_n, i_pc_w_c;
	output reg [31:0] o_pc;
	
	always@(posedge i_clk or negedge i_rst_n)begin
		if(!i_rst_n)
			o_pc <= 0;
		else begin		
			if(i_pc_w_c)
				o_pc <= i_next_pc;
		end
	end
endmodule
