`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:22:40 PM
// Design Name: 
// Module Name: register_file_tb
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


module register_file_tb();
    reg clk;
    reg we;
    reg[31:0] d_in;
    reg[3:0] rd_sel; // 4-bit rd selector for 16 regs // one write channel
    reg[3:0] rs_sel; // two read channel
    reg[3:0] rt_sel;
    reg[31:0] rs;
    reg[31:0] rt;
    
    initial begin
        clk <= 1'b0; we <= 1'b0; #5;
        clk <= 1'b1; #5;
        clk <= 1'b0; rd_sel <=4'd4; d_in <= 32'd16; #5;
        clk <= 1'b1; #5;
        for(int i = 0; i < 8; i++) begin
            clk <= 1'b0; rs_sel <= i; rt_sel <= i + 8; #5;
            clk <= 1'b1; #5;
        end
        clk <= 1'b0; we <= 1'b1; #10;
        clk <= 1'b1; #5;
        clk <= 1'b0; rd_sel <= 4'd4; d_in <= 32'd16; #5;
        clk <= 1'b1; #5;
        for(int i = 0; i < 8; i++) begin
            clk <= 1'b0; rs_sel <= i; rt_sel <= i + 8; #5;
            clk <= 1'b1; #5;
        end
        clk <= 1'b0; we <= 1'b1; #5;
        clk <= 1'b1; #5;
        clk <= 1'b0; rd_sel <= 4'd1; d_in <= 32'd16; #5;
        clk <= 1'b1; #5;
        for(int i = 0; i < 8; i++) begin
            clk <= 1'b0; rs_sel <= i; rt_sel <= i + 8; #5;
            clk <= 1'b1; #5;
        end
        $stop();
    end
    register_file dut (.clk, .we, .d_in, .rd_sel, .rs_sel, .rt_sel, .rs, .rt);
endmodule
