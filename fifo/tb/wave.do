add wave -group input                 /fifo_tb/clk
add wave -group input                 /fifo_tb/srst
add wave -group input -radix unsigned /fifo_tb/data
add wave -group input                 /fifo_tb/wrreq
add wave -group input                 /fifo_tb/rdreq

add wave -group DUT   -radix unsigned /fifo_tb/q_dut
add wave -group DUT   -radix unsigned /fifo_tb/usedw_dut
add wave -group DUT                   /fifo_tb/empty_dut
add wave -group DUT                   /fifo_tb/full_dut
add wave -group DUT                   /fifo_tb/almost_full_dut
add wave -group DUT                   /fifo_tb/almost_empty_dut

add wave -group REF   -radix unsigned /fifo_tb/q_golden
add wave -group REF   -radix unsigned /fifo_tb/usedw_golden
add wave -group REF                   /fifo_tb/empty_golden
add wave -group REF                   /fifo_tb/full_golden
add wave -group REF                   /fifo_tb/almost_full_golden
add wave -group REF                   /fifo_tb/almost_empty_golden
