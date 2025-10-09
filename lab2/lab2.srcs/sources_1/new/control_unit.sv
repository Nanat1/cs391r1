`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 05:33:55 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire[WIDTH-1:0] instruction,
    input wire valid,
    output reg ready,
    output reg error
);
    reg[5:0] opcode;
    reg[3:0] op1;
    reg[3:0] op2;
    reg[3:0] op3;
    reg[17:0] imm;
    
    reg[WIDTH-1:0] rs;
    reg[WIDTH-1:0] rt;
    reg[WIDTH-1:0] rd;
    reg we;
    
    reg[WIDTH-1:0] arg;
    
    always @(posedge clk) begin
        if (rst) begin // reset instructions
            assign error = 1'b0;
            assign ready = 1'b1;
        end
        if (ready && valid) begin // && for logic AND
            assign ready = 1'b0;
            assign error = 1'b0;
            we <= 1'b1; // for these opcodes, we is always true
            opcode <= instruction[5:0];
            op1 <= instruction[9:6];
            op2 <= instruction[13:10];
            if (opcode[5]) begin // Type B
                imm <= instruction[31:14];
                arg <= imm;
            end else begin
                op3 <= instruction[17:14];
                arg <= rt;
            end // finished reading from the instructor
        end
        assign ready = 1'b1;
    end
    
    alu #(32) instance_alu (
        .op1(rs),
        .op2(arg),
        .control(opcode[3:0]),
        .error(error),
        .res(rd)
    );
    
    register_file instance_register_file (
        .clk(clk),
        .we(we),
        .d_in(rd),
        .rd_sel(op1),
        .rs_sel(op2),
        .rt_sel(op3),
        .rs(rs),
        .rt(rt)
    );
endmodule
