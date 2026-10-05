// Created by HaibaraTaffy
// RV32I Mini Core v3 - IF/ID Pipeline Register
// 保存指令 和 pc相关 数据 供给后级使用

//////////使用场景///////
// 正常 Fetch
// → enable = 1
// → 保存新 Instruction
// 
// Load-Use Stall
// → enable = 0
// → 保持当前 Instruction
// 
// Branch Flush
// → clear = 1
// → 当前 Instruction 失效
/////////////////////////

module if_id_reg(
    input wire         clk,
    input wire         rst,
    input wire         enable,
    input wire         clear,

    input wire         valid_in,
    input wire [31:0]  instruction_in,
    input wire [31:0]  pc_in,
    input wire [31:0]  pc_plus4_in,

    output reg         valid_out,
    output reg [31:0]  instruction_out,
    output reg [31:0]  pc_out,
    output reg [31:0]  pc_plus4_out
);

always @(posedge clk) begin
    if (rst) begin
        valid_out       <= 1'b0;
        instruction_out <= 32'b0;
        pc_out          <= 32'b0;
        pc_plus4_out    <= 32'b0;
    end
    else if (clear) begin
        valid_out       <= 1'b0;
        instruction_out <= 32'b0;
        pc_out          <= 32'b0;
        pc_plus4_out    <= 32'b0;
    end
    else if (enable) begin
        valid_out       <= valid_in;
        instruction_out <= instruction_in;
        pc_out          <= pc_in;
        pc_plus4_out    <= pc_plus4_in;
    end
    // else hold 保持当前状态
end

endmodule