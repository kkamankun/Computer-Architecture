`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:28 07/31/2019 
// Design Name: 
// Module Name:    SingleCycle 
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
module SingleCycle(i_clk,i_rst_n,Out_RF_Write_Data,Out_PC);
	input i_clk, i_rst_n;
	output [31:0] Out_RF_Write_Data, Out_PC;

	wire [31:0] o_pc, o_instr, o_ADD_PC_sum, o_Read_data1, o_Read_data2;
	wire [31:0] o_DM_data, o_ALU_result, o_mux_wd, o_SEU_data, o_mux_wd_jal;
	wire [31:0] o_mux_alu, o_ADD_BR_sum, o_mux_br, o_mux_j, o_shift, o_shiftshift;
	wire [25:0] o_instr_shift;
	wire [4:0] o_mux_wr, o_mux_wr_jal;
	wire [3:0] ALUOp, o_ADD_PC_sum_shift;
	wire [4:0] ALU_funct;
	wire [1:0] RegDst;
	wire ALU_zero, ALU_overflow, ALU_carry, MemWrite, ALUSrc, MemtoReg, Jump, RegWrite, o_and, PCToReg, ExtMode;

	assign Out_RF_Write_Data = o_mux_wd_jal;
	assign Out_PC = o_pc;
	assign o_instr_shift=o_instr[25:0];
	assign o_ADD_PC_sum_shift=o_ADD_PC_sum[31:28];
	assign o_shift = {o_ADD_PC_sum_shift[3:0], o_instr_shift[25:0]}<<2;
	assign o_shiftshift = o_SEU_data<<2;

	PC 			U0_PC(i_clk,i_rst_n,o_mux_j,o_pc);// PC(program counter) instance
	IM 			U1_IM(o_pc,o_instr);// IM(instruction Memory) instance
	ADD_PC 		U2_ADD_PC(o_pc,32'h00000004,o_ADD_PC_sum);//	32_bit CLA adder (using "PC+4")instance
	RF 			U3_RF(i_clk,i_rst_n,o_instr[25:21],o_instr[20:16],o_mux_wr,o_mux_wd_jal,RegWrite,o_Read_data1,o_Read_data2);// RF(register file) instance
	ALU 			U4_ALU(o_Read_data1,o_mux_alu,o_instr[10:6],ALU_funct,o_ALU_result,ALU_zero,ALU_overflow,ALU_carry);// ALU instance
	DM 			U5_DM(i_clk,MemWrite,o_ALU_result,o_Read_data2,o_DM_data);// DM(data memory) instance
	SEU 			U6_SEU(o_instr[15:0],o_SEU_data,ExtMode);// SEU(sign extend) instance
	ADD_PC 		U7_ADD_BR(o_ADD_PC_sum,o_shiftshift,o_ADD_BR_sum);// 32_bit CLA (using branch instruction)
	mx2 			U8_MUX_JWD(o_mux_wd_jal,o_mux_wd,o_ADD_PC_sum,PCToReg); 
	mx4_to_1 	U9_mx4_to_1(o_mux_wr,o_instr[20:16],o_instr[15:11],5'd31,5'd0,RegDst);
	mx2 			U10_MUX_ALU(o_mux_alu,o_Read_data2,o_SEU_data,ALUSrc);// 32_bit 2_input mux (ALU second data port)
	mx2 			U11_MUX_WD(o_mux_wd,o_ALU_result,o_DM_data,MemtoReg);// 32_bit 2_input mux (DM output & ALU result port) 
	mx2 			U12_MUX_BR(o_mux_br,o_ADD_PC_sum,o_ADD_BR_sum,o_and);// 32_bit 2_input mux (using branch instrunction)
	mx2 			U13_MUX_J(o_mux_j,o_mux_br,o_shift,Jump);// 32_bit 2_input mux (using jump instruction)
	ControlTop	U14_ControlTop(o_instr[31:26],RegDst,Jump,Branch,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,PCToReg,ExtMode);//Control_Top instance
	ALUControl 	U15_ALUControl(o_instr[5:0],ALUOp,ALU_funct); // ALU_control instance
	And2 			U16__And(Branch,ALU_zero,o_and);// And instance(using branch instruction)
	
endmodule

module And2(a,b,y);
	input a,b;
	output y;
	
	assign y=a&b;
endmodule

module mx4_to_1(y, d0, d1, d2, d3, s);
	input [4:0] d0, d1, d2, d3;
	input [1:0] s;
	output reg [4:0] y;
	always@(d0, d1, d2, d3, s) begin
		case(s)
			2'b00: y=d0;
			2'b01: y=d1;
			2'b10: y=d2;
			2'b11: y=d3;
			default:;
		endcase
	end
endmodule

//2 to 1 mux module
module mx2(y, d0, d1, s);
	input [31:0]d0,d1;
	input s;
	output [31:0] y;
	
	assign y=(s==0)?d0:d1;
endmodule
