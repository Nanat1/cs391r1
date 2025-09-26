`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2025 04:29:51 PM
// Design Name: 
// Module Name: alu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_tb();
    reg op1;
    reg op2;
    reg control;
    reg res;
    
    initial begin
        control <= 1; op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 0;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        $stop();
    end
    alu dut (.res, .op1);
endmodule
