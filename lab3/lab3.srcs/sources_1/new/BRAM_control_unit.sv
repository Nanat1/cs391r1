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


module BRAM_control_unit(
    input  wire clk,
    input  wire rst,
    input  wire valid,
    output reg error
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

wire awready;
wire wready;
wire bvalid;
wire[1:0] bresp;
wire arready;
bit arvalid;
bit[19:0] araddr;
bit rready;
wire rvalid;
wire[31:0] rdata;
wire awvalid;
wire wvalid;
wire[19:0] awaddr;
wire[31:0] wdata;
wire bready;

reg _rst;
reg _awvalid;
reg[19:0] _awaddr;
reg _wvalid;
reg[31:0] _wdata;
reg _bready;
reg _arvalid;
reg[19:0] _araddr;
reg _rready;


always @ (posedge clk) begin
    _rst <= rst;
    _awvalid <= awvalid;
    _awaddr <= awaddr;
    _wvalid <= wvalid;
    _wdata <= wdata;
    _bready <= bready;
    _arvalid <= arvalid;
    _araddr <= araddr;
    _rready <= rready;
end

axi_bram_ctrl_0 my_bram(
    .s_axi_aclk(clk),
    .s_axi_aresetn(~rst),
    .s_axi_araddr(_araddr),
    .s_axi_arprot(0),
    .s_axi_arready(arready),
    .s_axi_arvalid(_arvalid),
    .s_axi_awaddr(_awaddr),
    .s_axi_awprot(0),
    .s_axi_awready(awready),
    .s_axi_awvalid(_awvalid),
    .s_axi_bready(_bready),
    .s_axi_bresp(bresp),
    .s_axi_bvalid(bvalid),
    .s_axi_rdata(rdata),
    .s_axi_rready(_rready),
    .s_axi_rvalid(rvalid),
    .s_axi_wdata(_wdata),
    .s_axi_wready(wready),
    .s_axi_wstrb('b1111),
    .s_axi_wvalid(_wvalid)
);

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
        araddr <= PC;
        // if arready, this will be recieved
        
        state <= 1; // shift to fetching
        error <= 0;
    end else if (state == 1 && rvalid) begin
            
        curr_instruction <= rdata;
        
        if (rdata[6:0] == 7'b0010011) begin // if type I
            rs_sel <= rdata[19:15];
        end else if (rdata[6:0] == 7'b0110011) begin // if type R
            rs_sel <= rdata[19:15];
            rt_sel <= rdata[24:20];
        end else if (rdata[6:0] != 7'b0110111) begin // if unrecognized
            error <= 1;
            $stop();
        end
        state <= 2; // shift to sending to ALU
        error <= 0;
    end else if (state == 2) begin // when sending to ALU
        
        if (curr_instruction[6:0] == 7'b0010011) begin // if type I
            alu_op1 <= rs;
            if (curr_instruction[31:25] == 7'h00) begin
                alu_op2 <= curr_instruction[31:20];
                alu_control <= {1'b0, curr_instruction[14:12]};
            end else if (curr_instruction[31:25] == 7'h20) begin
                alu_op2 <= curr_instruction[24:20];
                alu_control <= {1'b1, curr_instruction[14:12]};
            end
        end else if (curr_instruction[6:0] == 7'b0110011) begin // if type R
            alu_op1 <= rs;
            alu_op2 <= rt;
            if (curr_instruction[31:25] == 7'h00) begin
                alu_control <= {1'b0, curr_instruction[14:12]};
            end else if (curr_instruction[31:25] == 7'h20) begin
                alu_control <= {1'b1, curr_instruction[14:12]};
            end
        end
        
        state <= 3; // shift to writing to register
    end else if (state == 3) begin // when writing to register
        
        if (alu_error) begin // error handing
            error <= 1;
            $stop();
            state <= 0;
        end else begin
            we <= 1;
            if (curr_instruction[6:0] == 7'b0110111) begin // if lui
                d_in <= {curr_instruction[31:12], 12'b0};
            end else begin
                d_in <= alu_res;
            end
            rd_sel <= curr_instruction[11:7];
            
            state <= 4; // shift to cycle finish
        end
    end else if (state == 4) begin // finish cycle and return to ready
        we <= 0;
        state <= 0;
        PC <= PC + 4;
    end
end

endmodule

