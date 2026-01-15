add wave                            /ast_we_tb/clk
add wave                            /ast_we_tb/srst

add wave -group SRC -radix unsigned /ast_we_tb/src_if/data
add wave -group SRC                 /ast_we_tb/src_if/startofpacket
add wave -group SRC                 /ast_we_tb/src_if/endofpacket
add wave -group SRC                 /ast_we_tb/src_if/valid
add wave -group SRC -radix unsigned /ast_we_tb/src_if/empty
add wave -group SRC -radix unsigned /ast_we_tb/src_if/channel
add wave -group SRC                 /ast_we_tb/src_if/ready

add wave -group SNK -radix unsigned /ast_we_tb/snk_if/data
add wave -group SNK                 /ast_we_tb/snk_if/startofpacket
add wave -group SNK                 /ast_we_tb/snk_if/endofpacket
add wave -group SNK                 /ast_we_tb/snk_if/valid
add wave -group SNK -radix unsigned /ast_we_tb/snk_if/empty
add wave -group SNK -radix unsigned /ast_we_tb/snk_if/channel
add wave -group SNK                 /ast_we_tb/snk_if/ready