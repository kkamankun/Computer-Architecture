`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:23:17 07/31/2019 
// Design Name: 
// Module Name:    IM 
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
module IM(i_addr, o_instr);       
	input [31:0]  i_addr;       //input 32bit address
	output [31:0] o_instr;      //output 32bit instruction
	reg [31:0]    o_instr;      //reg 32bit instruction

	reg [7:0] inst_mem[0:255]; //8bit memory array, depth 256

	initial	begin
		$readmemb("machinecode.txt", inst_mem);    //readmemb task read binary data in machinecode.txt and store each memory
	end

	always @(i_addr) begin
		o_instr[7:0]  <=inst_mem[i_addr+3];
		o_instr[15:8] <=inst_mem[i_addr+2];
		o_instr[23:16]<=inst_mem[i_addr+1];
		o_instr[31:24]<=inst_mem[i_addr]; 
	end
 endmodule
 