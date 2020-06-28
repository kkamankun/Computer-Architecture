`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:44 07/31/2019 
// Design Name: 
// Module Name:    SEU 
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
module SEU(i_halfword,o_word,ext_mode);
	input [15:0]i_halfword;     //input 16bit data
	input ext_mode;
	output [31:0]o_word;        //output 32bit data

	reg [31:0]o_word;

	always@(*) begin
		if (ext_mode==1'b0) begin
			o_word[15:0] <= i_halfword[15:0];
			o_word[31:16] <= 16'b0000000000000000;
		end
		else if (ext_mode==1'b1) begin
			if(i_halfword[15]==1'b1) begin
				o_word[15:0] <= i_halfword[15:0];
				o_word[31:16] <= 16'b1111111111111111;
			end
			else begin
				o_word[15:0] <= i_halfword[15:0];
				o_word[31:16] <= 16'b0000000000000000;      
			end
		end
		else begin
			o_word[15:0] <= i_halfword[15:0];
			o_word[31:16] <= 16'bxxxxxxxxxxxxxxxx;      
		end
	end
endmodule
