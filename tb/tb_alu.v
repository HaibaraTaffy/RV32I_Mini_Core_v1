`timescale 1ns/1ps


module tb_alu;

reg  [31:0] operand_a;
reg  [31:0] operand_b;
reg  [3:0]  alu_control;

wire [31:0] result;
wire        zero;

alu dut (
    .operand_a   (operand_a),
    .operand_b   (operand_b),
    .alu_control (alu_control),
    .result      (result),
    .zero        (zero)
);

initial begin
    operand_a   = 32'd10;
    operand_b   = 32'd3;
    alu_control = 4'b0000;//ADD result = 10+3 = 13 =0000_000D
    #10;

    operand_a   = 32'hFFFF_FFFF;
    operand_b   = 32'd1;
    alu_control = 4'b0000;//ADD result = 0000_0000
    #10;

    operand_a   = 32'd10;
    operand_b   = 32'd3;
    alu_control = 4'b0001;//SUB result = 10-3 = 7
    #10;

    operand_a   = 32'd5;
    operand_b   = 32'd5;
    alu_control = 4'b0001;//SUB result = 0 zero = 1
    #10;

    operand_a   = 32'hA5A5_F0F0;//1010_0101_1010_0101_1111_0000_1111_0000
    operand_b   = 32'h0F0F_3333;//0000_1111_0000_1111_0011_0011_0011_0011
    alu_control = 4'b0010;//AND result = 0000_0101_0000_0101_0011_0000_0011_0000
                                        //0505_3030
    #10;

    alu_control = 4'b0011;//OR result = 1010_1111_1010_1111_1111_0011_1111_0011
    #10;                                //afaf_f3f3

    alu_control = 4'b0100;//XOR result = 1010_1010_1010_1010_1100_0011_1100_0011
    #10;                                //aaaac3c3

    operand_a   = 32'h0000_0003;
    operand_b   = 32'h0000_0002;
    alu_control = 4'b0101;//SLL 逻辑左移 result = 3 * 2^2 = 12 = 32'h 0000_000C
    #10;

    operand_a   = 32'h0000_0003;
    operand_b   = 32'h0000_0022;//0022 -> 0000_0000_0010_0010 取底5位 00010
    alu_control = 4'b0101;//SLL 逻辑左移 result = 3 * 2^2 = 12 = 32'h 0000_000C
    #10;

    operand_a   = 32'hFFFF_FFFF;
    operand_b   = 32'h0000_0001;
    alu_control = 4'b0110;//SLT 小于则置位 result = 1 
    #10;

    operand_a   = 32'h0000_0001;
    operand_b   = 32'hFFFF_FFFF;
    alu_control = 4'b0110;//SLT 小于则置位 result = 0 zero = 0
    #10;

    operand_a   = 32'h8000_0000;//1000_00...
    operand_b   = 32'h0000_0001;
    alu_control = 4'b0111;//SRL 逻辑右移 result = 8000_0000/2 = 4000_0000 
    #10;

    operand_a   = 32'h8000_0000;
    operand_b   = 32'h0000_0001;
    alu_control = 4'b1000;//SRA 算术右移 result = 1100_00...= C000_0000
    #10;

    operand_a   = 32'hFFFF_FFF8;//1111_..._1000
    operand_b   = 32'h0000_0002;
    alu_control = 4'b1000;//算术右移 result = 1111_..._1110 = FFFF_FFFE
    #10;

    operand_a   = 32'h1234_5678;
    operand_b   = 32'h0000_0000;
    alu_control = 4'b1111;//暂时无意义 进入default result = 0 zero = 0
    #10;
    //仿真通过 结果正确!
    $finish;
end

endmodule