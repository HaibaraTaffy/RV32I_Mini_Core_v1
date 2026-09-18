`timescale 1ns/1ps

module tb_next_pc_logic;

reg  [31:0] current_pc;
reg  [31:0] immediate;
reg  [31:0] alu_result;
reg  [2:0]  funct3;
reg         branch;
reg         jump ;
reg         jalr;
reg         zero;
reg         less_than;   

wire [31:0] pc_plus4;
wire [31:0] branch_target;
wire [31:0] jalr_target;
wire        pc_src;
wire [31:0] next_pc;

next_pc_logic dut (
    .current_pc    (current_pc),
    .immediate     (immediate),
    .branch        (branch),
    .jump          (jump),
    .jalr          (jalr),
    .funct3        (funct3),
    .zero          (zero),
    .less_than     (less_than),
    .pc_plus4      (pc_plus4),
    .branch_target (branch_target),
    .jalr_target   (jalr_target),
    .pc_src        (pc_src),
    .next_pc       (next_pc)
);

initial begin
    //初始化
    current_pc = 32'h0000_0000;
    immediate  = 32'h0000_0010;
    alu_result = 32'h0000_0000;
    funct3     = 3'b000;
    branch     = 1'b0;
    jump       = 1'b0;
    jalr       = 1'b0;
    zero       = 1'b0;
    less_than  = 1'b0;
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

    current_pc = 32'h0000_0100;
    immediate  = 32'h0000_0010;
    funct3     = 3'b001;
    branch     = 1'b1;
    zero       = 1'b1;
    less_than  = 1'b0;
    #10;
    //branch = 1 funct3 = 001 对应 BNE
    //zero = 1 BNE 不成立 next_pc = pc_plus4 = 32'h0000_0104
    zero = 1'b0;//zero = 0 BNE 成立 next_pc = branch_target = 32'h0000_0110
    #10;

    funct3    = 3'b100;
    zero      = 1'b0;
    less_than = 1'b1;
    #10;
    //funct3 = 100 对应 BLT
    //less_than =  1 BLT成立 next_pc = branch_target = 32'h0000_0110

    less_than = 1'b0;
    #10;//less_than = 0 BLT 不成立 next_pc = pc_plus4 = 32'h0000_0104

    funct3    = 3'b101;
    less_than = 1'b0;
    #10;//funct3 = 101 对应 BGE 
    //less_than = 0 BGE 成立 next_pc = branch_target = 32'h0000_0110

    less_than = 1'b1;
    #10;//less_than = 1 BGE 不成立 next_pc = pc_plus4 = 32'h0000_0104

    funct3    = 3'b010;
    zero      = 1'b1;
    less_than = 1'b1;
    #10;//暂时 无效funct3 next_pc = pc_plus4

    current_pc = 32'h0000_0100;
    immediate  = 32'h0000_0020;
    branch     = 1'b0;
    jump       = 1'b1;
    zero       = 1'b0;
    less_than  = 1'b0;
    #10;//jump = 1 next_pc = branch_target = 32'h0000_0120

    current_pc = 32'h0000_0100;
    immediate  = 32'hFFFF_FFE0;
    jump       = 1'b1;
    #10;//jump = 1 next_pc = branch_target = 32'h0000_00E0

    jump = 1'b0;
    //jump = 0 next_pc = current_pc + 4 = 32'h0000_0104
    #10;

    current_pc = 32'h0000_0100;
    branch     = 1'b0;
    jump       = 1'b0;
    jalr       = 1'b1;
    alu_result = 32'h0000_0125;//00..0001_0010_0101
    #10;//jalr = 1 next_pc = jalr_target = 32'h0000_0124

    alu_result = 32'h0000_0124;
    #10;//jalr = 1 next_pc = jalr_target = 32'h0000_0124

    jalr = 1'b0;
    #10;//jalr = 0 next_pc = current_pc + 4 =32'h0000_0104


    $finish;
end
//仿真通过 全部符合预期
endmodule