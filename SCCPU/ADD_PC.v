`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:57 07/31/2019 
// Design Name: 
// Module Name:    ADD_PC 
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
module ADD_PC(i_data1,i_data2,o_sum);
  input [31:0]i_data1;      //input 32bit data
  input [31:0]i_data2;      //input 32bit data
  output [31:0]o_sum;       //output 32bit sum, not carry out
  
  assign o_sum = i_data1 + i_data2;  
endmodule
