// Created by HaibaraTaffy
// RV32I Mini Core v3 - Five-Stage Pipeline Core
// 第一版 不引入 Hazard 只检查 Pipeline Stage 的正确性
module rv32i_pipeline_core #(
    parameter integer IMEM_ADDR_WIDTH = 8,
    parameter integer DMEM_ADDR_WIDTH = 8,
    parameter         IMEM_FILE =
        "programs/pipeline_independent_test.hex"
)(
    input wire clk,
    input wire rst
);

// ============================================================
// IF Stage
// ============================================================

wire [31:0] pc_f;
wire [31:0] next_pc_f;
wire [31:0] pc_plus4_f;
wire [31:0] instruction_f;

assign pc_plus4_f = pc_f + 32'd4;

// 当前课程只支持顺序取指
assign next_pc_f = pc_plus4_f;

// ============================================================
// IF Stage
// ============================================================

pipeline_pc_reg u_pipeline_pc_reg (
    .clk     (clk),
    .rst     (rst),
    .enable  (1'b1),        //in 保持顺序取指 暂时不引入 Stall
    .next_pc (next_pc_f),   //in
    .pc      (pc_f)         //out
);

instruction_memory #(
    .ADDR_WIDTH (IMEM_ADDR_WIDTH),
    .MEM_FILE   (IMEM_FILE)
) u_instruction_memory (
    .address     (pc_f),            //in
    .instruction (instruction_f)    //out
);

// ============================================================
// IF/ID Pipeline Register
// ============================================================

wire        valid_d;
wire [31:0] instruction_d;
wire [31:0] pc_d;
wire [31:0] pc_plus4_d;

