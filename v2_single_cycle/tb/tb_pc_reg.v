`timescale 1ns/1ps

// TODO: Add a self-checking testbench for rtl/pc_reg.v.

module tb_pc_reg;

reg clk;
reg rst;
reg  [31:0] next_pc;
wire [31:0] pc;

pc_reg#(
    .RESET_VECTOR(32'h0000_0000)
) dut(
    .clk        (clk),
    .rst        (rst),
    .next_pc    (next_pc),
    .pc         (pc)
);

always #5 clk = ~clk;//T = 10ns f = 100Mhz

task check_pc;
    input [31:0] expected_pc;
    begin
        #1;
        if (pc !== expected_pc) begin
            $display(
                "[FAIL] time=%0t pc=%h expected=%h",
                $time,
                pc,
                expected_pc
            );
            $stop;
        end
        else begin
            $display(
                "[PASS] time=%0t pc=%h",
                $time,
                pc
            );
        end
    end
endtask

initial begin
    clk     = 1'b0;
    rst     = 1'b1;
    next_pc = 32'hDEAD_BEEF;

    // rst优先级测试
    @(posedge clk);
    check_pc(32'h0000_0000);

    // 正常更新到PC+4
    rst     = 1'b0;
    next_pc = 32'h0000_0004;

    @(posedge clk);
    check_pc(32'h0000_0004);

    // 再执行一次顺序更新
    next_pc = 32'h0000_0008;

    @(posedge clk);
    check_pc(32'h0000_0008);

    // 验证同步复位不会立即改变PC
    rst = 1'b1;
    #2;

    if (pc !== 32'h0000_0008) begin
        $display(
            "[FAIL] synchronous reset changed pc before clock edge"
        );
        $stop;
    end

    // 到达Clock Edge以后才复位
    @(posedge clk);
    check_pc(32'h0000_0000);

    // 解除复位并更新任意Next PC
    rst     = 1'b0;
    next_pc = 32'h0000_0100;

    @(posedge clk);
    check_pc(32'h0000_0100);

    $display("[PASS] all PC register tests completed");
    $finish;
end

endmodule