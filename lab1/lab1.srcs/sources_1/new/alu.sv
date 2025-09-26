`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2025 04:21:44 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input wire op1,
    input wire op2,
    input wire [2:0] control,
    input wire error,
    output reg res
    );
    always_comb begin
        if (control == 0) begin // NOT
            res = ~op1;
        end else if (control == 1) begin // XOR
            res = op1 ^ op2;
        end else if (control == 10) begin // AND
            res = op1 & op2;
        end else if (control == 11) begin // OR
            res = op1 | op2;
        end else begin // XNOR
            res = ~(op1 ^ op2);
        end
    end
endmodule
