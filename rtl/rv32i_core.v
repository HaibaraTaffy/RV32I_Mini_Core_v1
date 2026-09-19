// Created by HaibaraTaffy
// RV32I Mini Core - rv32i_core

///////////////完整CPU结构//////////
//PC Register
//    ↓
//Instruction Memory
//    ↓
//Instruction
//    ├─ Opcode ─────────→ Main Decoder
//    ├─ funct3/funct7 ─→ ALU Decoder
//    ├─ rs1/rs2/rd ────→ Register File
//    └─ Immediate Bits → ImmGen
//
//Register File
//    ↓
//ALUSrc MUX
//    ↓
//ALU
//    ├─→ Data Memory
//    ├─→ Write-Back MUX
//    └─→ Zero
//
//Data Memory
//    ↓
//Write-Back MUX
//    ↓
//Register File
//
//Branch + Zero
//    ↓
//Next-PC Logic
//    ↓
//PC Register

module rv32i_core #(
    //虽然地址位宽 32bit 但是我们暂时只用8位
    parameter integer IMEM_ADDR_WIDTH = 8, //指令存储器的地址宽度
    parameter integer DMEM_ADDR_WIDTH = 8, //数据存储器的地址宽度
    parameter         IMEM_FILE       ="programs/imem_test.hex"
)(
    input wire clk,
    input wire rst
);

//PC 与 Instruction
wire [31:0] pc; 
wire [31:0] next_pc;
wire [31:0] pc_plus4;
wire [31:0] branch_target;
wire [31:0] jalr_target;
wire [31:0] instruction;

//Instruction Field
wire      [6:0]         opcode  ; 
wire      [4:0]         rd      ;
wire      [2:0]         funct3  ;
wire      [4:0]         rs1     ;
wire      [4:0]         rs2     ;
wire                    funct7_bit5;

//Main Decoder Control Signals
wire                    reg_write ;//决定是否写寄存器
wire                    alu_src   ;//决定alu Operand B的来源
wire                    mem_write ;//决定是否写存储器
wire      [1:0]         result_src;//决定写回 Register File 的数据来源
wire                    branch    ;//是否是branch指令
wire      [1:0]         imm_src   ;//Instruction Format 用于译出立即数
wire      [1:0]         alu_op    ;//alu的操作码 由 main_decoder产生
wire                    jump      ;//是否是jal指令
wire                    jalr      ;//是否是jalr指令  
//Register File
wire [31:0]     read_data1;
wire [31:0]     read_data2;

//Immediate
wire [31:0]     immediate;

//ALU
wire [3:0]      alu_control;//alu_decoder由alu_op f3和f7 译出 来指导alu做操作
wire [31:0]     alu_operand_b;//由alu operand B mux 选出 参与alu运算
wire [31:0]     alu_result;//alu计算结果 可能是Address 也可能是data
wire            zero     ;       //用于 branch 的跳转
wire            less_than;       //用于 branch 的跳转

//Data Memory 与 Write Back
wire [31:0]     memory_read_data;
wire [31:0]     write_back_data;//用于写回RF

// Next-PC Control
wire pc_src;
//用于rst复位
wire reg_write_enable;
wire mem_write_enable;

assign reg_write_enable = reg_write & ~rst;
assign mem_write_enable = mem_write & ~rst;

// Instruction字段拆分
assign opcode      = instruction[6:0];//送入 main_decoder进行译码
assign rd          = instruction[11:7];//目的寄存器编号
assign funct3      = instruction[14:12];//f3 用于alu_decoder区分指令
assign rs1         = instruction[19:15];//源寄存器1
assign rs2         = instruction[24:20];//源寄存器2
assign funct7_bit5 = instruction[30];//f7 用于alu_decoder区分指令

