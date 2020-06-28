`timescale 1ns / 1ps

module MultiCycleCPU(i_clk, i_rst_n, o_data_out, o_state);
	input i_clk, i_rst_n;
	output [7:0] o_state;
	output [31:0] o_data_out;
	
	wire [31:0] w_pc_current, w_pc_next, w_addr, w_read_mem, w_instr, w_rf_rd1, w_rf_rd2, w_signImm, w_alu_srcA, w_alu_srcB, w_alu_result, 
	w_alu_out, w_mem_data, w_rf_wd, w_NAR_out1, w_NAR_out2, w_shift2, w_write_mem, w_PCJump;
	wire w_IRWrite, w_RegWrite, w_MemWrite, w_MemRead, w_PCEn, w_Branch, w_Zero, w_PCWrite, temp;
	wire [1:0] w_IorD, w_PCSrc, w_RegDst, w_ALUsrcA, w_ALUsrcB_sel, w_MemtoReg;
	wire [2:0] w_alu_op;
	wire [3:0] w_ALUControl;
	wire [4:0] w_rf_addr;
	wire [27:0] w_jump_shift;
	
	assign temp = (w_Branch & w_Zero);
	assign w_PCEn = w_PCWrite | temp;
	assign w_shift2 = w_signImm<<2;
	assign w_jump_shift = {w_instr[25:0],2'b00};
	assign w_PCJump = {w_pc_current[31:28], w_jump_shift};
	assign o_data_out = w_pc_next; 
	
	PC 			   U0_PC (.o_pc(w_pc_current), .i_next_pc(w_pc_next), .i_clk(i_clk), .i_rst_n(i_rst_n), .i_pc_w_c(w_PCEn));
	MUX4_1         U1_MUX4_1(.sel(w_IorD), .i_data1(w_pc_current), .i_data2(w_alu_out), .i_data3(w_NAR_out2), .i_data4(x), .o_data(w_addr));     
	MEM 			   U2_MEMORY(.i_clk(i_clk),.i_rst_n(i_rst_n), .MemRead(w_MemRead), .MemWrite(w_MemWrite), 
	                         .i_addr(w_addr), .i_WriteData(w_write_mem), .o_MemData(w_read_mem));
	MDR 			   U3_MDR(.i_clk(i_clk), .i_data(w_read_mem), .o_data(w_mem_data));
	IR 			   U4_IR(.i_clk(i_clk), .IRWrite(w_IRWrite), .i_Instr(w_read_mem), .o_Instr(w_instr));
	TopFSM 			U5_TopFSM(.i_clk(i_clk), .i_rst_n(i_rst_n), .i_op(w_instr[31:26]), .i_funct(w_instr[5:0]), .i_zero(w_Zero), .PCWriteCond(w_Branch), .PCWrite(w_PCWrite), 
					          .IorD(w_IorD), .MemRead(w_MemRead), .MemWrite(w_MemWrite), .MemtoReg(w_MemtoReg),.IRWrite(w_IRWrite), .PCSource(w_PCSrc), .ALUOp(w_alu_op), 
					          .ALUSrcB(w_ALUsrcB_sel), .ALUSrcA(w_ALUsrcA), .RegWrite(w_RegWrite), .RegDst(w_RegDst), .c_state(o_state));
	MUX4_1   		U6_MUX4_1(.sel(w_RegDst), .i_data1(w_instr[20:16]), .i_data2(w_instr[15:11]), .i_data3(31), .i_data4(0), .o_data(w_rf_addr));
	MUX4_1         U7_MUX4_1(.sel(w_MemtoReg), .i_data1(w_alu_out), .i_data2(w_mem_data), .i_data3(w_pc_current), .i_data4(x), .o_data(w_rf_wd));	
	RF 			   U8_RF(.i_clk(i_clk), .i_rst_n(i_rst_n), .i_Read_reg1(w_instr[25:21]), .i_Read_reg2(w_instr[20:16]), 
						      .i_Write_reg(w_rf_addr), .i_Write_data(w_rf_wd), .RegWrite(w_RegWrite), .o_Read_data1(w_rf_rd1), .o_Read_data2(w_rf_rd2));
	A 			      U9_A(.i_clk(i_clk),.i_x(w_rf_rd1), .o_y(w_NAR_out1));
	B 			      U10_B(.i_clk(i_clk),.i_x(w_rf_rd2), .o_y(w_NAR_out2));
	MUX4_1         U11_MUX4_1(.sel(w_ALUsrcA), .i_data1(w_pc_current), .i_data2(w_NAR_out1), .i_data3(0), .i_data4(4), .o_data(w_alu_srcA));
	SEU 			   U12_SEU(.i_halfword(w_instr[15:0]), .o_word(w_signImm));    
	MUX4_1         U13_MUX4_1(.sel(w_ALUsrcB_sel), .i_data1(w_NAR_out2), .i_data2(4), .i_data3(w_signImm), .i_data4(w_shift2), .o_data(w_alu_srcB));
	ALUControl     U14_ALUControl(.i_funct(w_instr[5:0]), .i_ALUop(w_alu_op), .o_ALUctrl(w_ALUControl));   
	ALU 			   U15_ALU(.i_data1(w_alu_srcA), .i_data2(w_alu_srcB), .shamt(w_instr[10:6]), .ALUControl(w_ALUControl),.o_result(w_alu_result),.o_br(w_Zero));
	ALUOut    	   U16_ALUOut(.i_clk(i_clk), .i_alu_result(w_alu_result),.o_alu_out(w_alu_out)); 
	MUX4_1         U17_MUX4_1(.sel(w_PCSrc), .i_data1(w_alu_result), .i_data2(w_alu_out), .i_data3(w_PCJump), .i_data4(x), .o_data(w_pc_next));

endmodule

module MUX4_1(sel, i_data1, i_data2, i_data3, i_data4, o_data);
	input [31:0] i_data1, i_data2, i_data3, i_data4;
	input [1:0] sel;
	output reg [31:0] o_data;
	
	always@(i_data1, i_data2, i_data3, i_data4, sel)begin
		case(sel)
			0: o_data <= i_data1;
			1: o_data <= i_data2;
			2: o_data <= i_data3;
			3: o_data <= i_data4;
			default : o_data <= 32'bx;
		endcase
	end
endmodule