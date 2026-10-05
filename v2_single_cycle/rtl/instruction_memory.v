// Created by HaibaraTaffy
// RV32I Mini Core - Instruction Memory

//负责根据 PC 提供的 Instruction Address 输出对应的32-bit Instruction

//一条基础 RV32I Instruction 指令为4字节 于是PC地址按4递增
//但是Verilog中 Memory Array 按元素编号访问:
//于是转换 WordIndex = ByteAddress / 4
//在二进制中 相当于丢弃最低2bit 

//例如 : 0x0000_0000 -> 0
//      0x0000_0004 -> 1

//第一版 ADDR_WIDTH = 8 
//容量2^8 = 256 条指令 = 256*4B = 1024 Byte = 1kiB

// 参数化思想
module instruction_memory #(
    parameter integer ADDR_WIDTH = 8,
    parameter         MEM_FILE   = "programs/imem_test.hex"
)(
    input  wire [31:0] address,
    output wire [31:0] instruction
);

localparam integer DEPTH = (1 << ADDR_WIDTH);//2^8 = 256

reg [31:0] memory [0:DEPTH-1];

wire [ADDR_WIDTH-1:0] word_index;

integer i;
// 1 KiB空间的Byte Address范围为0x0000_0000～0x0000_03FF (1024B - > 2^10 B -> 
//00_0000_0000 ~ 11_1111_1111 一共1024B)
// 32-bit Instruction按4 Byte对齐，最后一个起始地址为0x0000_03FC
// 第一版假设输入地址始终位于该范围内并且正确对齐
assign word_index = address[ADDR_WIDTH+1:2];
//由序号取出指令
assign instruction = memory[word_index];

initial begin
    for (i = 0; i < DEPTH; i = i + 1)
        memory[i] = 32'h0000_0013;//先初始化
    //再读文件
    $readmemh(MEM_FILE, memory);
end

endmodule