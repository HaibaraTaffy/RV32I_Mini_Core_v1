// Created by HaibaraTaffy
// RV32I Mini Core - Next pc logic

// 第一版支持顺序执行PC+4，以及beq成立时跳转到Branch Target
// 第二版扩展了另外三条指令 BNE BLT BGE 采取branch_condition 
// 来统一判断

// 需要根据 funct3 来判断是哪种分支指令

//////////ALUOp = 01///////////////
//| funct3 | funct7_bit5 | ALU操作 |
//| ------ | ----------: | ----- |
//| `000`  |           0 | BEQ   |
//| `001`  |           0 | BNE   |
//| `100`  |           0 | BLT   |
//| `101`  |           0 | BGE   |

//pcsrc = branch && branch_condition

//在时钟边缘让PC读取next_pc

//Current PC
//    ↓
//Next-PC Logic
//    ↓
//next_pc
//    ↓
//PC Register
//    ↓
//New Current PC

module next_pc_logic (
    input  wire [31:0] current_pc,
    input  wire [31:0] immediate,
    input  wire [31:0] alu_result,
    input  wire [2:0]  funct3,
    input  wire        branch,
    input  wire        zero,
    input  wire        less_than,  
    input  wire        jump,
    input  wire        jalr,

    output wire [31:0] pc_plus4,
    output wire [31:0] branch_target,
    output wire        pc_src,
    output wire [31:0] jalr_target,
    output wire [31:0] next_pc
);

reg branch_condition;

//纯组合逻辑 时序交给pc去控制
assign pc_plus4 = current_pc + 32'd4;

assign branch_target = current_pc + immediate;
//jalr_target 由alu算出 这里只是清低位零
assign jalr_target = {alu_result[31:1],1'b0};
//由 funct3 来判断 现在是什么指令 对应的branch条件是什么
//branch_condition 该看哪个信号

always @(*) begin
    branch_condition = 1'b0;

    case (funct3)
        3'b000 : begin //BEQ
            branch_condition = zero;
        end

        3'b001 : begin //BNE
            branch_condition = ~zero;
        end

        3'b100 : begin//BLT
            branch_condition = less_than;
        end

        3'b101 : begin//BGE
            branch_condition = ~less_than;
        end

        default : begin
            branch_condition = 1'b0;
        end
    endcase
end

assign pc_src = jalr | jump | (branch & branch_condition);

assign next_pc =
    jalr ? jalr_target :
    pc_src ? branch_target : 
    pc_plus4;

endmodule