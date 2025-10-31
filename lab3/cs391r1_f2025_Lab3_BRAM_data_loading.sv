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

reg _rst;
reg _awvalid;
reg[19:0] _awaddr;
reg _wvalid;
reg[31:0] _wdata;
reg _bready;
reg _arvalid;
reg[19:0] _araddr;
reg _rready;

always #5ns begin
    clk = ~clk;
end

reg error;
reg valid;

BRAM_control_unit ctrl_unit (
    .clk(clk), 
    .rst(rst), 
    .valid(valid),
    .error(error)
);


reg [7:0] my_memory[511:0];
reg [31:0] regs[0:31];

assign regs = ctrl_unit.reg_file.regs;



initial begin

    rst = 1; valid = 0;
    #20ns;
    rst = 0;
    #20ns;

    $readmemh("/.../lab3_binary.hex", my_memory);

    #40ns;

    for (int i = 0; i < 512; i+=4) begin
        ctrl_unit.awvalid = 1;
        ctrl_unit.wvalid = 1;
        ctrl_unit.awaddr = i;
        ctrl_unit.wdata = {my_memory[i], my_memory[i+1], my_memory[i+2], my_memory[i+3]}; // be careful with endianness...
        #20ns;
        ctrl_unit.awvalid = 0;
        ctrl_unit.wvalid = 0;
        ctrl_unit.bready = 1;
        #20ns;
        ctrl_unit.bready = 0;
        #20ns;
    end

    #20ns;

    // actual test-bench starts here...
    
    valid = 1;
    #600ns;

    $finish;
end

endmodule