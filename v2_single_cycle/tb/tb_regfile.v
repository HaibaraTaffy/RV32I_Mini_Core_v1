`timescale 1ns/1ps


module tb_regfile;

reg         clk;
reg         write_enable;
reg  [4:0]  read_addr1;
reg  [4:0]  read_addr2;
reg  [4:0]  write_addr;
reg  [31:0] write_data;
wire [31:0] read_data1;
wire [31:0] read_data2;

regfile dut (
    .clk          (clk),
    .write_enable (write_enable),
    .read_addr1   (read_addr1),
    .read_addr2   (read_addr2),
    .write_addr   (write_addr),
    .write_data   (write_data),
    .read_data1   (read_data1),
    .read_data2   (read_data2)
);

always #5 clk = ~clk;

initial begin
    clk          = 1'b0;
    write_enable = 1'b0;
    read_addr1   = 5'd0;
    read_addr2   = 5'd0;
    write_addr   = 5'd0;
    write_data   = 32'b0;
    #10;

    write_enable = 1'b1;
    write_addr   = 5'd1;
    write_data   = 32'h1111_1111;
    #10;

    write_addr   = 5'd2;
    write_data   = 32'h2222_2222;
    #10;

    write_enable = 1'b0;
    read_addr1   = 5'd1;
    read_addr2   = 5'd2;
    #10;

    write_enable = 1'b1;
    write_addr   = 5'd0;
    write_data   = 32'hDEAD_BEEF;
    #10;

    write_enable = 1'b0;
    read_addr1   = 5'd0;
    read_addr2   = 5'd1;
    #10;

    write_enable = 1'b1;
    write_addr   = 5'd1;
    write_data   = 32'h1234_5678;
    read_addr1   = 5'd1;
    read_addr2   = 5'd2;
    #10;

    write_enable = 1'b0;
    #10;

    write_enable = 1'b0;
    write_addr   = 5'd2;
    write_data   = 32'hDEAD_BEEF;
    read_addr1   = 5'd2;
    #10;

    $finish;
end

endmodule

