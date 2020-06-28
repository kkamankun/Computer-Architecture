`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:18:59 07/31/2019 
// Design Name: 
// Module Name:    ALU 
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
module ALU(i_data1, i_data2, shamt, ALU_funct, o_result, o_zero, o_overflow, o_carry);
	input [31:0] i_data1, i_data2;  //input 32bit i_data1, i_data2
	input [4:0] shamt;
	input [4:0] ALU_funct;              //input 4bit selector = ALU control op
	output reg [31:0] o_result;         //output 32bit result
	output reg o_overflow, o_carry;     //output 1bit zero signal
	output o_zero;
	
	reg [31:0] r_temp;
	
	assign o_zero = (o_result != 32'b0) ? 1'b1 : 1'b0;

	always @(*) begin
		case (ALU_funct)
			5'b00000 : begin // bitwise and
				o_result = i_data1 & i_data2;
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b00001 : begin // bitwise or
				o_result = i_data1 | i_data2;
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b00010 : begin // sigend addition
				{o_carry, o_result} = i_data1 + i_data2;
				o_overflow = (i_data1[31]&i_data2[31]&~o_result[31])|(~i_data1[31]&~i_data2[31]&o_result[31]);
			end
			5'b00011 : begin // bitwise nor
				o_result = ~(i_data1 | i_data2);
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b00100 : begin	// unsigned mult
				o_result = i_data1 * i_data2;
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b00101 : begin	// sll
				o_result = i_data1 << i_data2;
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b00110 : begin // signed subtraction
				{o_carry, o_result} = i_data1 - i_data2;
				o_overflow = (i_data1[31]&i_data2[31]&~o_result[31])|(~i_data1[31]&~i_data2[31]&o_result[31]);
			end
			5'b00111 : begin // signed slt
				o_result = (i_data1 < i_data2) ? 32'b1 : 32'b0;
				{o_carry, r_temp} = i_data1 - i_data2;
				o_overflow = (i_data1[31]&i_data2[31]&~r_temp[31])|(~i_data1[31]&~i_data2[31]&r_temp[31]);
			end
			5'b01000 : begin	/// sra
				o_result = i_data1 >>> i_data2;
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b01001 : begin
			end
			5'b01010 : begin
			end
			5'b01011 : begin // bitwise xor
				o_result = i_data1 ^ i_data2;
				o_carry = 1'b0;
				o_overflow = 1'b0;
			end
			5'b01100 : begin
			end
			5'b01101 : begin
			end
			5'b01110 : begin
			end
			5'b01111 : begin
			end
			default   : ;
		endcase
	end
endmodule
