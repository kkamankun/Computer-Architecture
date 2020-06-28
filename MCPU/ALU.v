`timescale 1ns / 1ps

module ALU(i_data1, i_data2, shamt, ALUControl, o_result, o_br);
	input [31:0] i_data1, i_data2;
	input [4:0] shamt;
	input [3:0] ALUControl;
	output o_br;
	output reg [31:0] o_result;
	
	wire o_zero, o_neg;

	assign o_zero = (o_result == 32'b0) ? 1'b1 : 1'b0;
	assign o_neg = (o_result[31] == 1) ? 1'b1 : 1'b0;
	
	assign o_br = (o_zero | o_neg); 
	
	always@(i_data1, i_data2, ALUControl) begin
		if(ALUControl == 4'b0000)
			o_result <= i_data1 & i_data2;
		else if(ALUControl == 4'b0001)
			o_result <= i_data1 | i_data2;
		else if(ALUControl == 4'b0010)
			o_result <= i_data1 + i_data2;
		else if(ALUControl == 4'b0110)
			o_result <= i_data1 - i_data2;
		else if(ALUControl == 4'b0111)
			o_result <= (i_data1 < i_data2);
		else if(ALUControl == 4'b1000)
			o_result <= (i_data1 << 1);
		else if(ALUControl == 4'b1001)
			o_result <= (i_data1 >> 1);
		else if(ALUControl == 4'b1011)
			o_result <= (i_data1 ^ i_data2);
		else if(ALUControl == 4'b1100)
			o_result <= (i_data2 << 1);
		else if(ALUControl == 4'b1101)
			o_result <= (i_data2 >> 1);
		else if(ALUControl == 4'b1110)
			o_result <= (i_data2 << i_data1);
		else
			o_result <= 32'bz;
	end
endmodule
