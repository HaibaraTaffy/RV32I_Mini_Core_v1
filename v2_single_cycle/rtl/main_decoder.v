// Created by HaibaraTaffy
// RV32I Mini Core - Main Decoder

//////////////////////
// Opcode
//   ↓
// Main Decoder
//   │
//   ├─ reg_write
//   ├─ alu_src
//   ├─ mem_write
//   ├─ result_src
//   ├─ branch
//   ├─ imm_src
//   ├─ jump
//   └─ alu_op
//////////////////////

/////////////////////////////////////////////////////////
//| 指令类别   | Opcode    | 当前指令                  |
//| ------ | --------- | ---------------------------- |
//| OP     | `0110011` | `add`、`sub`、`and`、`or`、`xor` |
//| OP-IMM | `0010011` | `addi`                       |
//| LOAD   | `0000011` | `lw`                         |
//| STORE  | `0100011` | `sw`                         |
//| BRANCH | `1100011` | `beq` `bnq` `blt` `bge`      |   
//| JAL    | `1101111` | `jal`                        |
//| JALR   | `1100111` | `jalr`                       |

//这些指令 由RISC-V ISA 规定 无法自行修改
////////////////////////////////////////////////////////

//////////////Control_signals//////////
//reg_write     是否写RF             0不允许写RF             1允许写RF
//alu_src       选择 Operand2        0选择RF                 1选择Immediate
//mem_write     是否写 Data Memory   0不写Data Memory        1写Data Memory
//result_src    选择写回 RF的数据     00 ALU Result写回       01 Memory Read Data写回 10 PC+4 写回
//branch        表示是否为条件Branch  0 其他指令              1 是beq指令  注:后续用于生成 PCSrc
//imm_src       选择ImmGen 使用的格式 00 -> I  01 -> S  10 -> B
//alu_op        ALU操作类别          00 -> 直接执行ADD 01 -> Branch比较 ALU执行SUB 10 -> 根据f3和f7继续译码 注:并非最终 alu_Control
//jump          表示是否为 jal        0 否                    1 是
//jalr          表示是否为 jalr       0 否                    1 是

/////////第二版的 Control Table ///////////
//| 类别     | reg_write | alu_src | mem_write | result_src | branch | imm_src | alu_op | jump | jalr|
//| ------  | --------: | ------: | --------: | ---------:  | -----: | ------: | -----: | ----:| --: |
//| OP      |         1 |       0 |         0 |          00 |      0 |      00 |     10 |    0 |   0 |
//| OP-IMM  |         1 |       1 |         0 |          00 |      0 |      00 |     00 |    0 |   0 |
//| LOAD    |         1 |       1 |         0 |          01 |      0 |      00 |     00 |    0 |   0 |
//| STORE   |         0 |       1 |         1 |          00 |      0 |      01 |     00 |    0 |   0 |
//| BRANCH  |         0 |       0 |         0 |          00 |      1 |      10 |     01 |    0 |   0 |
//| JAL     |         1 |       0 |         0 |          10 |      0 |      11 |     00 |    1 |   0 |
//| JALR    |         1 |       1 |         0 |          10 |      0 |      00 |     00 |    0 |   1 |
//| unknown |         0 |       0 |         0 |          00 |      0 |      00 |     00 |    0 |   0 |
////////////////////////////

//注 : 对于OP imm_src 无作用
//对于 STORE 和 BRANCH result_src 无实际作用

module main_decoder(
    input wire      [6:0]         opcode,//可以通过截位得到
    output reg                    reg_write ,
    output reg                    alu_src   ,
    output reg                    mem_write ,
    output reg      [1:0]         result_src,
    output reg                    branch    ,
    output reg      [1:0]         imm_src   ,
    output reg                    jump      ,
    output reg                    jalr      ,
    output reg      [1:0]         alu_op      
);
//7位操作码
localparam [6:0] OPCODE_OP     = 7'b0110011;
localparam [6:0] OPCODE_OP_IMM = 7'b0010011;
localparam [6:0] OPCODE_LOAD   = 7'b0000011;
localparam [6:0] OPCODE_STORE  = 7'b0100011;
localparam [6:0] OPCODE_BRANCH = 7'b1100011;
localparam [6:0] OPCODE_JUMP   = 7'b1101111;
localparam [6:0] OPCODE_JALR   = 7'b1100111;

always @(*) begin
    //设置默认值
    reg_write = 1'b0;// 默认禁止写Register File
    alu_src   = 1'b0;//默认选择RF为输入源
    mem_write = 1'b0;//默认不写Data Memory
    result_src= 2'b00;//默认ALU Result 写回RF
    branch    = 1'b0;//默认不是beq指令
    imm_src   = 2'b00;//默认I-type
    jump      = 1'b0 ;//默认 不执行jal
    jalr      = 1'b0 ;//默认 不执行jalr
    alu_op    = 2'b00;//默认 直接执行ADD

    case(opcode)
        OPCODE_OP: begin        //OP操作 只涉及寄存器和ALU
            reg_write = 1'b1;   // 允许写Register File 
            alu_op    = 2'b10;  //选择继续译码
        end

        OPCODE_OP_IMM: begin   // IMM操作 涉及寄存器 ImmGen ALU
            reg_write = 1'b1;  // 允许写Register File
            alu_src   = 1'b1;  //选择Immediate
            imm_src   = 2'b00; //选择I-type 对应Immediate
            alu_op    = 2'b00; //默认执行ADD
        end

        OPCODE_LOAD: begin      //LOAD 操作 涉及寄存器 ALU Data Memory ImmGen
            reg_write  = 1'b1;  // 允许写Register File
            alu_src    = 1'b1;  //选择Immediate
            result_src = 2'b01;  //用Data Memory中的数据写回RF
            imm_src    = 2'b00; //选择I-type 涉及Immediate
            alu_op     = 2'b00; //默认执行ADD
        end

        OPCODE_STORE: begin
            alu_src   = 1'b1;   // 选择 Immediate
            mem_write = 1'b1;   // 写 Data Memory
            imm_src   = 2'b01;  // 选择 S-type
            alu_op    = 2'b00;  // 默认执行ADD
        end

        OPCODE_BRANCH: begin
            branch  = 1'b1;     // 表示 是branch类指令
            imm_src = 2'b10;    // 选择 B-type
            alu_op  = 2'b01;    // 进行branch比较
        end

        OPCODE_JUMP: begin
            reg_write = 1'b1;   //允许写入寄存器
            result_src = 2'b10; //选择 PC+4为写入寄存器的数据
            jump = 1'b1; //表示 是 jal指令
            imm_src = 2'b11;    //选择 J-type

        end
        
        OPCODE_JALR : begin
            reg_write  = 1'b1; //允许写入寄存器
            alu_src    = 1'b1; //Operand 2 来自立即数
            result_src = 2'b10;// 选择PC + 4为写入寄存器的数据
            imm_src    = 2'b00;//选择 I-type
            jalr       = 1'b1; //表示 是jalr指令
            alu_op     = 2'b00;//需要alu计算 直接执行add(算地址)
        end

        default: begin
            reg_write  = 1'b0;
            alu_src    = 1'b0;
            mem_write  = 1'b0;
            result_src = 2'b00;
            jump       = 1'b0 ;
            branch     = 1'b0;
            imm_src    = 2'b00;
            alu_op     = 2'b00;
        end
        endcase
end

endmodule