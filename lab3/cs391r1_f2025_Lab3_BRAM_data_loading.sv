module test_simulation();

bit clk;
bit rst;


bit awvalid;
bit[19:0] awaddr;
bit wvalid;
bit[31:0] wdata;
bit bready;
bit arvalid;
bit[19:0] araddr;
bit rready;

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
    .awvalid(awvalid),
    .wvalid(wvalid),
    .awaddr(awaddr),
    .wdata(wdata),
    .bready(bready),
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
        awvalid = 1;
        wvalid = 1;
        awaddr = i;
        wdata = {my_memory[i], my_memory[i+1], my_memory[i+2], my_memory[i+3]}; // be careful with endianness...
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
    #600ns;

    $finish;
end

endmodule