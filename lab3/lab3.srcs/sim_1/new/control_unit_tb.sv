`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 05:56:47 AM
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
    
    wire [31:0] x0, t0, t1, t2;
    
    assign x0 = dut.reg_file.regs[0];
    assign t0 = dut.reg_file.regs[5];
    assign t1 = dut.reg_file.regs[6];
    assign t2 = dut.reg_file.regs[7];
    
    initial begin
        clk <= 1'b0; rst = 1'b1; #10;
        
        rst = 1'b0;
        instruction <= {12'd10, 5'd0, 3'd0, 5'd0, 7'b0010011}; // addi x0, x0, 10.
        valid = 1'b1; #40;
        
        instruction <= {12'hfff, 5'd0, 3'd6, 5'd0, 7'b0010011}; // ori, x0, x0, -1.
        valid = 1'b1; #40;
        
        instruction <= {20'hfa0af, 5'd5, 7'b0110111}; // lui, t0, 0xfa0af.
        valid = 1'b1; #40;
        
        instruction <= {20'h15f51, 5'd6, 7'b0110111}; // lui, t1, 0x15f51.
        valid = 1'b1; #40;
        
        instruction <= {12'h123, 5'd5, 3'd0, 5'd7, 7'b0010011}; // addi t2, t0, 0x123.
        valid = 1'b1; #40;
        
        instruction <= {12'h800, 5'd6, 3'd0, 5'd7, 7'b0010011}; // addi t2, t1, 0x800.
        valid = 1'b1; #40;
        
        instruction <= {12'hfff, 5'd5, 3'd4, 5'd7, 7'b0010011}; // xori t2, t0, -1.
        valid = 1'b1; #40;
        
        instruction <= {12'hfff, 5'd6, 3'd7, 5'd7, 7'b0010011}; // andi t2, t1, -1.
        valid = 1'b1; #40;
        
        instruction <= {12'haaa, 5'd5, 3'd6, 5'd7, 7'b0010011}; // ori t2, t0, 0xaaa.
        valid = 1'b1; #40;
        
        instruction <= {12'ha0f, 5'd5, 3'd0, 5'd5, 7'b0010011}; // addi t0, t0, 0xa0f
        valid = 1'b1; #40;
        
        instruction <= {12'h5f1, 5'd6, 3'd0, 5'd6, 7'b0010011}; // addi t1, t1, 0x5f1
        valid = 1'b1; #40;
        
        instruction <= {7'h00, 5'd6, 5'd5, 3'd0, 5'd7, 7'b0110011}; // add t2, t0, t1.
        valid = 1'b1; #40;
        
        instruction <= {7'h20, 5'd6, 5'd5, 3'd0, 5'd7, 7'b0110011}; // sub t2, t0, t1.
        valid = 1'b1; #40;
        
        instruction <= {7'h00, 5'd6, 5'd5, 3'd4, 5'd7, 7'b0110011}; // xor t2, t0, t1.
        valid = 1'b1; #40;
        
        instruction <= {7'h00, 5'd6, 5'd5, 3'd6, 5'd7, 7'b0110011}; // or t2, t0, t1.
        valid = 1'b1; #40;
        
        instruction <= {7'h00, 5'd6, 5'd5, 3'd7, 5'd7, 7'b0110011}; // and t2, t0, t1.
        valid = 1'b1; #40;
        
        instruction <= {12'd5, 5'd0, 3'd0, 5'd6, 7'b0010011}; // addi, t1, x0, 5.
        valid = 1'b1; #40;
        
        instruction <= {7'h00, 5'd6, 5'd5, 3'd1, 5'd7, 7'b0110011}; // sll t2, t0, t1.
        valid = 1'b1; #40;
        
        instruction <= {7'h00, 5'd6, 5'd5, 3'd0, 5'd7, 7'b0110011}; // srl t2, t0, t1.
        valid = 1'b1; #40;
        
        $stop();
    end
    control_unit dut (.clk, .rst, .instruction, .valid, .ready, .error);
    
    always #5 clk = ~clk;
endmodule