`timescale 1ns / 1ps

module TopFSM(i_clk, i_rst_n, i_op, i_funct, i_zero, PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, 
              PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst, c_state);
				  
	input [5:0] i_op, i_funct;
	input i_clk, i_rst_n, i_zero;
	output IRWrite, MemRead, MemWrite, PCWrite, PCWriteCond, RegWrite;
	output [1:0] IorD, MemtoReg, PCSource, ALUSrcA, ALUSrcB, RegDst;
	output [2:0] ALUOp;
	output [7:0] c_state;
	wire	x_IRWrite, x_MemRead, x_MemWrite, x_PCWrite, x_PCWriteCond, x_RegWrite;
	wire  y_IRWrite, y_MemRead, y_MemWrite, y_PCWrite, y_PCWriteCond, y_RegWrite;
	wire [1:0] x_IorD, x_MemtoReg, x_PCSource, x_ALUSrcA, x_ALUSrcB, x_RegDst, y_IorD, y_MemtoReg, y_PCSource, y_ALUSrcA, y_ALUSrcB, y_RegDst;
	wire [2:0] x_ALUOp, y_ALUOp;
	wire [7:0] x_c_state, x_n_state, y_c_state, y_n_state;
	wire [7:0] cur_state;
	
	reg x_rst_p_n, y_rst_p_n;
	wire my_rst_n, main_rst_n;
	
 	always @(y_n_state) begin
     if (y_n_state == 0) begin
       #0 x_rst_p_n = 1;
       #10 x_rst_p_n = 0;
     end
     else
       x_rst_p_n = 1;
   end
  
   always @(x_n_state) begin
     if (x_n_state == 0) begin
       #0 y_rst_p_n = 1;
       #10 y_rst_p_n = 0;
     end
     else
       y_rst_p_n = 1;
	end

	assign main_rst_n = i_rst_n & x_rst_p_n;
   assign my_rst_n   = i_rst_n & y_rst_p_n;
  
	MainFSM U1_MainFSM(i_clk, main_rst_n, i_op, i_funct, i_zero, x_PCWriteCond, x_PCWrite, x_IorD, x_MemRead, x_MemWrite, x_MemtoReg, x_IRWrite, 
              x_PCSource, x_ALUOp, x_ALUSrcB, x_ALUSrcA, x_RegWrite, x_RegDst, x_c_state, x_n_state);

//   MyFSM U2_MyFSM(i_clk, my_rst_n, i_op, i_funct, i_zero, y_PCWriteCond, y_PCWrite, y_IorD, y_MemRead, y_MemWrite, y_MemtoReg, y_IRWrite, 
//              y_PCSource, y_ALUOp, y_ALUSrcB, y_ALUSrcA, y_RegWrite, y_RegDst, y_c_state, y_n_state);


   assign IorD = (x_c_state == 255 ) ? y_IorD : x_IorD;
	assign MemtoReg = (x_c_state == 255 ) ? y_MemtoReg : x_MemtoReg;
	assign IRWrite = (x_c_state == 255 ) ? y_IRWrite : x_IRWrite;
	assign MemRead = (x_c_state == 255 ) ? y_MemRead : x_MemRead;
	assign MemWrite = (x_c_state == 255 ) ? y_MemWrite : x_MemWrite;
	assign PCWrite = (x_c_state == 255 ) ? y_PCWrite : x_PCWrite;
	assign PCWriteCond = (x_c_state == 255 ) ? y_PCWriteCond : x_PCWriteCond;
	assign RegWrite = (x_c_state == 255 ) ? y_RegWrite : x_RegWrite;
	assign PCSource = (x_c_state == 255 ) ? y_PCSource : x_PCSource;
	assign ALUSrcA = (x_c_state == 255 ) ? y_ALUSrcA : x_ALUSrcA;
	assign ALUSrcB = (x_c_state == 255 ) ? y_ALUSrcB : x_ALUSrcB;
	assign RegDst = (x_c_state == 255 ) ? y_RegDst : x_RegDst;
	assign ALUOp = (x_c_state == 255 ) ? y_ALUOp : x_ALUOp;
	assign c_state = (x_c_state == 255 ) ? y_c_state : x_c_state;

endmodule
