`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 06:57:09 PM
// Design Name: 
// Module Name: test_simulation
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

module test_simulation();

bit clk;
bit rst;

wire awready;
bit awvalid;
bit[19:0] awaddr;
wire wready;
bit wvalid;
bit[31:0] wdata;
bit bready;
wire bvalid;
wire[1:0] bresp;
wire arready;
bit arvalid;
bit[19:0] araddr;
bit rready;
wire rvalid;
wire[31:0] rdata;
wire[1:0] rresp;

reg _rst;
reg _awvalid;
reg[19:0] _awaddr;
reg _wvalid;
reg[31:0] _wdata;
reg _bready;
reg _arvalid;
reg[19:0] _araddr;
reg _rready;

reg error;
reg valid;

reg cu_awvalid;
reg[19:0] cu_awaddr;
reg cu_wvalid;
reg[31:0] cu_wdata;
reg cu_bready;

always #5ns begin
    clk = ~clk;
end

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
    if (valid) begin
        _awvalid <= cu_awvalid;
        _wvalid <= cu_wvalid;
        _awaddr <= cu_awaddr;
        _wdata <= cu_wdata;
        _bready <= cu_bready;
    end
end

axi_bram_ctrl_0 my_bram(
    .s_axi_aclk(clk),
    .s_axi_aresetn(~rst),
    .s_axi_araddr(_araddr),
    .s_axi_arprot(3'b000),
    .s_axi_arready(arready),
    .s_axi_arvalid(_arvalid),
    .s_axi_awaddr(_awaddr),
    .s_axi_awprot(3'b000),
    .s_axi_awready(awready),
    .s_axi_awvalid(_awvalid),
    .s_axi_bready(_bready),
    .s_axi_bresp(bresp),
    .s_axi_bvalid(bvalid),
    .s_axi_rdata(rdata),
    .s_axi_rready(_rready),
    .s_axi_rresp(rresp),
    .s_axi_rvalid(rvalid),
    .s_axi_wdata(_wdata),
    .s_axi_wready(wready),
    .s_axi_wstrb(4'b1111),
    .s_axi_wvalid(_wvalid)
);

control_unit ctrl_unit (
    .clk(clk), 
    .rst(rst), 
    .valid(valid),
    .error(error),
  
    .rvalid(rvalid),
    .rdata(rdata),
    .arvalid(arvalid),
    .rready(rready),
    .araddr(araddr),
    
    .awvalid(cu_awvalid),
    .wvalid(cu_wvalid),
    .awaddr(cu_awaddr),
    .wdata(cu_wdata),
    .bready(cu_bready)
);


reg [7:0] my_memory[511:0];
reg [31:0] regs[0:31];
reg [3:0] state_of_cu;
reg [31:0] alu_op1;
reg [31:0] alu_op2;

assign regs = ctrl_unit.reg_file.regs;
assign state_of_cu = ctrl_unit.state;
assign alu_op1 = ctrl_unit.alu_op1;
assign alu_op2 = ctrl_unit.alu_op2;


initial begin

    rst = 1; valid = 0;
    #20ns;
    rst = 0;
    #20ns;

    $readmemh("/home/lzhx/Developer/Repositories/cs391r1/lab4/lab4_binary.hex", my_memory);

    #40ns;

    for (int i = 0; i < 512; i+=4) begin
        awvalid = 1;
        wvalid = 1;
        awaddr = i;
        wdata = {my_memory[i+3], my_memory[i+2], my_memory[i+1], my_memory[i]}; // be careful with endianness...
        #20ns;
        awvalid = 0;
        wvalid = 0;
        bready = 1;
        #20ns;
        bready = 0;
        #20ns;
    end

    #20ns;

    // actual test-bench starts here...
    
    valid = 1;
    #10000ns;

    $finish;
end

endmodule
