`timescale 1ns/1ps

module tb_imm_gen;

reg  [31:0] instruction;
reg  [1:0]  imm_src;
wire [31:0] immediate;

imm_gen dut (
    .instruction (instruction),
    .imm_src     (imm_src),
    .immediate   (immediate)
);

initial begin
    // I-type 取最高12位 ->16进制 00a 扩展 0000_000a 仿真正确
    instruction = 32'h00A3_0293;
    imm_src     = 2'b00;
    #10;
    // I-type 取最高12位 ->16进制 FFC 扩展 FFFF_FFFC 仿真正确
    instruction = 32'hFFC3_0293;
    imm_src     = 2'b00;
    #10;
    // I-type 取最高12位 ->16进制 008 扩展 0000_0008 仿真正确
    instruction = 32'h0083_2283;
    imm_src     = 2'b00;
    #10;
    // S-type 
    //instruction[31] = 0
    //instruction[31:25] = 0000_000
    //0x423 = 0100_0010_0011
    //instruction[11:7]  =0100_0
    //00..01000 => 0x0000_0008 仿真正确
    instruction = 32'h0053_2423;
    imm_src     = 2'b01;
    #10;
    // S-type 
    //instruction[31] = 1
    //instruction[31:24] =0xFE
    //instruction[31:25] = 1111_111

    //0xC23 = 1100_0010_0011
    //instruction[11:7]  =1100_0

    //11..11000 => 0xFFFF_FFF8 仿真正确
    instruction = 32'hFE53_2C23;
    imm_src     = 2'b01;
    #10;
    // B-type 
    //instruction[31] = 0
    //instruction[7]  =0
    //instruction[31:24] =0000_0000
    //instruction[30:25] =0000_00
    //instruction[11:8]  =0x8 = 1000

    //00..10000 => 0x0000_0010 仿真正确
    instruction = 32'h0062_8863;
    imm_src     = 2'b10;
    #10;
    // B-type 
    //instruction[31] = 1
    //instruction[7]  =1
    //instruction[31:24] =1111_1110
    //instruction[30:25] =1111_11
    //instruction[11:8]  =0x8 = 1000

    //11..10000 => 0xFFFF_FFF0 仿真正确
    instruction = 32'hFE62_88E3;
    imm_src     = 2'b10;
    #10;
    //无效imm_src immediate = 0
    instruction = 32'hFFFF_FFFF;
    imm_src     = 2'b11;
    #10;

    $finish;
end

endmodule