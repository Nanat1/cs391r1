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

// copied from Lab1
module alu #(
    parameter OP_WIDTH = 1
) (
    input wire [OP_WIDTH-1:0] op1,
    input wire [OP_WIDTH-1:0] op2,
    input wire [3:0] control,
    output reg error,
    output reg [OP_WIDTH-1:0] res
);
    always_comb begin
        assign error = 1'b0;
        if (control == 4'b0000) begin // NOT
            res = ~op1;
        end else if (control == 4'b0001) begin // XOR
            res = op1 ^ op2;
        end else if (control == 4'b0010) begin // AND
            res = op1 & op2;
        end else if (control == 4'b0011) begin // OR
            res = op1 | op2;
        end else if (control == 4'b0100) begin // XNOR
            res = ~(op1 ^ op2);
        end else if (control == 4'b0101) begin // LOG LSHIFT
            if (op2 > OP_WIDTH) begin
                res = -1;
                assign error = 1'b1;
            end else begin
                res = op1 << op2;
            end
        end else if (control == 4'b0110) begin // LOG RSHIFT
            if (op2 > OP_WIDTH) begin
                res = -1;
                assign error = 1'b1;
            end else begin
                res = op1 >> op2;
            end
        end else if (control == 4'b0111) begin // ART LSHIFT
            if (op2 > OP_WIDTH) begin
                res = -1;
                assign error = 1'b1;
            end else begin
                res = op1 <<< op2;
            end
        end else if (control == 4'b1000) begin // ART RSHIFT
            if (op2 > OP_WIDTH) begin
                res = -1;
                assign error = 1'b1;
            end else begin
                res = op1 >>> op2;
            end
        end else if (control == 4'b1001) begin // ADD
            res = op1 + op2;
        end else if (control == 4'b1010) begin // SUB
            res = op1 - op2;
        end else if (control == 4'b1011) begin // EQ
            if (op1 == op2) begin
                res = 1;
            end else begin
                res = 0;
            end
        end else if (control == 4'b1100) begin // LT
            if (op1 < op2) begin
                res = 1;
            end else begin
                res = 0;
            end
        end else if (control == 4'b1101) begin // GT
            if (op1 > op2) begin
                res = 1;
            end else begin
                res = 0;
            end
        end else begin
            res = -1;
            assign error =  1'b1;
        end
    end
endmodule
