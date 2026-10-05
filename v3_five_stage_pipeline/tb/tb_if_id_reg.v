`timescale 1ns/1ps

module tb_if_id_reg;

reg         clk;
reg         rst;
reg         enable;
reg         clear;
reg         valid_in;
reg  [31:0] instruction_in;
reg  [31:0] pc_in;
reg  [31:0] pc_plus4_in;

wire        valid_out;
wire [31:0] instruction_out;
wire [31:0] pc_out;
wire [31:0] pc_plus4_out;

if_id_reg dut (
    .clk             (clk),
    .rst             (rst),
    .enable          (enable),
    .clear           (clear),
    .valid_in        (valid_in),
    .instruction_in  (instruction_in),
    .pc_in           (pc_in),
    .pc_plus4_in     (pc_plus4_in),
    .valid_out       (valid_out),
    .instruction_out (instruction_out),
    .pc_out          (pc_out),
    .pc_plus4_out    (pc_plus4_out)
);

always #5 clk = ~clk;

initial begin
    clk            = 1'b0;
    rst            = 1'b1;
    enable         = 1'b0;
    clear          = 1'b0;
    valid_in       = 1'b0;
    instruction_in = 32'b0;
    pc_in          = 32'b0;
    pc_plus4_in    = 32'b0;
    //复位 全部归零
    #20;
    rst = 1'b0;

    // Save instruction A 保存指令 A
    // 输出等于输入
    enable         = 1'b1;
    valid_in       = 1'b1;
    instruction_in = 32'h0010_0093;
    pc_in          = 32'h0000_0000;
    pc_plus4_in    = 32'h0000_0004;
    #10;

    // Save instruction B 保存指令B
    // 输出等于输入
    instruction_in = 32'h0020_0113;
    pc_in          = 32'h0000_0004;
    pc_plus4_in    = 32'h0000_0008;
    #10;

    // Stall 停滞
    // 输出等于上一个输出
    enable         = 1'b0;
    instruction_in = 32'h0030_0193;
    pc_in          = 32'h0000_0008;
    pc_plus4_in    = 32'h0000_000C;
    #20;

    // Continue 继续
    // 输出等于 上面的输入
    enable = 1'b1;
    #10;

    // Flush 冲刷
    // 输出归零
    clear = 1'b1;
    #10;
    //输出等于 上面的输入
    clear = 1'b0;
    #10;

    //仿真正确

    $finish;
end

endmodule