//ALU Operand B MUX 
assign alu_operand_b = alu_src ? immediate : read_data2;
// Write-Back MUX 根据opcode译出的控制信号 
// 选择写回RF的数据来源
assign write_back_data =
    (result_src == 2'b00) ? alu_result :
    (result_src == 2'b01) ? memory_read_data :
    (result_src == 2'b10) ? pc_plus4 :
    32'b0;
assign less_than = alu_result[0];

pc_reg u_pc_reg(
    .clk    (clk),
    .rst    (rst),
    .next_pc(next_pc),
    .pc     (pc)
);

//指令存储器 根据pc取出 instruction
instruction_memory #(
    .ADDR_WIDTH (IMEM_ADDR_WIDTH),
    .MEM_FILE   (IMEM_FILE)
)u_instruction_memory(
    .address        (pc)    ,
    .instruction    (instruction)
);

//主译码器
//根据 opcode 译出控制信号
main_decoder u_main_decoder(
   .opcode      (opcode)            ,
   .reg_write   (reg_write )        ,
   .alu_src     (alu_src   )        ,
   .mem_write   (mem_write )        ,
   .result_src  (result_src)        ,
   .branch      (branch    )        ,
   .jump        (jump      )        ,
   .jalr        (jalr      )        ,
   .imm_src     (imm_src   )        ,
   .alu_op      (alu_op    )
);

//由alu_op f3 f7 译出 alu_control 用于指导alu计算
alu_decoder u_alu_decoder(
    .alu_op       (alu_op)     ,
    .funct3       (funct3)     ,
    .funct7_bit5  (funct7_bit5)     ,
    .alu_control  (alu_control) 
);

regfile u_regfile(
    .clk(clk),
    .write_enable(reg_write_enable),//根据控制信号 是否写入
    .read_addr1(rs1),//instruction 传入源寄存器1序号
    .read_addr2(rs2),//instruction 传入源寄存器2序号
    .write_addr(rd), //instruction 传入目标寄存器序号
    .write_data(write_back_data),//由 MUX选择出来的 写回数据
    .read_data1(read_data1), //由read_addr1 读出的数据
    .read_data2 (read_data2)  //由read_addr2 读出的数据
);

imm_gen u_imm_gen(
    .instruction     (instruction)   ,//提供立即数的素材
    .imm_src         (imm_src)   ,    //告知是使用什么Format
    .immediate       (immediate)      //译出立即数
);

// alu的第一个操作数 一定来自 rs1 
//第二个操作数 可能来自rs2 也可能来自立即数
//根据 alu_control 进行操作
//得到 alu_result 和 zero
alu u_alu(
    .operand_a  (read_data1)     ,
    .operand_b  (alu_operand_b)  ,
    .alu_control(alu_control)    ,
    .result     (alu_result)     ,
    .zero       (zero)
);

//数据存储器 根据mem_write(由main_decoder译出)控制写入
//lw sw的指令算出的地址 由alu_result得到
//写入的data 来自 read_data2
//读出的 data 驱动到 memory_read_data，供 Write-Back MUX 使用
data_memory #(
    .ADDR_WIDTH(DMEM_ADDR_WIDTH)
)u_data_memory(
    .clk           (clk) ,
    .write_enable  (mem_write_enable) ,
    .address       (alu_result) ,
    .write_data    (read_data2) ,
    .read_data     (memory_read_data)
);

next_pc_logic u_next_pc_logic(
    .current_pc   (pc           )    ,
    .immediate    (immediate    )    ,
    .alu_result   (alu_result   )    ,
    .funct3       (funct3       )    ,
    .branch       (branch       )    ,
    .zero         (zero         )    ,
    .less_than    (less_than    )    ,
    .jump         (jump         )    ,
    .jalr         (jalr         )    ,
    .pc_plus4     (pc_plus4     )    ,
    .branch_target(branch_target)    ,
    .jalr_target  (jalr_target  )    ,
    .pc_src       (pc_src       )    ,
    .next_pc      (next_pc      )
);



endmodule