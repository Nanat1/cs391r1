`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 09:51:54 AM
// Design Name: 
// Module Name: BRAM_control_unit
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


module control_unit(
    input wire clk,
    input wire rst,
    input wire valid,
    output reg error,
    
    input wire rvalid,
    input wire[31:0] rdata,
    output wire arvalid,
    output wire rready,
    output wire[19:0] araddr,
    
    output wire awvalid,
    output wire wvalid,
    output wire[19:0] awaddr,
    output wire[31:0] wdata,
    output wire bready
);

reg[31:0] curr_instruction;
reg[19:0] PC; // Program Counter
reg[3:0] state; // 0 means ready, 1 means fetching, 
    // 2 means sending to ALU, 3 means writing to register
    
reg we;
reg[31:0] d_in;
reg[4:0] rd_sel;
reg[4:0] rs_sel;
reg[4:0] rt_sel;
wire[31:0] rs;
wire[31:0] rt;
register_file reg_file(
    .clk(clk),
    .we(we),
    .d_in(d_in),
    .rd_sel(rd_sel),
    .rs_sel(rs_sel),
    .rt_sel(rt_sel),
    .rs(rs),
    .rt(rt)
);

reg[31:0] alu_op1;
reg[31:0] alu_op2;
reg[3:0] alu_control;
wire[31:0] alu_res;
wire alu_error;
alu alu(
    .op1(alu_op1),
    .op2(alu_op2),
    .control(alu_control),
    .res(alu_res),
    .error(alu_error)
);

reg _arvalid;
reg[19:0] _araddr;
reg _rready;
reg _awvalid;
reg _wvalid;
reg[19:0] _awaddr;
reg[31:0] _wdata;
reg _bready;

assign arvalid = _arvalid;
assign araddr = _araddr;
assign rready = _rready;
assign awvalid = _awvalid;
assign wvalid = _wvalid;
assign awaddr = _awaddr;
assign wdata = _wdata;
assign bready = _bready;


always @(posedge clk) begin
    if (rst) begin
        state <= 0;
        we <= 0;
        error <= 0;
        PC <= 20'b0;
    end else if ((state == 0 && valid) || (state == 1 && !rvalid)) begin 
        // when ready and instruction is valid
        _arvalid <= 1;
        _rready <= 1;
        _araddr <= PC;
        // if arready, this will be recieved
        
        state <= 1; // shift to fetching
        error <= 0;
    end else if (state == 1 && rvalid) begin
        _arvalid <= 0;
        _rready <= 0;
            
        curr_instruction <= rdata;
        
        if (rdata[6:0] == 7'b0000011) begin // if type I (load)
            rs_sel <= rdata[19:15];
        end else if (rdata[6:0] == 7'b0010011) begin // if type I (other)
            rs_sel <= rdata[19:15];
        end else if (rdata[6:0] == 7'b0110011) begin // if type R
            rs_sel <= rdata[19:15];
            rt_sel <= rdata[24:20];
        end else if (rdata[6:0] == 7'b0100011) begin // if type S
            rs_sel <= rdata[19:15];
            rt_sel <= rdata[24:20];
        end else if (rdata[6:0] == 7'b1100011) begin // if type B
            rs_sel <= rdata[19:15];
            rt_sel <= rdata[24:20];
        end else if (rdata[6:0] != 7'b0110111) begin // if unrecognized
            error <= 1;
            $stop();
        end
        state <= 2; // shift to sending to ALU
        error <= 0;
    end else if (state == 2) begin // when sending to ALU
        
        if (rdata[6:0] == 7'b0000011) begin // if type I (load)
            alu_op1 <= rs;
            alu_op2 <= curr_instruction[31:20];
            alu_control <= 4'b0;
            state <= 6; // shift to read from memory
            
        end else if (rdata[6:0] == 7'b0100011) begin // if type S
            alu_op1 <= rs;
            alu_op2 <= {curr_instruction[31:25], curr_instruction[11:7]}; // imm for type S
            alu_control <= 4'b0;
            state <= 5; // shift to write to memory
            
        end else if (curr_instruction[6:0] == 7'b0010011) begin // if type I (other)
            alu_op1 <= rs;
            if (curr_instruction[14:12] == 3'h5 && curr_instruction[31:25] == 7'h20) begin
                alu_op2 <= curr_instruction[24:20];
                alu_control <= {1'b1, curr_instruction[14:12]};
            end else begin
                alu_op2 <= curr_instruction[31:20];
                alu_control <= {1'b0, curr_instruction[14:12]};
            end
            state <= 3; // shift to writing to register
            
        end else if (curr_instruction[6:0] == 7'b0110011) begin // if type R
            alu_op1 <= rs;
            alu_op2 <= rt;
            if (curr_instruction[31:25] == 7'h00) begin
                alu_control <= {1'b0, curr_instruction[14:12]};
            end else if (curr_instruction[31:25] == 7'h20) begin
                alu_control <= {1'b1, curr_instruction[14:12]};
            end
            state <= 3; // shift to writing to register
            
        end else begin // lui
            
            state <= 3; // shift to writing to register
        end
        
    end else if (state == 3) begin // when writing to register
        if (alu_error) begin // error handing
            error <= 1;
            $stop();
            state <= 0;
        end else if (curr_instruction == 7'b0000011) begin
            if (rvalid) begin
                _arvalid <= 0;
                _rready <= 0;
                
                we <= 1;
                rd_sel <= curr_instruction[11:7];
                if (curr_instruction[14:12] == 3'h0) begin
                    d_in <= rdata[7:0];
                end else if (curr_instruction[14:12] == 3'h1) begin
                    d_in <= rdata[15:0];
                end else if (curr_instruction[14:12] == 3'h2) begin
                    d_in <= rdata;
                end
                state <= 4; // shift to cycle finish
            end else begin
                // when ready and address is valid
                _arvalid <= 1;
                _rready <= 1;
                _araddr <= alu_res[19:0];
                // if arready, this will be recieved
                
                state <= 3; // stay at writng to register
                error <= 0;
            end
        end else begin
            we <= 1;
            rd_sel <= curr_instruction[11:7];
            if (curr_instruction[6:0] == 7'b0110111) begin // if lui
                d_in <= {curr_instruction[31:12], 12'b0};
            end else begin
                d_in <= alu_res;
            end
            
            state <= 4; // shift to cycle finish
        end
        
    end else if (state == 4) begin // finish cycle and return to ready
        _bready <= 0; // for type S
        we <= 0;
        state <= 0;
        PC <= PC + 4;
        _arvalid <= 1;
        _araddr <= PC;
    end else if (state == 5) begin // when writing to memory
    
        if (alu_error) begin // error handing
            error <= 1;
            $stop();
            state <= 0;
        end
        
        _awvalid <= 1;
        _wvalid <= 1;
        _awaddr <= alu_res[19:0];
        _wdata <= rt;
        if (curr_instruction[14:12] == 3'h0) begin
            _wdata <= {rt[7:0], 24'b0};
        end else if (curr_instruction[14:12] == 3'h1) begin
            _wdata <= {rt[15:0], 16'b0};
        end else if (curr_instruction[14:12] == 3'h2) begin
            _wdata <= rt;
        end
        
        state <= 7;
    
    end else if (state == 6) begin // when reading data from memory
        
        if (alu_error) begin // error handing
            error <= 1;
            $stop();
            state <= 0;
        end
        // when ready and address is valid
        _arvalid <= 1;
        _rready <= 1;
        _araddr <= alu_res[19:0];
        // if arready, this will be recieved
        
        state <= 3; // shift to writng to register
        error <= 0;
    
    end else if (state == 7) begin 
        
        _awvalid <= 0;
        _wvalid <= 0;
        _bready <= 1;
        
        state <= 4; // shift to cycle finish
    end
end

endmodule