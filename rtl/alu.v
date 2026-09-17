// Created by HaibaraTaffy
// RV32I Mini Core - Arithmetic Logic Unit

//ALUControl
//0000 → ADD
//0001 → SUB
//0010 → AND
//0011 → OR
//0100 → XOR

module alu (
    input   wire    [31:0]  operand_a   ,
    input   wire    [31:0]  operand_b   ,
    input   wire    [3:0]   alu_control ,
    output  reg     [31:0]  result      ,
    output  wire            zero  
);
// ALUControl
localparam [3:0] ALU_ADD = 4'b0000 ;
localparam [3:0] ALU_SUB = 4'b0001 ;
localparam [3:0] ALU_AND = 4'b0010 ;
localparam [3:0] ALU_OR  = 4'b0011 ;
localparam [3:0] ALU_XOR = 4'b0100 ;
localparam [3:0] ALU_SLL = 4'b0101;
localparam [3:0] ALU_SLT = 4'b0110;
localparam [3:0] ALU_SRL = 4'b0111;
localparam [3:0] ALU_SRA = 4'b1000;

always @(*) begin       //组合逻辑
    case (alu_control)
        ALU_ADD :  result = operand_a + operand_b;
        ALU_SUB :  result = operand_a - operand_b;
        ALU_AND :  result = operand_a & operand_b;
        ALU_OR  :  result = operand_a | operand_b;
        ALU_XOR :  result = operand_a ^ operand_b;

        ALU_SLL :  result = operand_a << operand_b[4:0];
        ALU_SLT :  result =
                    ($signed(operand_a) < $signed(operand_b))
                    ? 32'd1 : 32'd0;
        ALU_SRL :  result = operand_a >> operand_b[4:0];
        ALU_SRA :  result = $signed(operand_a) >>> operand_b[4:0];

        default :  result = 32'b0;//防止latch
    endcase
end

assign zero = (result == 32'b0);
// 结果为0 zero为真 反之 zero 为假
//可以为后续 Branch Logic 提供

endmodule