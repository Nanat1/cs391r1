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
    reg [3:0] control;
    reg res;
    reg error;
    
    initial begin
        control <= 4'b0001; op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0000;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0010;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0011;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0100;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0101;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0110;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b0111;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1000;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1001;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1010;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1011;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1100;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1101;  op1 <= 1; op2 <= 1; #10;
        op2 <= 0; #10;
        op1 <= 0; #10;
        op2 <= 1; #10;
        control <= 4'b1111; #10; // ERROR CASE
        $stop();
    end
    alu #(.OP_WIDTH(1)) dut (.res, .op1, .op2, .control, .error);
endmodule
