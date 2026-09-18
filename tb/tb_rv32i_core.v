`timescale 1ns/1ps


//目前指令
//存储在 full_program_test.hex中
//| Byte Address | Assembly           | Machine Code |
//| -----------: | ------------------ | ------------ |
//| `0x00000000` | `addi x1, x0, 5`   | `00500093`   |
//| `0x00000004` | `addi x2, x0, 3`   | `00300113`   |
//| `0x00000008` | `add x3, x1, x2`   | `002081B3`   |
//| `0x0000000C` | `sub x4, x1, x2`   | `40208233`   |
//| `0x00000010` | `and x5, x1, x2`   | `0020F2B3`   |
//| `0x00000014` | `or x6, x1, x2`    | `0020E333`   |
//| `0x00000018` | `xor x7, x1, x2`   | `0020C3B3`   |
//| `0x0000001C` | `sw x3, 0(x0)`     | `00302023`   |
//| `0x00000020` | `lw x8, 0(x0)`     | `00002403`   |
//| `0x00000024` | `addi x10, x0, 1`  | `00100513`   |
//| `0x00000028` | `beq x1, x2, +8`   | `00208463`   |
//| `0x0000002C` | `addi x9, x0, 9`   | `00900493`   |
//| `0x00000030` | `beq x3, x8, +8`   | `00818463`   |
//| `0x00000034` | `addi x10, x0, 10` | `00A00513`   |
//| `0x00000038` | `addi x11, x0, 11` | `00B00593`   |

module tb_rv32i_core;

reg clk;
reg rst;

rv32i_core #(
    .IMEM_ADDR_WIDTH (8),
    .DMEM_ADDR_WIDTH (8),
    .IMEM_FILE       ("programs/full_program_test.hex")
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

    #200;

    $finish;
end

endmodule