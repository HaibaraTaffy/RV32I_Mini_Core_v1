`timescale 1ns/1ps

module tb_alu_decoder;

reg  [1:0] alu_op;
reg  [2:0] funct3;
reg        funct7_bit5;
wire [3:0] alu_control;

alu_decoder dut (
    .alu_op       (alu_op),
    .funct3       (funct3),
    .funct7_bit5  (funct7_bit5),
    .alu_control  (alu_control)
);

initial begin
    alu_op      = 2'b00;
    funct3      = 3'b000;
    funct7_bit5 = 1'b0;
    #10;//直接执行ADD 输出应为 0000

    alu_op      = 2'b01;
    funct3      = 3'b000;
    funct7_bit5 = 1'b0;
    #10;//直接执行SUB 输出应为 0001

    alu_op      = 2'b10;
    funct3      = 3'b000;
    funct7_bit5 = 1'b0;
    #10;//根据f3 f7判断 应为ALU_ADD 0000

    funct7_bit5 = 1'b1;
    #10;//根据f3 f7判断 应为ALU_SUB 0001

    funct3      = 3'b111;
    funct7_bit5 = 1'b0;
    #10;//根据f3 f7判断 应为ALU_AND 0010

    funct3      = 3'b110;
    #10;//根据f3 应为ALU_OR 0011

    funct3      = 3'b100;
    #10;//根据f3 应为ALU_XOR 0100

    funct3      = 3'b010;
    #10;//根据f3 暂时不支持 输出默认值 应为ALU_ADD 0000

    alu_op      = 2'b11;
    funct3      = 3'b000;
    funct7_bit5 = 1'b0;
    #10;//无效op 应为默认值 ALU_ADD 0000

    $finish;
    //全部仿真正确
end

endmodule