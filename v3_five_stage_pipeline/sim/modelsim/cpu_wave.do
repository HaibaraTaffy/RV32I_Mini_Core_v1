add wave -divider {Clock and Reset}
add wave sim:/tb_rv32i_pipeline_core/clk
add wave sim:/tb_rv32i_pipeline_core/rst

add wave -divider {IF Stage}
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/pc_f
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/instruction_f
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/pc_plus4_f

add wave -divider {ID Stage}
add wave sim:/tb_rv32i_pipeline_core/dut/valid_d
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/pc_d
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/instruction_d
add wave -radix unsigned sim:/tb_rv32i_pipeline_core/dut/rs1_d
add wave -radix unsigned sim:/tb_rv32i_pipeline_core/dut/rs2_d
add wave -radix unsigned sim:/tb_rv32i_pipeline_core/dut/rd_d
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/immediate_d
add wave sim:/tb_rv32i_pipeline_core/dut/reg_write_d
add wave sim:/tb_rv32i_pipeline_core/dut/alu_src_d
add wave -radix binary sim:/tb_rv32i_pipeline_core/dut/result_src_d

add wave -divider {EX Stage}
add wave sim:/tb_rv32i_pipeline_core/dut/valid_e
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/pc_e
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/read_data1_e
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/read_data2_e
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/immediate_e
add wave -radix unsigned sim:/tb_rv32i_pipeline_core/dut/rd_e
add wave -radix binary sim:/tb_rv32i_pipeline_core/dut/alu_control_e
add wave sim:/tb_rv32i_pipeline_core/dut/alu_src_e
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/alu_operand_b_e
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/alu_result_e

add wave -divider {MEM Stage}
add wave sim:/tb_rv32i_pipeline_core/dut/valid_m
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/alu_result_m
add wave -radix unsigned sim:/tb_rv32i_pipeline_core/dut/rd_m
add wave sim:/tb_rv32i_pipeline_core/dut/reg_write_m
add wave sim:/tb_rv32i_pipeline_core/dut/mem_write_m
add wave -radix binary sim:/tb_rv32i_pipeline_core/dut/result_src_m

add wave -divider {WB Stage}
add wave sim:/tb_rv32i_pipeline_core/dut/valid_w
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/alu_result_w
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/memory_read_data_w
add wave -radix unsigned sim:/tb_rv32i_pipeline_core/dut/rd_w
add wave sim:/tb_rv32i_pipeline_core/dut/reg_write_w
add wave sim:/tb_rv32i_pipeline_core/dut/reg_write_enable_w
add wave -radix binary sim:/tb_rv32i_pipeline_core/dut/result_src_w
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/write_back_data_w

add wave -divider {Register File}
add wave -radix hexadecimal sim:/tb_rv32i_pipeline_core/dut/u_regfile/registers