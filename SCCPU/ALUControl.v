`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:27 07/31/2019 
// Design Name: 
// Module Name:    ALUControl 
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
module ALUControl(funct, ALUOp, ALU_funct);			// ALU_control module
	input [5:0] funct;
	input [3:0] ALUOp;				
	output reg [4:0] ALU_funct;	

	always@(funct or ALUOp) begin
		if      (ALUOp == 4'b0000) ALU_funct<= 5'b00010; 	// add
		else if (ALUOp == 4'b0001) ALU_funct<= 5'b00110; 	// sub/bne
		else if (ALUOp == 4'b0011) ALU_funct<= 5'b01011;	// xor
		else if (ALUOp == 4'b0100) ALU_funct<= 5'b00111;	// slt
		else if (ALUOp == 4'b0101) ALU_funct<= 5'b00100;	// mult
		else if (ALUOp == 4'b0110) ALU_funct<= 5'b01001;	// DIV
		else if (ALUOp == 4'b0111) ALU_funct<= 5'b00001;	// or
		else if (ALUOp == 4'b0010) begin
			case (funct)
				6'b100000 : ALU_funct<= 5'b00010;	// => add
				6'b100010 : ALU_funct<= 5'b00110;	// => sub
				6'b100100 : ALU_funct<= 5'b00000;	// => and
				6'b100101 : ALU_funct<= 5'b00001;	// => or
				6'b101010 : ALU_funct<= 5'b00111;	// => slt
				6'b100111 : ALU_funct<= 5'b00011;	// => nor
				6'b011000 : ALU_funct<= 5'b00100;	// => mult
				6'b011011 : ALU_funct<= 5'b01001;	// => div
				6'b000000 : ALU_funct<= 5'b00101;	// => sll
				6'b000011 : ALU_funct<= 5'b01000;	// => sra
				//6'b000000 : ALU_funct<= 5'b00000;	// when instruction is 32'd0
				default   : ALU_funct<= {0,ALUOp};
			endcase
		end
		else  ALU_funct<= 5'bxxxxx;
	end
endmodule
