`timescale 1ns/1ps

module tb_pipeline_pc_reg;

reg         clk;
reg         rst;
reg         enable;
reg  [31:0] next_pc;

wire [31:0] pc;

pipeline_pc_reg dut (
    .clk     (clk),
    .rst     (rst),
    .enable  (enable),
    .next_pc (next_pc),
    .pc      (pc)
);

always #5 clk = ~clk;

initial begin
    clk     = 1'b0;
    rst     = 1'b1;
    enable  = 1'b0;
    next_pc = 32'h0000_0000;

    #20;
    rst = 1'b0;

    // Normal update
    // 正常更新 pc = next_pc = 0000_0004
    enable  = 1'b1;
    next_pc = 32'h0000_0004;
    #10;
    // 正常更新 pc = next_pc = 0000_0008
    next_pc = 32'h0000_0008;
    #10;

    // Stall 不更新 pc = pc = 0000_0008
    enable  = 1'b0;
    next_pc = 32'h0000_000C;
    #20;

    // Continue
    // 继续更新 pc = next_pc = 0000_000C
    enable  = 1'b1;
    #10;

    // Reset has highest priority
    // 复位 pc = RESET_VECTOR = 0000_0000
    rst     = 1'b1;
    next_pc = 32'h0000_0010;
    #10;
    // 取消复位 pc = next_pc = 0000_0010
    rst = 1'b0;
    #10;

    //仿真通过

    $finish;
end

endmodule