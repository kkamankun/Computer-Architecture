`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
// Create Date	: 2020/04/20																		//
// Module Name	: MyControl 																		//
// Author		: Park Tae Sung																	//
// Student ID	: 2015722031																		//
// Description	: Output control signal for opcode of given mips instructions		//
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Mycontrol																							//
// ==============================================================================//
// Input		: op -> Op code																		//
//	Output	: RegDst -> Control Signal															//
//				: Jump -> Control Signal															//
//				: Branch -> Control Signal															//
//				: MemtoReg -> Control Signal														//
//				: ALUOp -> ALU Control Signal														//
//				: MemWrite -> Control Signal														//
//				: ALUSrc -> Control Signal															//
//				: RegWrite -> Control Signal														//
//				: PCToReg -> Control Signal														//
//				: ExtMode -> Extender control Signal											//
///////////////////////////////////////////////////////////////////////////////////
module MyControl(op,RegDst,Jump,Branch,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,PCToReg,ExtMode);
	input [5:0] op;                                  
	output reg [1:0] RegDst;
	output reg Jump,Branch,MemtoReg;                 
	output reg [3:0] ALUOp;                          
	output reg MemWrite,ALUSrc,RegWrite,PCToReg;
	output reg ExtMode;

	always@(op) begin
		if(op==6'b000000)begin   // R_TYPE(SLL, SRA, MULTU, JALR) -> failure
			ALUOp<=4'b0010;
			RegDst<=2'b01;
			ALUSrc<=1'b0;	
			RegWrite<=1'b1;
			MemtoReg<=1'b0;
			MemWrite<=1'b0;
			Jump<=1'b0;    
			Branch<=1'b0;
			PCToReg<=1'b0;
			ExtMode<=1'bx; 
		end
		else if(op==6'b000101) begin // bne -> success
			ALUOp<=4'b0001;   
			RegDst<=2'bxx;     
			ALUSrc<=1'b0;     
			RegWrite<=1'b0;   
			MemtoReg<=1'bx;   
			MemWrite<=1'b0;   
			Jump<=1'b0;       
			Branch<=1'b1;     
			PCToReg<=1'bx; 
			ExtMode<=1'b1; 
		end
		else if(op==6'b000011) begin // jal -> success
			ALUOp<=4'bxxxx;
			RegDst<=2'b10; 
			ALUSrc<=1'bx;  
			RegWrite<=1'b1;
			MemtoReg<=1'bx;
			MemWrite<=1'b0;
			Jump<=1'b1;  
			Branch<=1'bx;
			PCToReg<=1'b1;
			ExtMode<=1'bx; 
		end
		else if(op==6'b001110) begin // xori -> success
			ALUOp<=4'b0011;
			RegDst<=2'b00; 
         ALUSrc<=1'b1;  
         RegWrite<=1'b1;
         MemtoReg<=1'b0;
         MemWrite<=1'b0;
         Jump<=1'b0;    
         Branch<=1'b0; 
			PCToReg<=1'b0;
			ExtMode<=1'b0; 
      end
		else if(op==6'b001010) begin // slti -> success
			ALUOp<=4'b0100;
			RegDst<=2'b00; 
         ALUSrc<=1'b1;  
         RegWrite<=1'b1;
         MemtoReg<=1'b0;
         MemWrite<=1'b0;
         Jump<=1'b0;   
         Branch<=1'b0; 
 			PCToReg<=1'b0;
			ExtMode<=1'b1; 
      end
		else if(op==6'b001100) begin // andi -> failure
			ALUOp<=4'b1000;
			RegDst<=2'b00; 
			ALUSrc<=1'b1;
			RegWrite<=1'b1;
			MemtoReg<=1'b0;
			MemWrite<=1'b0;
			Jump<=1'b0;   
			Branch<=1'b0; 
			PCToReg<=1'b0;
			ExtMode<=1'b0; 
    end
		else if(op==6'b000100) begin // beq -> failure
			ALUOp<=4'b0001;   
			RegDst<=2'bxx;     
			ALUSrc<=1'b0;     
			RegWrite<=1'b0;   
			MemtoReg<=1'bx;   
			MemWrite<=1'b0;   
			Jump<=1'b0;       
			Branch<=1'b1;     
			PCToReg<=1'bx; 
			ExtMode<=1'b1; 
		end
		else begin  // default
			ALUOp<=4'bx;   
			RegDst<=2'bxx; 
			ALUSrc<=1'bx;  
			RegWrite<=1'bx;
			MemtoReg<=1'bx;
			MemWrite<=1'bx;
			Jump<=1'bx;    
			Branch<=1'bx;  
			PCToReg<=1'bx;
			ExtMode<=1'bx; 
		end
	end
endmodule
