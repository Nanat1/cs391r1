`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 03:27:19 AM
// Design Name: 
// Module Name: control_unit_tb
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


module control_unit_tb();
    reg clk;
    reg rst;
    reg[31:0] instruction;
    reg valid;
    reg ready;
    reg error;
    
    initial begin
        clk <= 1'b0; rst = 1'b1; #5;
        clk <= 1'b1; #5;
        clk <= 1'b0; rst = 1'b0; valid = 1'b1; 
        
        instruction <= 32'b010001000100000010; #5; // zero out reg[4]
        clk <= 1'b1; #5;
        clk <= 1'b0; instruction <= 32'b1010101001000000100001; #5; // assign 10101010 to reg[0]
        clk <= 1'b1; #5;
        clk <= 1'b0; instruction <= 32'b0101010101000001100001; #5; // 01010101 to reg[1]
        clk <= 1'b1; #5;
        clk <= 1'b0; 
        instruction[5:0] <= 6'd0; instruction[9:6] <= 4'd2; instruction[13:10] <= 4'd0; instruction[31:14] <= 18'd1; #5;
        clk <= 1'b1; #5;
        
        for(int i = 1; i <= 12; i++) begin
            clk <= 1'b0; instruction[5:0] <= i; #5;
            clk <= 1'b1; #5;
        end
        
        for(int i = 16; i < 28; i++) begin
            clk <= 1'b0; instruction[5:0] <= i; instruction[31:14] <= 18'd5; #5;
            clk <= 1'b1; #5;
        end
        
        $stop();
    end
    control_unit dut (.clk, .rst, .instruction, .valid, .ready, .error);
endmodule
