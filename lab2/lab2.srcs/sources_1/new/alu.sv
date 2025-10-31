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
    parameter OP_WIDTH = 32
) (
    input wire [OP_WIDTH-1:0] op1,
    input wire [OP_WIDTH-1:0] op2,
    input wire [3:0] control,
    output reg error,
    output reg [OP_WIDTH-1:0] res
);
    always_comb begin
        assign error = 1'b0;
        if (control == 4'h4) begin // XOR
            res = op1 ^ op2;
        end else if (control == 4'h6) begin // OR
            res = op1 | op2;
        end else if (control == 4'h7) begin // AND
            res = op1 & op2;
        end else if (control == 4'h1) begin // LOG LSHIFT
            res = op1 << op2;
        end else if (control == 4'h5) begin // LOG RSHIFT
            res = op1 >> op2;
        end else if (control == {1'b1, 3'h5}) begin // ARTH RSHIFT
            res = op1 >>> op2;
        end else if (control == 4'h0) begin // ADD
            res = op1 + op2;
        end else if (control == {1'b1, 3'h0}) begin // SUB
            res = op1 - op2;
        end else if (control == 4'h2) begin // LT
            if ($signed(op1) < $signed(op2)) begin
                res = 32'd1;
            end else begin 
                res = 32'b0;
            end
        end else if (control == 4'h3) begin // LT(U)
            if (op1 < op2) begin
                res = 32'd1;
            end else begin 
                res = 32'b0;
            end
        end else begin
            res = -1;
            assign error =  1'b1;
        end
    end
endmodule
