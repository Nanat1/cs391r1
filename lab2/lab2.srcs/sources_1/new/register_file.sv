`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:07:30 PM
// Design Name: 
// Module Name: register_file
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


module register_file #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire we,
    input wire[WIDTH-1:0] d_in,
    input wire[3:0] rd_sel, // 4-bit rd selector for 16 regs // one write channel
    input wire[3:0] rs_sel, // two read channel
    input wire[3:0] rt_sel,
    output wire[WIDTH-1:0] rs,
    output wire[WIDTH-1:0] rt
);
    reg [WIDTH-1:0] regs [0:15];
    assign rs = regs[rs_sel[3:0]]; // [0:3] will result in 
    assign rt = regs[rt_sel[3:0]]; // part-select direction is opposite from prefix index direction
    
    always @(posedge clk) begin
        if (we) begin
            regs[rd_sel[3:0]] <= d_in;
        end
    end
endmodule
