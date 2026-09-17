add wave -divider {Clock and Fetch}
add wave sim:/tb_rv32i_core/clk
add wave sim:/tb_rv32i_core/rst
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/pc
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/instruction
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/next_pc

add wave -divider {Instruction Fields}
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/opcode
add wave -radix unsigned sim:/tb_rv32i_core/dut/rs1
add wave -radix unsigned sim:/tb_rv32i_core/dut/rs2
add wave -radix unsigned sim:/tb_rv32i_core/dut/rd
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/immediate

add wave -divider {Register File and ALU}
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/read_data1
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/read_data2
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/alu_operand_b
add wave -radix binary sim:/tb_rv32i_core/dut/alu_control
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/alu_result
add wave sim:/tb_rv32i_core/dut/zero

add wave -divider {Memory and Write Back}
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/memory_read_data
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/write_back_data
add wave sim:/tb_rv32i_core/dut/reg_write_enable
add wave sim:/tb_rv32i_core/dut/mem_write_enable

add wave -divider {MUX and Branch Control}
add wave sim:/tb_rv32i_core/dut/alu_src
add wave sim:/tb_rv32i_core/dut/result_src
add wave sim:/tb_rv32i_core/dut/branch
add wave sim:/tb_rv32i_core/dut/pc_src
add wave -radix hexadecimal sim:/tb_rv32i_core/dut/branch_target