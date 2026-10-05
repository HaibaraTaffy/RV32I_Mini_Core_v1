`timescale 1ns/1ps

module tb_rv32i_pipeline_core;

reg clk;
reg rst;

rv32i_pipeline_core #(
    .IMEM_ADDR_WIDTH (8),
    .DMEM_ADDR_WIDTH (8),
    .IMEM_FILE (
        "programs/pipeline_independent_test.hex"
    )
) dut (
    .clk (clk),
    .rst (rst)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst = 1'b1;

    #20;
    rst = 1'b0;

    #160;

    $finish;
end

endmodule