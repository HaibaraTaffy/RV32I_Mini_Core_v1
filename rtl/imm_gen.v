// Created by HaibaraTaffy
// RV32I Mini Core - Immediate Generator


//接收32-bit Instruction
//        ↓
//根据Instruction Format重新排列立即数字段
//        ↓
//进行Sign Extension
//        ↓
//输出32-bit Immediate

//先支持 I-type S-type B-type 由imm_src来判断

//第一版控制编码
//imm_src = 00 → I-type
//imm_src = 01 → S-type
//imm_src = 10 → B-type
//imm_src = 11 → 未定义

module imm_gen(
    input   wire    [31:0]  instruction,
    input   wire    [1:0]   imm_src,
    output  reg     [31:0]  immediate
);

//I S B 对应的imm_src
localparam [1:0] IMM_I = 2'b00;
localparam [1:0] IMM_S = 2'b01;
localparam [1:0] IMM_B = 2'b10;

always @(*) begin
    case (imm_src)//组合逻辑 根据Instruction Format 进而生成32bit Immediate
        IMM_I : begin
            immediate = {
                {20{instruction[31]}},
                instruction[31:20]
            };
        end

        IMM_S: begin
            immediate = {
                {20{instruction[31]}},
                instruction[31:25],
                instruction[11:7]
            };
        end

        IMM_B: begin
            immediate = {
                {19{instruction[31]}},
                instruction[31],
                instruction[7],
                instruction[30:25],
                instruction[11:8],
                1'b0
            };
        end

        default: begin
            immediate = 32'b0;
        end
    endcase
end

endmodule