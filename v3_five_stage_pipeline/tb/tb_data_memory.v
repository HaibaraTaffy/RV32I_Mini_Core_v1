`timescale 1ns/1ps

module tb_data_memory;

reg         clk;
reg         write_enable;
reg  [31:0] address;
reg  [31:0] write_data;
wire [31:0] read_data;

data_memory #(
    .ADDR_WIDTH(8)
) dut (
    .clk          (clk),
    .write_enable (write_enable),
    .address      (address),
    .write_data   (write_data),
    .read_data    (read_data)
);

always #5 clk = ~clk;//100Mhz时钟
//读出是一直读出 不受write_enable 控制
//写入受write_enable 控制 在上升沿写入
initial begin
    clk          = 1'b0;
    write_enable = 1'b0;
    address      = 32'h0000_0000;
    write_data   = 32'b0;
    #10;//初始化

    write_enable = 1'b1;
    address      = 32'h0000_0000;
    write_data   = 32'h1111_1111;
    #10;//测试写入 上升沿时 写入存储器 同时读出也更新

    write_enable = 1'b0;
    #10;//测试读出 应该 read_data = 1111_1111

    write_enable = 1'b1;
    address      = 32'h0000_0004;
    write_data   = 32'h2222_2222;
    #10;//再写入 地址变了 上升沿时读出2222_2222

    write_enable = 1'b0;
    address      = 32'h0000_0000;
    #10;//应该还读出 read_data = 1111_1111

    address = 32'h0000_0004;
    #10;//此时读出 read_data = 2222_2222

    write_enable = 1'b0;
    address      = 32'h0000_0000;
    write_data   = 32'hDEAD_BEEF;
    #10;//应该无法写入 读出 read_data = 1111_1111

    write_enable = 1'b1;
    address      = 32'h0000_0000;
    write_data   = 32'h1234_5678;
    #10;//重新写入 上升沿时 读出 read_data = 1234_5678

    write_enable = 1'b0;
    #10;//读出 read_data = 1234_5678

    $finish;
    //仿真成功 符合预期
end

endmodule