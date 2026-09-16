`timescale 1ns/1ps

module tb_instruction_memory;

reg  [31:0] address;
wire [31:0] instruction;

instruction_memory #(
    .ADDR_WIDTH (8),
    .MEM_FILE   ("programs/imem_test.hex")
) dut (
    .address     (address),
    .instruction (instruction)
);

initial begin
    address = 32'h0000_0000;
    #10;
    //输出 00500093
    address = 32'h0000_0004;
    #10;
    //输出 00700113
    address = 32'h0000_0008;
    #10;
    //输出 002081B3
    address = 32'h0000_000C;
    #10;
    //输出 40208233
    address = 32'h0000_0010;
    #10;
    //仿真完毕 全部正确
    $finish;
end

endmodule