if_id_reg u_if_id_reg (
    .clk             (clk),
    .rst             (rst),
    .enable          (1'b1),            //不引入 Stall
    .clear           (1'b0),            //不引入 Flush

    .valid_in        (~rst),            //暂时不引入 Bubble
    .instruction_in  (instruction_f),   
    .pc_in           (pc_f),
    .pc_plus4_in     (pc_plus4_f),

    .valid_out       (valid_d),
    .instruction_out (instruction_d),
    .pc_out          (pc_d),
    .pc_plus4_out    (pc_plus4_d)
);

// ============================================================
// ID Stage
// ============================================================

wire [6:0] opcode_d;
wire [4:0] rd_d;
wire [2:0] funct3_d;
wire [4:0] rs1_d;
wire [4:0] rs2_d;
wire       funct7_bit5_d;

wire       reg_write_d;
wire       alu_src_d;
wire       mem_write_d;
wire [1:0] result_src_d;
wire       branch_d;
wire [1:0] imm_src_d;
wire [1:0] alu_op_d;
wire       jump_d;
wire       jalr_d;

wire [3:0] alu_control_d;

wire [31:0] read_data1_d;
wire [31:0] read_data2_d;
wire [31:0] immediate_d;

assign opcode_d      = instruction_d[6:0];
assign rd_d          = instruction_d[11:7];
assign funct3_d      = instruction_d[14:12];
assign rs1_d         = instruction_d[19:15];
assign rs2_d         = instruction_d[24:20];
assign funct7_bit5_d = instruction_d[30];

main_decoder u_main_decoder (
    .opcode     (opcode_d),
    .reg_write  (reg_write_d),
    .alu_src    (alu_src_d),
    .mem_write  (mem_write_d),
    .result_src (result_src_d),
    .branch     (branch_d),
    .imm_src    (imm_src_d),
    .jump       (jump_d),
    .jalr       (jalr_d),
    .alu_op     (alu_op_d) //out
);

alu_decoder u_alu_decoder (
    .alu_op       (alu_op_d),
    .funct3       (funct3_d),
    .funct7_bit5  (funct7_bit5_d),
    .alu_control  (alu_control_d) //out
);

imm_gen u_imm_gen (
    .instruction (instruction_d),
    .imm_src     (imm_src_d),
    .immediate   (immediate_d) //out
);

// ============================================================
// WB Result and Register File
// ============================================================

wire        valid_w;
wire [31:0] alu_result_w;
wire [31:0] memory_read_data_w;
wire [31:0] pc_plus4_w;
wire [4:0]  rd_w;
wire        reg_write_w;
wire [1:0]  result_src_w;

wire [31:0] write_back_data_w;
wire        reg_write_enable_w;

assign write_back_data_w =
    (result_src_w == 2'b00) ? alu_result_w :
    (result_src_w == 2'b01) ? memory_read_data_w :
    (result_src_w == 2'b10) ? pc_plus4_w :
                              32'b0;

assign reg_write_enable_w =
    valid_w &
    reg_write_w &
    ~rst;

regfile u_regfile (
    .clk          (clk),
    .write_enable (reg_write_enable_w),
    .read_addr1   (rs1_d),
    .read_addr2   (rs2_d),
    .write_addr   (rd_w),
    .write_data   (write_back_data_w),
    .read_data1   (read_data1_d),
    .read_data2   (read_data2_d)
);

// ============================================================
// ID/EX Pipeline Register
// ============================================================

wire        valid_e;

wire [31:0] pc_e;
wire [31:0] pc_plus4_e;
wire [31:0] read_data1_e;
wire [31:0] read_data2_e;
wire [31:0] immediate_e;

wire [4:0] rs1_e;
wire [4:0] rs2_e;
wire [4:0] rd_e;
wire [2:0] funct3_e;

wire [3:0] alu_control_e;
wire       alu_src_e;
wire       reg_write_e;
wire       mem_write_e;
wire [1:0] result_src_e;
wire       branch_e;
wire       jump_e;
wire       jalr_e;

id_ex_reg u_id_ex_reg (
    .clk             (clk),
    .rst             (rst),
    .enable          (1'b1),
    .clear           (1'b0),

    .valid_in        (valid_d),

    .pc_in           (pc_d),
    .pc_plus4_in     (pc_plus4_d),
    .read_data1_in   (read_data1_d),
    .read_data2_in   (read_data2_d),
    .immediate_in    (immediate_d),

    .rs1_in          (rs1_d),
    .rs2_in          (rs2_d),
    .rd_in           (rd_d),
    .funct3_in       (funct3_d),

    .alu_control_in  (alu_control_d),
    .alu_src_in      (alu_src_d),
    .reg_write_in    (reg_write_d),
    .mem_write_in    (mem_write_d),
    .result_src_in   (result_src_d),
    .branch_in       (branch_d),
    .jump_in         (jump_d),
    .jalr_in         (jalr_d),

    .valid_out       (valid_e),

    .pc_out          (pc_e),
    .pc_plus4_out    (pc_plus4_e),
    .read_data1_out  (read_data1_e),
    .read_data2_out  (read_data2_e),
    .immediate_out   (immediate_e),

    .rs1_out         (rs1_e),
    .rs2_out         (rs2_e),
    .rd_out          (rd_e),
    .funct3_out      (funct3_e),

    .alu_control_out (alu_control_e),
    .alu_src_out     (alu_src_e),
    .reg_write_out   (reg_write_e),
    .mem_write_out   (mem_write_e),
    .result_src_out  (result_src_e),
    .branch_out      (branch_e),
    .jump_out        (jump_e),
    .jalr_out        (jalr_e)
);

// ============================================================
// EX Stage
// ============================================================

wire [31:0] alu_operand_b_e;
wire [31:0] alu_result_e;
wire        zero_e;
// 顺序 不引入 Forwarding
assign alu_operand_b_e =
    alu_src_e ? immediate_e : read_data2_e;

alu u_alu (
    .operand_a   (read_data1_e),
    .operand_b   (alu_operand_b_e),
    .alu_control (alu_control_e),
    .result      (alu_result_e),
    .zero        (zero_e)
);

// ============================================================
// EX/MEM Pipeline Register
// ============================================================

wire        valid_m;
wire [31:0] alu_result_m;
wire [31:0] store_data_m;
wire [31:0] pc_plus4_m;
wire [4:0]  rd_m;
wire        reg_write_m;
wire        mem_write_m;
wire [1:0]  result_src_m;

ex_mem_reg u_ex_mem_reg (
    .clk            (clk),
    .rst            (rst),
    .enable         (1'b1),
    .clear          (1'b0),

    .valid_in       (valid_e),
    .alu_result_in  (alu_result_e),
    .store_data_in  (read_data2_e),
    .pc_plus4_in    (pc_plus4_e),
    .rd_in          (rd_e),

    .reg_write_in   (reg_write_e),
    .mem_write_in   (mem_write_e),
    .result_src_in  (result_src_e),

    .valid_out      (valid_m),
    .alu_result_out (alu_result_m),
    .store_data_out (store_data_m),
    .pc_plus4_out   (pc_plus4_m),
    .rd_out         (rd_m),

    .reg_write_out  (reg_write_m),
    .mem_write_out  (mem_write_m),
    .result_src_out (result_src_m)
);

// ============================================================
// MEM Stage
// ============================================================

wire [31:0] memory_read_data_m;
wire        mem_write_enable_m;

assign mem_write_enable_m =
    valid_m &
    mem_write_m &
    ~rst;

data_memory #(
    .ADDR_WIDTH (DMEM_ADDR_WIDTH)
) u_data_memory (
    .clk          (clk),
    .write_enable (mem_write_enable_m),
    .address      (alu_result_m),
    .write_data   (store_data_m), //不引入 Forwarding
    .read_data    (memory_read_data_m)
);

// ============================================================
// MEM/WB Pipeline Register
// ============================================================

mem_wb_reg u_mem_wb_reg (
    .clk                  (clk),
    .rst                  (rst),
    .enable               (1'b1),
    .clear                (1'b0),

    .valid_in             (valid_m),
    .alu_result_in        (alu_result_m),
    .memory_read_data_in  (memory_read_data_m),
    .pc_plus4_in          (pc_plus4_m),
    .rd_in                (rd_m),

    .reg_write_in         (reg_write_m),
    .result_src_in        (result_src_m),

    .valid_out            (valid_w),
    .alu_result_out       (alu_result_w),
    .memory_read_data_out (memory_read_data_w),
    .pc_plus4_out         (pc_plus4_w),
    .rd_out               (rd_w),

    .reg_write_out        (reg_write_w),
    .result_src_out       (result_src_w)
);

endmodule