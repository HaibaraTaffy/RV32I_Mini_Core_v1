`timescale 1ns/1ps

module tb_ex_mem_reg;

reg         clk;
reg         rst;
reg         enable;
reg         clear;
reg         valid_in;
reg  [31:0] alu_result_in;
reg  [31:0] store_data_in;
reg  [31:0] pc_plus4_in;
reg  [4:0]  rd_in;
reg         reg_write_in;
reg         mem_write_in;
reg  [1:0]  result_src_in;

wire        valid_out;
wire [31:0] alu_result_out;
wire [31:0] store_data_out;
wire [31:0] pc_plus4_out;
wire [4:0]  rd_out;
wire        reg_write_out;
wire        mem_write_out;
wire [1:0]  result_src_out;

ex_mem_reg dut (
    .clk            (clk),
    .rst            (rst),
    .enable         (enable),
    .clear          (clear),
    .valid_in       (valid_in),
    .alu_result_in  (alu_result_in),
    .store_data_in  (store_data_in),
    .pc_plus4_in    (pc_plus4_in),
    .rd_in          (rd_in),
    .reg_write_in   (reg_write_in),
    .mem_write_in   (mem_write_in),
    .result_src_in  (result_src_in),
    .valid_out      (valid_out),
    .alu_result_out (alu_result_out),
    .store_data_out (store_data_out),
    .pc_plus4_out   (pc_plus4_out),
    .rd_out         (rd_out),
    .reg_write_out  (reg_write_out),
    .mem_write_out  (mem_write_out),
    .result_src_out (result_src_out)
);

always #5 clk = ~clk;

initial begin
    clk            = 1'b0;
    rst            = 1'b1;
    enable         = 1'b0;
    clear          = 1'b0;
    valid_in       = 1'b0;
    alu_result_in  = 32'b0;
    store_data_in  = 32'b0;
    pc_plus4_in    = 32'b0;
    rd_in          = 5'b0;
    reg_write_in   = 1'b0;
    mem_write_in   = 1'b0;
    result_src_in  = 2'b0;

    #20;
    rst = 1'b0;

    // ALU instruction
    enable         = 1'b1;
    valid_in       = 1'b1;
    alu_result_in  = 32'd8;
    store_data_in  = 32'd3;
    pc_plus4_in    = 32'h0000_000C;
    rd_in          = 5'd3;
    reg_write_in   = 1'b1;
    mem_write_in   = 1'b0;
    result_src_in  = 2'b00;
    #10;

    // Store instruction
    alu_result_in  = 32'h0000_0100;
    store_data_in  = 32'h1234_5678;
    pc_plus4_in    = 32'h0000_0010;
    rd_in          = 5'd0;
    reg_write_in   = 1'b0;
    mem_write_in   = 1'b1;
    result_src_in  = 2'b00;
    #10;

    // Hold
    enable         = 1'b0;
    alu_result_in  = 32'hFFFF_FFFF;
    store_data_in  = 32'hAAAA_AAAA;
    #20;

    // Clear
    clear  = 1'b1;
    enable = 1'b1;
    #10;

    clear = 1'b0;
    #10;

    $finish;
end

endmodule