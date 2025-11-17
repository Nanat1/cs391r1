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
    input wire arready,
    
    input wire awready,
    output wire awvalid,
    output wire wvalid,
    output wire[19:0] awaddr,
    output wire[31:0] wdata,
    input wire wready,
    output wire bready,
    input wire bvalid
);

reg[31:0] _rdata;
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

reg[31:0] mem_rdata; 
wire [12:0] imm_b = {curr_instruction[31], curr_instruction[7], curr_instruction[30:25], curr_instruction[11:8], 1'b0};
wire [19:0] target_b = {{7 {imm_b[12]}}, imm_b};

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
    end else if (state == 0 && valid) begin 
        // when ready and instruction is valid
        _arvalid <= 1;
        _rready <= 1;
        _araddr <= PC;
        // if arready, this will be recieved
        state <= 1;
        end
        
    else if (state == 1) begin
        if (arready) begin
            _arvalid <= 0; 
        end
        if (rvalid) begin
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
        end
    end else if (state == 2) begin // when sending to ALU
        
        if (curr_instruction[6:0] == 7'b0000011) begin // if type I (load)
            alu_op1 <= rs;
            alu_op2 <= curr_instruction[31:20];
            alu_control <= 4'b0;
            state <= 6; // shift to read from memory
            
        end else if (curr_instruction[6:0] == 7'b0100011) begin // if type S
            alu_op1 <= rs;
            alu_op2 <= {curr_instruction[31:25], curr_instruction[11:7]}; // imm for type S
            alu_control <= 4'b0;
            state <= 8; // shift to write to memory
            
        end else if (curr_instruction[6:0] == 7'b1100011) begin // if type B
            alu_op1 <= rs;
            alu_op2 <= rt;
            alu_control <= {1'b1, curr_instruction[14:12]};
            state <= 3; // shift to end of cycle
            
        end else if (curr_instruction[6:0] == 7'b0010011) begin // if type I (other)
            alu_op1 <= rs;
            if (curr_instruction[14:12] == 3'h5 && curr_instruction[31:25] == 7'h20) begin
                alu_op2 <= -curr_instruction[24:20];
            end else begin
                alu_op2 <= curr_instruction[31:20];
            end
            alu_control <= {1'b0, curr_instruction[14:12]};
            state <= 3; // shift to writing to register
            
        end else if (curr_instruction[6:0] == 7'b0110011) begin // if type R
            alu_op1 <= rs;
            if (curr_instruction[31:25] == 7'h00) begin
                alu_op2 <= rt;
            end else if (curr_instruction[31:25] == 7'h20) begin
                alu_op2 <= -rt;
            end
            alu_control <= {1'b0, curr_instruction[14:12]};
            state <= 3; // shift to writing to register
            
        end else begin // lui
            
            state <= 3; // shift to writing to register
        end
        
    end else if (state == 3) begin // when writing to register
        if (curr_instruction[6:0] == 7'b0000011) begin // I-type (Load)
            _arvalid <= 0;
            _rready <= 0;
                
            we <= 1;
            rd_sel <= curr_instruction[11:7];
            if (curr_instruction[14:12] == 3'h0) begin
                d_in <= {{24{mem_rdata[7]}}, mem_rdata[7:0]};
            end else if (curr_instruction[14:12] == 3'h1) begin
                d_in <= {{16{mem_rdata[15]}}, mem_rdata[15:0]};
            end else if (curr_instruction[14:12] == 3'h2) begin
                d_in <= mem_rdata;
            end
            state <= 4; // shift to cycle finish
        end else if (curr_instruction[6:0] == 7'b1100011) begin // B
            we <= 0;
            state <= 4;
        end else if (curr_instruction[6:0] == 7'b0100011) begin // S
            we <= 0;
            state <= 4;
        end else begin // I/R/lui
            we <= 1;
            rd_sel <= curr_instruction[11:7];
            if (curr_instruction[6:0] == 7'b0110111) begin // if lui
                d_in <= {curr_instruction[31:12], 12'b0};
            end else begin // if I/R
                d_in <= alu_res;
            end
            
            state <= 4; // shift to cycle finish
        end
        
    end else if (state == 4) begin // finish cycle and return to ready
        _bready <= 0; // for type S
        
        if (curr_instruction[6:0] == 7'b1100011) begin // if type B
            if (alu_error) begin // error handing
                error <= 1;
                $stop();
                state <= 0;
            end
            if (alu_res == 1) begin
                PC <= PC + target_b; 
            end else begin
                PC <= PC + 4;
            end
            
            state <= 0;
            
        end else begin
            we <= 0;
            PC <= PC + 4;
            state <= 0;
        end
    
    end else if (state == 6) begin // when reading from memory
        
        if (alu_error) begin // error handing
            error <= 1;
            $stop();
            state <= 0;
        end
        _arvalid <= 1;
        _araddr <= alu_res[19:0];
        _rready <= 0;
    
        if (arready) begin
            state <= 7; // shift to waiting rvalid
        end else begin 
            state <= 6;
        end
    end else if (state == 7) begin // when waiting rvalid
        // when ready and address is valid
        
        _arvalid <= 0;
        _rready <= 1;
        if (rvalid) begin
            mem_rdata <= rdata;
            _rready <= 0;
            state <= 3;
        end else begin
            state <= 7;
            error <= 0;
        end
            
    end else if (state == 8) begin // when writing to memory
    
        if (alu_error) begin // error handing
            error <= 1;
            $stop();
            state <= 0;
        end
        _awvalid <= 1;
        _awaddr <= alu_res[19:0];
        
//        if (awready) begin
            state <= 9;
//        end else begin
//            state <= 8;
//        end
    end else if (state == 9) begin //
        
        _wvalid <= 1;
        if (curr_instruction[14:12] == 3'h0) begin
            _wdata <= {rt[7:0], 24'b0};
        end else if (curr_instruction[14:12] == 3'h1) begin
            _wdata <= {rt[15:0], 16'b0};
        end else if (curr_instruction[14:12] == 3'h2) begin
            _wdata <= rt;
        end
        
        if (wready) begin
            state <= 10;
        end else begin 
            state <= 9;
        end
    end else if (state == 10) begin //
        _awvalid <= 0;
        _wvalid <= 0;
        _bready <= 1;
        
        state <= 11; // shift to wait for bvalid
        
    end else if (state == 11) begin
        if (bvalid) begin
            _bready <= 0;
            state <= 3;
        end
    
    end
end

endmodule