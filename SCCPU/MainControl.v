`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:07 07/31/2019 
// Design Name: 
// Module Name:    MainControl 
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
module MainControl(op,RegDst,Jump,Branch,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,PCToReg,ExtMode,sel);
	input [5:0]op;                                                       //input 6bit op code
	output reg [1:0] RegDst;
	output reg Jump,Branch,MemtoReg,MemWrite,ALUSrc,RegWrite,PCToReg,ExtMode;  //output 1bit signals
	output reg [3:0] ALUOp;                                                    //output 3bit ALU Control op code
	output reg sel;

	//combinatinal logic. we us always sentence
	always@(op) begin
		if(op==6'b100011) begin // lw
			ALUSrc<=1'b1;    
			RegDst<=2'b00;    
			RegWrite<=1'b1;  
			MemtoReg<=1'b1;  
			MemWrite<=1'b0;  
			ALUOp<=3'b000;    
			Jump<=1'b0;      
			Branch<=1'b0;      
			PCToReg<=1'b0;
			ExtMode<=1'b1; 
			sel<=0;
		end
		else if(op==6'b101011) begin // sw
			ALUSrc<=1'b1;     
			RegDst<=2'bxx;     
			RegWrite<=1'b0;   
			MemtoReg<=1'bx;   
			MemWrite<=1'b1;   
			ALUOp<=3'b000;    
			Jump<=1'b0;       
			Branch<=1'b0;       
			PCToReg<=1'b0;
			ExtMode<=1'b1; 
			sel<=0;
		end
		else if(op==6'b000010) begin // jump
			ALUSrc<=1'bx;     
			RegDst<=2'bxx;     
			RegWrite<=1'b0;   
			MemtoReg<=1'bx;   
			MemWrite<=1'b0;   
			ALUOp<=3'bx;     
			Jump<=1'b1;       
			Branch<=1'b0;    
			PCToReg<=1'b0;
			ExtMode<=1'bx; 
			sel<=0;
		end
		else begin
			ALUSrc<=1'bx;     
			RegDst<=2'bxx;    
			RegWrite<=1'bx;   
			MemtoReg<=1'bx;   
			MemWrite<=1'bx;   
			ALUOp<=3'bx;     
			Jump<=1'bx;      
			Branch<=1'bx;    
			PCToReg<=1'bx;
			ExtMode<=1'bx; 
			sel<=1;
		end
	end
endmodule
