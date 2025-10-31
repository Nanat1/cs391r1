module control_unit(
    input  wire clk,
    input  wire rst,
    
    input  wire[31:0] instruction,
    input  wire       valid,
    output wire       ready,
    
    output reg error
);

reg[31:0] curr_instruction;
reg[3:0] state; // 0 means ready, 1 means sending to ALU, 2 means writing to register

assign ready = state == 0;

reg we;
reg[31:0] d_in;
reg[3:0] rd_sel;
reg[3:0] rs_sel;
reg[3:0] rt_sel;
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

always @(posedge clk) begin
    if (rst) begin
        state <= 0;
        we <= 0;
        error <= 0;
    end else if (state == 0 && valid) begin // when ready and instruction is valid
        curr_instruction <= instruction;
        
        if (instruction[6:0] == 7'b0010011) begin // if type I
            rs_sel <= instruction[19:15];
        end else if (instruction[6:0] == 7'b0110011) begin // if type R
            rs_sel <= instruction[19:15];
            rt_sel <= instruction[24:20];
        end
        
        state <= 1; // shift to sending to ALU
        error <= 0;
    end else if (state == 1) begin // when sending to ALU
        
        if (curr_instruction == 7'b0110111) begin // if lui
            alu_op1 <= curr_instruction[31:12];
            alu_op2 <= 32'd12;
            alu_control <= 4'b0101;
        end else if (curr_instruction[6:0] == 7'b0010011) begin // if type I
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
        
        state <= 2; // shift to writing to register
    end else if (state == 2) begin // when writing to register
        if (alu_error) begin // error handing
            error <= 1;
            
            state <= 0;
        end else begin
            we <= 1;
            d_in <= alu_res;
            rd_sel <= curr_instruction[11:7];
            
            state <= 3; // shift to cycle finish
        end
    end else if (state == 3) begin // finish cycle and return to ready
        we <= 0;
        state <= 0;
    end
end

endmodule