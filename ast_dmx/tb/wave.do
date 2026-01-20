add wave                            /ast_dmx_tb/clk
add wave                            /ast_dmx_tb/srst

add wave -group SRC -radix unsigned /ast_dmx_tb/src_dir_if/dir
add wave -group SRC -radix hex      /ast_dmx_tb/src_if/data
add wave -group SRC                 /ast_dmx_tb/src_if/startofpacket
add wave -group SRC                 /ast_dmx_tb/src_if/endofpacket
add wave -group SRC                 /ast_dmx_tb/src_if/valid
add wave -group SRC -radix unsigned /ast_dmx_tb/src_if/empty
add wave -group SRC -radix unsigned /ast_dmx_tb/src_if/channel
add wave -group SRC                 /ast_dmx_tb/src_if/ready

add wave -group SNK -radix hex      /ast_dmx_tb/snk_data
add wave -group SNK                 /ast_dmx_tb/snk_startofpacket
add wave -group SNK                 /ast_dmx_tb/snk_endofpacket
add wave -group SNK                 /ast_dmx_tb/snk_valid
add wave -group SNK -radix unsigned /ast_dmx_tb/snk_empty
add wave -group SNK -radix unsigned /ast_dmx_tb/snk_channel
add wave -group SNK                 /ast_dmx_tb/snk_ready
