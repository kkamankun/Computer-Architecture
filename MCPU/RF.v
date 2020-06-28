`timescale 1ns / 1ps

module RF(i_clk,i_rst_n,i_Read_reg1,i_Read_reg2,i_Write_reg,i_Write_data,
          RegWrite, o_Read_data1, o_Read_data2);
	input i_clk, i_rst_n, RegWrite;                     //input 1bit clock, reset, write signal
	input [4:0] i_Read_reg1, i_Read_reg2, i_Write_reg;//input 5bit 3 registers
	input [31:0] i_Write_data;                        //input 32bit data
	output [31:0] o_Read_data1, o_Read_data2;         //output 32bit datas

	reg [31:0] regs [0:31];
	
	always @(posedge i_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			regs[0] <= 32'b0;  regs[1]  <= 32'b0; regs[2]  <= 32'b0; regs[3]  <= 32'b0; regs[4]  <= 32'b0; 
			regs[5] <= 32'b0;  regs[6]  <= 32'b0; regs[7]  <= 32'b0; regs[8]  <= 32'b0; regs[9]  <= 32'b0; 
			regs[10] <= 32'b0; regs[11] <= 32'b0; regs[12] <= 32'b0; regs[13] <= 32'b0; regs[14] <= 32'b0; 
			regs[15] <= 32'b0; regs[16] <= 32'b0; regs[17] <= 32'b0; regs[18] <= 32'b0; regs[19] <= 32'b0; 
			regs[20] <= 32'b0; regs[21] <= 32'b0; regs[22] <= 32'b0; regs[23] <= 32'b0; regs[24] <= 32'b0; 
			regs[25] <= 32'b0; regs[26] <= 32'b0; regs[27] <= 32'b0; regs[28] <= 32'b0; regs[29] <= 32'b0; 
			regs[30] <= 32'b0; regs[31] <= 32'b0;
		end
		else begin
			if (RegWrite)
				regs[i_Write_reg] <= i_Write_data;
			else
				regs[i_Write_reg] <= regs[i_Write_reg];
		end
	end

	assign o_Read_data1 = (i_Read_reg1 == 32'b0) ? 32'b0 : regs[i_Read_reg1];
	assign o_Read_data2 = (i_Read_reg2 == 32'b0) ? 32'b0 : regs[i_Read_reg2];

endmodule
