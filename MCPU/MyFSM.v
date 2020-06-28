`timescale 1ns / 1ps

module MyFSM(i_clk, i_rst_n, i_op, i_funct, i_zero, PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, 
           ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst, cur_state, nxt_state);
	
	input [5:0] i_op, i_funct;
	input i_clk, i_rst_n, i_zero;
	output reg IRWrite, MemRead, MemWrite, PCWrite, PCWriteCond, RegWrite;
	output reg[1:0] IorD, MemtoReg, PCSource, ALUSrcA, ALUSrcB, RegDst;
	output reg[2:0] ALUOp;
	output [7:0] cur_state, nxt_state;
	reg [7:0] state, next;
	
	parameter Fetch = 0;
	parameter Decode = 1;
	///////////////////////////////////////////
	parameter Mem_Read = 3;
	parameter Mem_Writeback = 4;
	parameter ADDI_Writeback = 6;
	parameter ANDI_Execute = 10;
	parameter JAL_Writeback = 11;
	parameter Jump = 12;
	parameter SLTI_Execute = 13;
	parameter BGE = 14;
	parameter LWAI = 15;
	parameter LWAI_Adr=16;
	///////////////////////////////////////////
	parameter UnDefined = 255;
	
	assign cur_state = state;
	assign nxt_state = next;
	
	always@(posedge i_clk or negedge i_rst_n)begin //sequencial logic
		if(!i_rst_n)
			state <= Fetch;
		else 
			state <= next;
	end
	
	always@(state, i_op, i_zero)begin  // state & output logic
		next <= 4'bx;  
		case(state)
			///////////////////////////////////////////////////////////////////////////
			//                                부분을 채워주세                       //
			///////////////////////////////////////////////////////////////////////////
			UnDefined : begin
			    next <= UnDefined;
			end
			default: next <= state;
		endcase
	end
endmodule
