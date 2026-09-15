`timescale 1ns/1ps

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
    alu_control = 4'b0000;
    #10;

    operand_a   = 32'hFFFF_FFFF;
    operand_b   = 32'd1;
    alu_control = 4'b0000;
    #10;

    operand_a   = 32'd10;
    operand_b   = 32'd3;
    alu_control = 4'b0001;
    #10;

    operand_a   = 32'd5;
    operand_b   = 32'd5;
    alu_control = 4'b0001;
    #10;

    operand_a   = 32'hA5A5_F0F0;
    operand_b   = 32'h0F0F_3333;
    alu_control = 4'b0010;
    #10;

    alu_control = 4'b0011;
    #10;

    alu_control = 4'b0100;
    #10;

    alu_control = 4'b1111;
    #10;

    $finish;
end

endmodule