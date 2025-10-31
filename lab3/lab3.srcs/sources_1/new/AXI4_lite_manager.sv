`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 10:10:26 AM
// Design Name: 
// Module Name: AXI4_lite_manager
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


module AXI4_lite_manager #(
    parameter A_WIDTH = 20, // Address Width
    parameter D_WIDTH = 32 // Data Width
)(
    input wire clk,
    input wire rst
    
    // read BRAM wires
);
    
    
    


    reg[D_WIDTH-1:0] cu_data;


    BRAM_control_unit ctrl_unit (
        .clk(clk), 
        .rst(rst), 
        .instruction(cu_data), 
        .valid,
        .error,
        .state
    );
    


    
endmodule
