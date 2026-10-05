// Created by HaibaraTaffy
// RV32I Mini Core v3 - ID/EX Pipeline Register
// 存放译码之后的信息 供给后级使用

module id_ex_reg(
    input wire         clk,
    input wire         rst,
    input wire         enable,
    input wire         clear,

    input wire         valid_in,

    input wire [31:0]  pc_in,
    input wire [31:0]  pc_plus4_in,
    input wire [31:0]  read_data1_in,
    input wire [31:0]  read_data2_in,
    input wire [31:0]  immediate_in,

    input wire [4:0]   rs1_in,
    input wire [4:0]   rs2_in,
    input wire [4:0]   rd_in,
    input wire [2:0]   funct3_in,

    input wire [3:0]   alu_control_in,
    input wire         alu_src_in,
    input wire         reg_write_in,
    input wire         mem_write_in,
    input wire [1:0]   result_src_in,
    input wire         branch_in,
    input wire         jump_in,
    input wire         jalr_in,

    output reg         valid_out,

    output reg [31:0]  pc_out,
    output reg [31:0]  pc_plus4_out,
    output reg [31:0]  read_data1_out,
    output reg [31:0]  read_data2_out,
    output reg [31:0]  immediate_out,

    output reg [4:0]   rs1_out,
    output reg [4:0]   rs2_out,
    output reg [4:0]   rd_out,
    output reg [2:0]   funct3_out,

    output reg [3:0]   alu_control_out,
    output reg         alu_src_out,
    output reg         reg_write_out,
    output reg         mem_write_out,
    output reg [1:0]   result_src_out,
    output reg         branch_out,
    output reg         jump_out,
    output reg         jalr_out
);

always @(posedge clk) begin
    if (rst) begin//复位
        valid_out       <= 1'b0;
        pc_out          <= 32'b0;
        pc_plus4_out    <= 32'b0;
        read_data1_out  <= 32'b0;
        read_data2_out  <= 32'b0;
        immediate_out   <= 32'b0;
        rs1_out         <= 5'b0;
        rs2_out         <= 5'b0;
        rd_out          <= 5'b0;
        funct3_out      <= 3'b0;
        alu_control_out <= 4'b0;
        alu_src_out     <= 1'b0;
        reg_write_out   <= 1'b0;
        mem_write_out   <= 1'b0;
        result_src_out  <= 2'b0;
        branch_out      <= 1'b0;
        jump_out        <= 1'b0;
        jalr_out        <= 1'b0;
    end
    else if (clear) begin//flush
        valid_out       <= 1'b0;
        pc_out          <= 32'b0;
        pc_plus4_out    <= 32'b0;
        read_data1_out  <= 32'b0;
        read_data2_out  <= 32'b0;
        immediate_out   <= 32'b0;
        rs1_out         <= 5'b0;
        rs2_out         <= 5'b0;
        rd_out          <= 5'b0;
        funct3_out      <= 3'b0;
        alu_control_out <= 4'b0;
        alu_src_out     <= 1'b0;
        reg_write_out   <= 1'b0;
        mem_write_out   <= 1'b0;
        result_src_out  <= 2'b0;
        branch_out      <= 1'b0;
        jump_out        <= 1'b0;
        jalr_out        <= 1'b0;
    end
    else if (enable) begin //正常pipeline
        valid_out       <= valid_in;
        pc_out          <= pc_in;
        pc_plus4_out    <= pc_plus4_in;
        read_data1_out  <= read_data1_in;
        read_data2_out  <= read_data2_in;
        immediate_out   <= immediate_in;
        rs1_out         <= rs1_in;
        rs2_out         <= rs2_in;
        rd_out          <= rd_in;
        funct3_out      <= funct3_in;
        alu_control_out <= alu_control_in;
        alu_src_out     <= alu_src_in;
        reg_write_out   <= reg_write_in;
        mem_write_out   <= mem_write_in;
        result_src_out  <= result_src_in;
        branch_out      <= branch_in;
        jump_out        <= jump_in;
        jalr_out        <= jalr_in;
    end
    //else hold 用于 stall
end

endmodule