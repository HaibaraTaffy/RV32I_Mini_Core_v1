// Created by HaibaraTaffy
// RV32I Mini Core - data memory

//第一版 主要服务 lw sw
//采用 组合读取 时钟沿写入

//和Instruction Memory类似
//存在 wordindex = byteaddress / 4
//ADDR_WIDTH = 8
//容量       = 256 × 32 bit
//总容量     = 1 KiB

module data_memory #(
    parameter integer ADDR_WIDTH = 8
)(
    input  wire        clk,
    input  wire        write_enable,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

localparam integer DEPTH = (1 << ADDR_WIDTH);

reg [31:0] memory [0:DEPTH-1];

wire [ADDR_WIDTH-1:0] word_index;

integer i;

assign word_index = address[ADDR_WIDTH+1:2];
//以上都可以参考 Instruction Memory

//组合读
assign read_data = memory[word_index];

//时序写 时钟上升沿和写信号有效时 才写入
always @(posedge clk) begin
    if (write_enable)
        memory[word_index] <= write_data;
end

//初始化
initial begin
    for (i = 0; i < DEPTH; i = i + 1)
        memory[i] = 32'b0;
end


endmodule