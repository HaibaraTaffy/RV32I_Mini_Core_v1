// RV32I Mini Core - Next pc logic

//只支持 beq +4

//PCSrc = branch && zero

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
    input  wire        branch,
    input  wire        zero,

    output wire [31:0] pc_plus4,
    output wire [31:0] branch_target,
    output wire        pc_src,
    output wire [31:0] next_pc
);
//纯组合逻辑 时序交给pc去控制
assign pc_plus4 = current_pc + 32'd4;

assign branch_target = current_pc + immediate;

assign pc_src = branch & zero;

assign next_pc =
    pc_src ? branch_target : pc_plus4;

endmodule