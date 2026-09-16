`timescale 1ns/1ps

module tb_main_decoder;

reg  [6:0] opcode;

wire       reg_write;
wire       alu_src;
wire       mem_write;
wire       result_src;
wire       branch;
wire [1:0] imm_src;
wire [1:0] alu_op;

main_decoder dut (
    .opcode     (opcode),
    .reg_write  (reg_write),
    .alu_src    (alu_src),
    .mem_write  (mem_write),
    .result_src (result_src),
    .branch     (branch),
    .imm_src    (imm_src),
    .alu_op     (alu_op)
);

initial begin
    opcode = 7'b0110011;//OP reg_write =1 alu_op = 10
    #10;

    opcode = 7'b0010011;//OP-IMM
    #10;

    opcode = 7'b0000011;//LOAD
    #10;

    opcode = 7'b0100011;//STORE
    #10;

    opcode = 7'b1100011;//BRANCH
    #10;

    opcode = 7'b1111111;//未识别
    #10;
                        //仿真全通过
    $finish;
end

endmodule