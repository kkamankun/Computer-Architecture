`timescale 1ns / 1ps

module ALUControl(i_funct, i_ALUop, o_ALUctrl);
	input [5:0] i_funct;
	input [2:0] i_ALUop;
	output reg[3:0] o_ALUctrl;
	
always@(i_ALUop, i_funct)begin
		case(i_ALUop)
		3'b000: o_ALUctrl <= 4'b0010; //add
		3'b001: o_ALUctrl <= 4'b0110; //sub
		3'b010: begin
			case(i_funct)
				6'b000000: o_ALUctrl <= 4'b0010; // NOP
				6'b100000: o_ALUctrl <= 4'b0010; // add
				6'b100010: o_ALUctrl <= 4'b0110; // sub
				6'b100100: o_ALUctrl <= 4'b0000; // and
				6'b100101: o_ALUctrl <= 4'b0000; // or
				6'b101010: o_ALUctrl <= 4'b0111; // slt
				6'b100110: o_ALUctrl <= 4'b1011; // xor	
				6'b000100: o_ALUctrl <= 4'b1110; // sl
				6'b100110: o_ALUctrl <= 4'b1001;
				6'b100111: o_ALUctrl <= 4'b1000;
				6'b101000: o_ALUctrl <= 4'b1100;
				6'b101001: o_ALUctrl <= 4'b1101;
				default: o_ALUctrl <= 4'bx;
			endcase
			end
		3'b011: o_ALUctrl <= 4'b0000; // and
		3'b100: o_ALUctrl <= 4'b0111; // slt
		3'b101: o_ALUctrl <= 4'b1110; // sl
		3'b110: o_ALUctrl <= 4'b1100;
		3'b111: o_ALUctrl <= 4'b1101;
		endcase
	end
endmodule
