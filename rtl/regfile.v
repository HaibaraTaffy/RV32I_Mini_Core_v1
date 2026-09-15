// RV32I Mini Core - Integer Register File

//read_addr1 = rs1 = Register Index
//read_addr2 = rs2 = Register Index
//write_addr = rd  = Destination Register Index.
//read_data1 = RF[read_addr1]
//read_data2 = RF[read_addr2]

//组合读取 时钟沿写入
//x0 特殊 读取返回0 写入被忽略
//先不管复位

module regfile(
    input   wire       clk,
    input   wire       write_enable,
    input   wire [4:0] read_addr1,
    input   wire [4:0] read_addr2, 
    input   wire [4:0] write_addr,
    input   wire [31:0] write_data,

    output   wire [31:0] read_data1, 
    output   wire [31:0] read_data2 
);

reg [31:0] registers [0:31];
//[31:0] 每一个Register 宽32bit
//[0:31] 一共32个Register

assign read_data1 =
    (read_addr1 == 5'd0) ? 32'b0 : registers[read_addr1];

assign read_data2 =
    (read_addr2 == 5'd0) ? 32'b0 : registers[read_addr2];

always @(posedge clk) begin
    if(write_enable && (write_addr != 5'd0))
        registers[write_addr] <= write_data;
end

endmodule

