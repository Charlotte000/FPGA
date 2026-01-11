add wave                            /ast_we_tb/ast_we_if/clk
add wave                            /ast_we_tb/ast_we_if/srst

add wave -group SNK -radix unsigned /ast_we_tb/ast_we_if/snk_data
add wave -group SNK                 /ast_we_tb/ast_we_if/snk_startofpacket
add wave -group SNK                 /ast_we_tb/ast_we_if/snk_endofpacket
add wave -group SNK                 /ast_we_tb/ast_we_if/snk_valid
add wave -group SNK -radix unsigned /ast_we_tb/ast_we_if/snk_empty
add wave -group SNK -radix unsigned /ast_we_tb/ast_we_if/snk_channel
add wave -group SNK                 /ast_we_tb/ast_we_if/snk_ready

add wave -group SRC -radix unsigned /ast_we_tb/ast_we_if/src_data
add wave -group SRC                 /ast_we_tb/ast_we_if/src_startofpacket
add wave -group SRC                 /ast_we_tb/ast_we_if/src_endofpacket
add wave -group SRC                 /ast_we_tb/ast_we_if/src_valid
add wave -group SRC -radix unsigned /ast_we_tb/ast_we_if/src_empty
add wave -group SRC -radix unsigned /ast_we_tb/ast_we_if/src_channel
add wave -group SRC                 /ast_we_tb/ast_we_if/src_ready