`timescale 1ns/1ps

module tb_id_ex_reg;

reg clk;
reg rst;
reg enable;
reg clear;

reg valid_in;

reg [31:0] pc_in;
reg [31:0] pc_plus4_in;
reg [31:0] read_data1_in;
reg [31:0] read_data2_in;
reg [31:0] immediate_in;

reg [4:0] rs1_in;
reg [4:0] rs2_in;
reg [4:0] rd_in;
reg [2:0] funct3_in;

reg [3:0] alu_control_in;
reg       alu_src_in;
reg       reg_write_in;
reg       mem_write_in;
reg [1:0] result_src_in;
reg       branch_in;
reg       jump_in;
reg       jalr_in;

wire valid_out;

wire [31:0] pc_out;
wire [31:0] pc_plus4_out;
wire [31:0] read_data1_out;
wire [31:0] read_data2_out;
wire [31:0] immediate_out;

wire [4:0] rs1_out;
wire [4:0] rs2_out;
wire [4:0] rd_out;
wire [2:0] funct3_out;

wire [3:0] alu_control_out;
wire       alu_src_out;
wire       reg_write_out;
wire       mem_write_out;
wire [1:0] result_src_out;
wire       branch_out;
wire       jump_out;
wire       jalr_out;

id_ex_reg dut (
    .clk             (clk),
    .rst             (rst),
    .enable          (enable),
    .clear           (clear),

    .valid_in        (valid_in),

    .pc_in           (pc_in),
    .pc_plus4_in     (pc_plus4_in),
    .read_data1_in   (read_data1_in),
    .read_data2_in   (read_data2_in),
    .immediate_in    (immediate_in),

    .rs1_in          (rs1_in),
    .rs2_in          (rs2_in),
    .rd_in           (rd_in),
    .funct3_in       (funct3_in),

    .alu_control_in  (alu_control_in),
    .alu_src_in      (alu_src_in),
    .reg_write_in    (reg_write_in),
    .mem_write_in    (mem_write_in),
    .result_src_in   (result_src_in),
    .branch_in       (branch_in),
    .jump_in         (jump_in),
    .jalr_in         (jalr_in),

    .valid_out       (valid_out),

    .pc_out          (pc_out),
    .pc_plus4_out    (pc_plus4_out),
    .read_data1_out  (read_data1_out),
    .read_data2_out  (read_data2_out),
    .immediate_out   (immediate_out),

    .rs1_out         (rs1_out),
    .rs2_out         (rs2_out),
    .rd_out          (rd_out),
    .funct3_out      (funct3_out),

    .alu_control_out (alu_control_out),
    .alu_src_out     (alu_src_out),
    .reg_write_out   (reg_write_out),
    .mem_write_out   (mem_write_out),
    .result_src_out  (result_src_out),
    .branch_out      (branch_out),
    .jump_out        (jump_out),
    .jalr_out        (jalr_out)
);

always #5 clk = ~clk;

initial begin
    clk             = 1'b0;
    rst             = 1'b1;
    enable          = 1'b0;
    clear           = 1'b0;
    valid_in        = 1'b0;

    pc_in           = 32'b0;
    pc_plus4_in     = 32'b0;
    read_data1_in   = 32'b0;
    read_data2_in   = 32'b0;
    immediate_in    = 32'b0;

    rs1_in          = 5'b0;
    rs2_in          = 5'b0;
    rd_in           = 5'b0;
    funct3_in       = 3'b0;

    alu_control_in  = 4'b0;
    alu_src_in      = 1'b0;
    reg_write_in    = 1'b0;
    mem_write_in    = 1'b0;
    result_src_in   = 2'b0;
    branch_in       = 1'b0;
    jump_in         = 1'b0;
    jalr_in         = 1'b0;
    
    //复位 全部归零
    #20;
    rst = 1'b0;


    // ADD x3, x1, x2
    enable          = 1'b1;
    valid_in        = 1'b1;
    pc_in           = 32'h0000_0008;
    pc_plus4_in     = 32'h0000_000C;
    read_data1_in   = 32'd5;
    read_data2_in   = 32'd3;
    immediate_in    = 32'b0;
    rs1_in          = 5'd1;
    rs2_in          = 5'd2;
    rd_in           = 5'd3;
    funct3_in       = 3'b000;
    alu_control_in  = 4'b0000;
    alu_src_in      = 1'b0;
    reg_write_in    = 1'b1;
    mem_write_in    = 1'b0;
    result_src_in   = 2'b00;
    branch_in       = 1'b0;
    jump_in         = 1'b0;
    jalr_in         = 1'b0;
    #10;

    // Stall / hold
    enable          = 1'b0;
    pc_in           = 32'h0000_000C;
    read_data1_in   = 32'd20;
    rd_in           = 5'd4;
    #20;

    // Bubble
    clear  = 1'b1;
    enable = 1'b1;
    #10;

    clear = 1'b0;

    // SW x3, 0(x4)
    valid_in        = 1'b1;
    pc_in           = 32'h0000_0010;
    pc_plus4_in     = 32'h0000_0014;
    read_data1_in   = 32'h0000_0100;
    read_data2_in   = 32'h1234_5678;
    immediate_in    = 32'b0;
    rs1_in          = 5'd4;
    rs2_in          = 5'd3;
    rd_in           = 5'd0;
    funct3_in       = 3'b010;
    alu_control_in  = 4'b0000;
    alu_src_in      = 1'b1;
    reg_write_in    = 1'b0;
    mem_write_in    = 1'b1;
    result_src_in   = 2'b00;
    #10;

    rst = 1'b1;
    #10;
    

    $finish;
end

endmodule