`timescale 1ns/1ps

module tb_next_pc_logic;

reg  [31:0] current_pc;
reg  [31:0] immediate;
reg         branch;
reg         zero;

wire [31:0] pc_plus4;
wire [31:0] branch_target;
wire        pc_src;
wire [31:0] next_pc;

next_pc_logic dut (
    .current_pc    (current_pc),
    .immediate     (immediate),
    .branch        (branch),
    .zero          (zero),
    .pc_plus4      (pc_plus4),
    .branch_target (branch_target),
    .pc_src        (pc_src),
    .next_pc       (next_pc)
);

initial begin
    current_pc = 32'h0000_0000;
    immediate  = 32'h0000_0010;
    branch     = 1'b0;
    zero       = 1'b0;
    #10;

    zero = 1'b1;
    #10;
    //branch为0 不跳转 current_pc 不变化 输出 next_pc = pc_plus4 = 32'h0000_0004 

    branch = 1'b1;
    zero   = 1'b0;
    #10;
    //branch为1 zero为0 也不跳转 依旧保持原值

    zero = 1'b1;
    #10;
    //branch为1 zero为1 跳转 但是current_pc = 32'h0000_0000 
    //于是next_pc = branch_target = 0 + 32'h0000_0010 = 32'h0000_0010

    current_pc = 32'h0000_0100;
    immediate  = 32'hFFFF_FFF0;
    branch     = 1'b1;
    zero       = 1'b1;
    #10;
    //全部更新 重新计算 
    //next_pc = branch_target = 32'h0000_0100 + 32'hFFFF_FFF0 =32'h0000_00F0

    branch = 1'b0;
    #10;
    //branch = 0 于是 next_pc = pc_plus4 = 32'h0000_0104
    current_pc = 32'hFFFF_FFFC;
    immediate  = 32'h0000_0010;
    branch     = 1'b0;
    zero       = 1'b0;
    #10;
    //branch = 0 于是 next_pc = pc_plus4 = 32'h0000_0000
    $finish;
end
//仿真通过 全部符合预期
endmodule