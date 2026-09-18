// Created by HaibaraTaffy
// RV32I Mini Core - ALU_decoder
// 第一版 暂时只接受 f7[5] 即Instruction[30] 就够了

//因为 add sub需要通过 instruction[30] 区分 其余的可以通过f3来区分

//现有ALUControl编码
//0000 → ADD
//0001 → SUB
//0010 → AND
//0011 → OR
//0100 → XOR
//0101 → SLL
//0110 → SLT
//0111 → SRL
//1000 → SRA

//ALUOp

//00 -> 直接执行ADD 不检查f3 f7 用于addi lw sw地址计算
//01 -> 直接执行SUB 用于beq比较
//10 -> 继续根据 f3 和 f7 判断 add sub and or xor SLL SLT SRL SRA

//| funct3 | funct7_bit5 | ALU操作 |
//| ------ | ----------: | ----- |
//| `000`  |           0 | ADD   |
//| `000`  |           1 | SUB   |
//| `111`  |           X | AND   |
//| `110`  |           X | OR    |
//| `100`  |           X | XOR   |
//| `001`  |           0 | SLL   |
//| `010`  |           0 | SLT   |
//| `101`  |           0 | SRL   |
//| `101`  |           1 | SRA   |


module alu_decoder(
    input wire [1:0] alu_op,
    input wire [2:0] funct3,
    input wire       funct7_bit5,
    output reg [3:0] alu_control
);

localparam [3:0] ALU_ADD = 4'b0000;
localparam [3:0] ALU_SUB = 4'b0001;
localparam [3:0] ALU_AND = 4'b0010;
localparam [3:0] ALU_OR  = 4'b0011;
localparam [3:0] ALU_XOR = 4'b0100;
localparam [3:0] ALU_SLL = 4'b0101;
localparam [3:0] ALU_SLT = 4'b0110;
localparam [3:0] ALU_SRL = 4'b0111;
localparam [3:0] ALU_SRA = 4'b1000;

always @(*) begin
    alu_control = ALU_ADD;//默认相加

    case (alu_op)
        2'b00: begin
            alu_control = ALU_ADD;
        end

        2'b01: begin
            alu_control = ALU_SUB;
        end

        2'b10: begin
            case (funct3)
                3'b000: begin
                    if (funct7_bit5)
                        alu_control = ALU_SUB;
                    else
                        alu_control = ALU_ADD;
                end

                3'b001: begin
                    alu_control = ALU_SLL;
                end

                3'b010: begin
                    alu_control = ALU_SLT;
                end

                3'b100: begin
                    alu_control = ALU_XOR;
                end


                3'b101: begin
                    if (funct7_bit5)
                        alu_control = ALU_SRA;
                    else
                        alu_control = ALU_SRL; 
                end

                3'b110: begin
                    alu_control = ALU_OR;
                end

                3'b111: begin
                    alu_control = ALU_AND;
                end

                default: begin
                    alu_control = ALU_ADD;
                end
            endcase
        end

        default: begin
            alu_control = ALU_ADD;
        end
    endcase
end

endmodule