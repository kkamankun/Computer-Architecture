`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:19 07/31/2019 
// Design Name: 
// Module Name:    ControlTop 
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
module ControlTop(op,RegDst,Jump,Branch,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,PCToReg,ExtMode);
	input [5:0]op;
	output wire [1:0] RegDst;
	output Jump,Branch,MemtoReg,MemWrite,ALUSrc,RegWrite,PCToReg,ExtMode;  //output 1bit signals
	output [3:0] ALUOp;                                                    //output 2bit ALU Control op code

	wire sel;
	wire [1:0] RegDst_main, RegDst_my;
	wire MemWrite_main,ALUSrc_main,MemtoReg_main,Jump_main,RegWrite_main,PCToReg_main,ExtMode_main;
	wire MemWrite_my,ALUSrc_my,MemtoReg_my,Jump_my,RegWrite_my,PCToReg_my,ExtMode_my;
	wire [3:0] ALUOp_main,ALUOp_my;

	MainControl U0_MainControl(op,RegDst_main,Jump_main,Branch_main,MemtoReg_main,ALUOp_main,MemWrite_main,ALUSrc_main,RegWrite_main,PCToReg_main,ExtMode_main,sel);//Main_control instance
	MyControl 	U1_MyControl(op,RegDst_my,Jump_my,Branch_my,MemtoReg_my,ALUOp_my,MemWrite_my,ALUSrc_my,RegWrite_my,PCToReg_my,ExtMode_my);//My_control instance

	mx2 		U2_MUX_RegDst(RegDst,RegDst_main,RegDst_my,sel);
	mx2 		U3_MUX_Jump(Jump,Jump_main,Jump_my,sel);
	mx2 		U4_MUX_Branch(Branch,Branch_main,Branch_my,sel);
	mx2 		U6_MUX_MemtoReg(MemtoReg,MemtoReg_main,MemtoReg_my,sel);
	mx2 		U7_MUX_MemWrite(MemWrite,MemWrite_main,MemWrite_my,sel);
	mx2 		U8_MUX_ALUSrc(ALUSrc,ALUSrc_main,ALUSrc_my,sel);
	mx2 		U9_MUX_RegWrite(RegWrite,RegWrite_main,RegWrite_my,sel);
	mx2 		U10_MUX_PCToReg(PCToReg,PCToReg_main,PCToReg_my,sel);
	mx2		U11_MUX_ALUOp(ALUOp,ALUOp_main,ALUOp_my,sel);
	mx2		U12_MUX_ExtMode(ExtMode,ExtMode_main,ExtMode_my,sel);
endmodule
