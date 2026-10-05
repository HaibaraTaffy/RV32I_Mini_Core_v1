// Created by HaibaraTaffy
// RV32I Mini Core v3 - EX/MEM Pipeline Register

module ex_mem_reg(
    input wire         clk,
    input wire         rst,
    input wire         enable,
    input wire         clear,

    input wire         valid_in,
    input wire [31:0]  alu_result_in,
    input wire [31:0]  store_data_in,
    input wire [31:0]  pc_plus4_in,
    input wire [4:0]   rd_in,

    input wire         reg_write_in,
    input wire         mem_write_in,
    input wire [1:0]   result_src_in,

    output reg         valid_out,
    output reg [31:0]  alu_result_out,
    output reg [31:0]  store_data_out,
    output reg [31:0]  pc_plus4_out,
    output reg [4:0]   rd_out,

    output reg         reg_write_out,
    output reg         mem_write_out,
    output reg [1:0]   result_src_out
);

always @(posedge clk) begin
    if (rst) begin
        valid_out      <= 1'b0;
        alu_result_out <= 32'b0;
        store_data_out <= 32'b0;
        pc_plus4_out   <= 32'b0;
        rd_out         <= 5'b0;
        reg_write_out  <= 1'b0;
        mem_write_out  <= 1'b0;
        result_src_out <= 2'b0;
    end
    else if (clear) begin
        valid_out      <= 1'b0;
        alu_result_out <= 32'b0;
        store_data_out <= 32'b0;
        pc_plus4_out   <= 32'b0;
        rd_out         <= 5'b0;
        reg_write_out  <= 1'b0;
        mem_write_out  <= 1'b0;
        result_src_out <= 2'b0;
    end
    else if (enable) begin
        valid_out      <= valid_in;
        alu_result_out <= alu_result_in;
        store_data_out <= store_data_in;
        pc_plus4_out   <= pc_plus4_in;
        rd_out         <= rd_in;
        reg_write_out  <= reg_write_in;
        mem_write_out  <= mem_write_in;
        result_src_out <= result_src_in;
    end
end

endmodule