`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2025 03:11:25 PM
// Design Name: 
// Module Name: light_controller_tb
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


module light_controller_tb();
    reg clk;
    reg rst;
    reg button;
    reg[2:0] light_state;
    
    initial begin
        clk <= 1'b0; button <= 1'b0; #10;
        clk <= 1'b1; #5;
        clk <= 1'b0; button <= 1'b1; #5;
        clk <= 1'b1; #5;
        for(int i = 0; i < 10; i++) begin
            clk <= 1'b0; #5;
            clk <= 1'b1; #5;
        end
        clk <= 1'b0; button <= 1'b0; #5;
        clk <= 1'b1; #5;
        clk <= 1'b0; button <= 1'b1; #5;
        clk <= 1'b1; #5;
        for(int i = 0; i < 10; i++) begin
            clk <= 1'b0; #5;
            clk <= 1'b1; #5;
        end
        $stop();
    end
    light_controller #(3E8) dut (.clk, .rst, .button, .light_state); // 3 sc * 100M Hz
endmodule

