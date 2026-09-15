// RV32I Mini Core - Program Counter Register
// TODO: Define the interface and implement PC state updates.

//                  ┌───────────────┐
//                  │               │
// next_pc ────────→│               │
// clk ────────────→│  PC Register  │────→ pc
// rst ────────────→│               │
//                  └───────────────┘

module pc_reg #(
    parameter [31:0] RESET_VECTOR = 32'h0000_0000
)(
    input wire          clk,
    input wire          rst,
    input wire [31:0]   next_pc,
    output reg [31:0]   pc
);

always @(posedge clk) begin
    if(rst)
        pc <= RESET_VECTOR;//复位(更高优先级)时 存入复位向量
    else
        pc <= next_pc;     //正常情况 存入next_pc
end