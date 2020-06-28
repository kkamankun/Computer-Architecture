`timescale 1ns / 1ps

module MainFSM(i_clk, i_rst_n, i_op, i_funct, i_zero, PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, 
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
   parameter Mem_Adr = 2;
   parameter Mem_Read = 3;
   parameter Mem_Writeback = 4;
   parameter Mem_Write = 5;
   parameter ADDI_Writeback = 6;
   parameter Execute = 7;
   parameter ALU_Writeback = 8;
   parameter Branch = 9;
	parameter ANDI_Execute = 10;
	parameter JAL_Writeback = 11;
   parameter Jump = 12;	
	parameter SLTI_Execute = 13;
	parameter BGE = 14;
	parameter LWAI_Execute = 20;
	parameter LWAI_Mem_Read = 21;
	parameter LWAI_Rd_WriteBack = 22;
	parameter LWAI_Rt_Incr = 23;
	
//	parameter DIV4_Execute1 = 30;
//	parameter DIV4_Writeback1 = 31;
//	parameter DIV4_ReadData = 32;
//	parameter DIV4_Execute2 = 33;
//	parameter DIV4_Writeback2 = 34;
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
         Fetch: begin IorD <= 0; 
                      ALUSrcA <= 0;
                      ALUSrcB <= 2'b01;
                      ALUOp <= 3'b0;
                      PCSource <= 0;
                      IRWrite <= 1;
                      PCWrite <= 1;
                      MemRead <= 1;
                      MemWrite <= 0;// necessary, enable unset 
                      PCWriteCond <=0;// necessary, enable unset
                      RegWrite <=0;// necessary, enable unset
                      next <= Decode;
         end
         Decode: begin IorD <= 2'bxx;
                       MemWrite <= 0;
                       MemRead <= 0;// necessary, enable unset, 
                       PCWrite <= 0; // necessary, enable unset
                       ALUOp <= 3'b0;
                       ALUSrcA <= 0;
                       ALUSrcB <= 2'b11;
                       RegWrite <= 0;
                       IRWrite <= 0; // necessary, enable unset
                       case(i_op)
                          0: begin
                              if(i_funct == 6'b0)    //NOP
                                 next <= Fetch;
										else if(i_funct == 6'b000100) // sllv
											next <= Execute;
										else if(i_funct == 6'b100110) // xor
											next <= Execute;
                              else
                                 next <= UnDefined;
                          end
								  1: next <= Branch; // bltz
                          2: next <= Jump; // j
								  3:	begin // jal
										next <= JAL_Writeback;
										RegWrite <= 1'b1;
										RegDst <= 2'b10;
										MemtoReg <= 2'b00;
										end
                          4: next <= Branch; // beq
                          8: next <= Mem_Adr; // addi
								  10: next <= SLTI_Execute; // slti
								  12: next <= ANDI_Execute; // andi
								  14: next <= BGE; // bge
                          35: next <= Mem_Adr; // lw
								  36: next <= LWAI_Execute; // lwai
                          43: next <= Mem_Adr; // sw
                          default: next <= UnDefined;
                       endcase
                  end
         Mem_Adr: begin 
                  ALUSrcA <= 1;
                  ALUSrcB <= 2'b10;
                  ALUOp <= 3'b0;
                  if(i_op == 35) next <= Mem_Read; // lw
                  else if(i_op == 43) next <= Mem_Write; // sw
                  else if(i_op == 8) next <= ADDI_Writeback; // addi
                  else next <= Execute;
                  end
         Mem_Read: begin
                      IorD <= 1;
                      MemRead <= 1;
                      next <= Mem_Writeback;
         end                 
         Mem_Writeback: begin 
                    RegDst <= 2'b00;
                    MemtoReg <= 1;
                    RegWrite <= 1;
                    MemRead <= 0;// necessary, enable unset,
                    next <= Fetch;
         end                  
         Mem_Write: begin
                    IorD <= 1;
                    MemWrite <= 1;
                    next <= Fetch;
                    end
         Execute: begin
                    MemWrite <= 0;
                    IRWrite <= 0;
                    PCWrite <= 0;
                    PCWriteCond <= 0;
                    ALUSrcA <= 1;
                    ALUSrcB <= 0;
                    ALUOp <= 2;
                    RegWrite <= 0;
                    next <= ALU_Writeback;
                    end
         ALU_Writeback: begin 
                      MemWrite <= 0;
                      MemtoReg <= 0;
                      IRWrite <= 0;
                      PCWrite <= 0;
                      PCWriteCond <= 0;
                      RegDst <= 2'b01;
                      RegWrite <= 1;
                      next <= Fetch;
                      end
         ADDI_Writeback: begin 
                      RegDst <= 2'b00;
                      MemtoReg <= 0;
                      RegWrite <= 1;
                      next <= Fetch;
                      end
         Branch: begin 
                    ALUSrcA <= 1;
                    ALUSrcB <= 0;
                    ALUOp <= 1;
                    PCSource <= 1;
                    PCWriteCond <= 1;
                    next <= Fetch;
                    end
         Jump: begin
               PCSource <=2;
               PCWrite <= 1;
               RegWrite <= 0;
               next <= Fetch;
               end
			///// BGE /////
			BGE:	begin
					PCSource <= 2'b01;
					PCWriteCond <= 1'b1;
					ALUOp <= 3'b100;
					ALUSrcB <= 2'b00;
					ALUSrcA <= 2'b01;
					next <= Fetch;
					end
			///// ANDI_Execute /////
			ANDI_Execute: begin
					ALUOp <= 3'b011;
					ALUSrcB <= 2'b10;
					ALUSrcA <= 2'b01;
					next <= ADDI_Writeback;
					end
			///// LWAI_Execute /////
			LWAI_Execute: begin
					ALUOp <= 3'b010;
					ALUSrcB <= 2'b00;
					ALUSrcA <= 2'b01;
					next <= LWAI_Mem_Read;
					end
			///// LWAI_Mem_Read /////
			LWAI_Mem_Read: begin
					IorD <= 1;
               MemRead <= 1;
               next <= LWAI_Rd_WriteBack;
					end 
			///// LWAI_Rd_WriteBack /////
			LWAI_Rd_WriteBack: begin
               MemRead <= 0;
					MemtoReg <= 2'b01;
					ALUSrcA <= 2'b11;
					RegDst <= 2'b01;
               RegWrite <= 1;
               next <= LWAI_Rt_Incr;
               end
			///// LWAI_Rt_Incr /////
			LWAI_Rt_Incr: begin
					MemtoReg <= 2'b00;
					RegDst <= 2'b00;
               RegWrite <= 1;
               next <= Fetch;
               end
			///// SLTI_Execute /////
			SLTI_Execute: begin
					ALUOp <= 3'b100;
					ALUSrcB <= 2'b10;
					ALUSrcA <= 2'b01;
					next <= ADDI_Writeback;
					end
			///// JAL_Writeback /////
			JAL_Writeback: begin
			      PCSource <=2;
               PCWrite <= 1;
               RegWrite <= 0;
               next <= Fetch;
               end
			/* DIV4_Execute1: begin
					ALUOp <= 3'b010;
					ALUSrcB <= 2'b00;
					ALUSrcA <= 2'b01;
					next <= DIV4_Writeback1;
					end */
			/* DIV4_Writeback1: begin
					MemtoReg <= 2'b00;
					RegDst <= 2'b00;
               RegWrite <= 1;
               next <= DIV4_ReadData;
               end */
			/* DIV4_ReadData: begin
					MemtoReg <= 2'bxx;
					RegDst <= 2'bxx;
               RegWrite <= 0;
               next <= DIV4_ReadData;
               end */
			/* DIV4_Execute2: begin
					ALUOp <= 3'b111;
					ALUSrcB <= 2'b00;
					ALUSrcA <= 2'b01;
					next <= DIV4_Writeback2;
					end */
			/* DIV4_Writeback2: begin
					MemtoReg <= 2'b00;
					RegDst <= 2'b00;
               RegWrite <= 1;
               next <= Fetch;
               end */
         UnDefined : begin
             next <= UnDefined;
             end
         default: next <= state;
      endcase
   end
endmodule
