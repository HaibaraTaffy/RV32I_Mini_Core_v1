
// Created by HaibaraTaffy
// RV32I Mini Core v3 - Pipeline PC Register

// enable=1 用于正常取指 取出next_pc
// enable=0 用于保持现在pc stall时使用
module pipeline_pc_reg #(
    parameter [31:0] RESET_VECTOR = 32'h0000_0000
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        enable,
    input  wire [31:0] next_pc,
    output reg  [31:0] pc
);

always @(posedge clk) begin
    if (rst)
        pc <= RESET_VECTOR;
    else if (enable)
        pc <= next_pc;
end

endmodule