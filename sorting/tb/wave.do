add wave                            /sorting_tb/clk
add wave                            /sorting_tb/srst
add wave -group SNK -radix unsigned /sorting_tb/snk_data
add wave -group SNK                 /sorting_tb/snk_startofpacket
add wave -group SNK                 /sorting_tb/snk_endofpacket
add wave -group SNK                 /sorting_tb/snk_valid
add wave -group SNK                 /sorting_tb/snk_ready
add wave -group SRC -radix unsigned /sorting_tb/src_data
add wave -group SRC                 /sorting_tb/src_startofpacket
add wave -group SRC                 /sorting_tb/src_endofpacket
add wave -group SRC                 /sorting_tb/src_valid
add wave -group SRC                 /sorting_tb/src_ready
