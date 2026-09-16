`timescale 1ns/1ps


//目前指令包含
//addi x1, x0, 5
//addi x2, x0, 7
//add  x3, x1, x2
//sub  x4, x1, x2
module tb_rv32i_core;

reg clk;
reg rst;

rv32i_core #(
    .IMEM_ADDR_WIDTH (8),
    .DMEM_ADDR_WIDTH (8),
    .IMEM_FILE       ("programs/imem_test.hex")
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

    #100;

    $finish;
end

endmodule