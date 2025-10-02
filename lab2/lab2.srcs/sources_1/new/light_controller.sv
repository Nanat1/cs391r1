`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixin Li
// 
// Create Date: 09/26/2025 03:09:04 PM
// Design Name: 
// Module Name: light_controller
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


module light_controller(
    input wire clk,
    input wire rst,
    input wire button,
    output reg[2:0] light_state // 3'd0 corresponds to light turned off,
                                // while 3'd1 to 3'd7 correspond to different colors
    );
    parameter int N = 10; // fixed 32-bit
    reg previous_button = button;
    reg[31:0] counter = 0;
    always_ff @(posedge clk) begin // only updates output when clk(low=>high)
        if (button == 0) begin
            counter = 0;
            light_state = 3'b000; // When the button is not pressed, light state = 0
        end else if (previous_button == 0) begin // betton == 1
            counter = 1;
            light_state = 3'b001; // When the button goes from unpressed to pressed state
                           // light state should be set to 1
        end else begin // button == 1 && previous_button == 1
            if (counter == N) begin
                counter = 0;
                if (light_state == 3'b111) begin
                    light_state = 3'b001;
                end else begin
                    light_state = light_state + 1;
                end
            end else begin
                counter = counter + 1;
            end
        end
        previous_button = button;
    end
endmodule

