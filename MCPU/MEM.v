`timescale 1ns / 1ps

module MEM(i_clk,i_rst_n, MemRead, MemWrite, i_addr, i_WriteData, o_MemData);
	input [31:0] i_addr, i_WriteData;
	input i_clk,i_rst_n, MemRead,MemWrite;
	output reg [31:0]o_MemData;
	
	reg [7:0] memory [255:0];
	
	initial begin
		$readmemb("inst.txt", memory,0,127);
		$readmemb("data.txt", memory,128,255);
	end
	
	always@(posedge i_clk)begin
		if(MemWrite)begin
			memory[i_addr]   <= i_WriteData[31:24];
			memory[i_addr+1] <= i_WriteData[23:16];
			memory[i_addr+2] <= i_WriteData[15:8];
			memory[i_addr+3] <= i_WriteData[7:0];
		end
		else begin
			memory[i_addr]   <= memory[i_addr];
			memory[i_addr+1] <= memory[i_addr+1];
			memory[i_addr+2] <= memory[i_addr+2];
			memory[i_addr+3] <= memory[i_addr+3];
		end
		
	end
	
	always@(i_addr or MemRead or memory or o_MemData)begin
		if(MemRead)begin
			o_MemData[31:24] <= memory[i_addr];
			o_MemData[23:16] <= memory[i_addr+1];
			o_MemData[15:8]  <= memory[i_addr+2];
			o_MemData[7:0]   <= memory[i_addr+3];
		end
		else begin
			o_MemData[31:24] <= o_MemData[31:24];
			o_MemData[23:16] <= o_MemData[23:16];
			o_MemData[15:8]  <= o_MemData[15:8];
			o_MemData[7:0]   <= o_MemData[7:0];
		end		
	end	
endmodule
