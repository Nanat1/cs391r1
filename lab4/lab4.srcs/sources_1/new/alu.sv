`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 03:23:04 PM
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
        if (control[3] == 1) begin
            if (control[2:0] == 3'h0) begin // EQ
                if (op1 == op2) begin
                    res = 1;
                end else begin
                    res = 0;
                end
                
            end else if (control[2:0] == 3'h1) begin // NEQ
                if (op1 == op2) begin
                    res = 0;
                end else begin
                    res = 1;
                end
            
            end else if (control[2:0] == 3'h4) begin // LT
                if ($signed(op1) < $signed(op2)) begin
                    res = 32'd1;
                end else begin
                    res = 32'b0;
                end
                
            end else if (control[2:0] == 3'h5) begin // GEQ
                if ($signed(op1) >= $signed(op2)) begin
                    res = 32'd1;
                end else begin
                    res = 32'b0;
                end
                
            end else begin
                res = -1;
                assign error =  1'b1;
            end
        end else begin
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
            // end else if (control == {1'b1, 3'h5}) begin // ARTH RSHIFT
                // res = op1 >>> op2;
            end else if (control == 4'h0) begin // ADD
                res = op1 + op2;
            // end else if (control == {1'b1, 3'h0}) begin // SUB
                // res = op1 - op2;
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
    end
endmodule
