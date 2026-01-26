add wave                                /byte_inc_tb/clk
add wave                                /byte_inc_tb/srst

add wave -group Setting -radix unsigned /byte_inc_tb/set_if/base_addr
add wave -group Setting -radix unsigned /byte_inc_tb/set_if/length
add wave -group Setting                 /byte_inc_tb/set_if/run
add wave -group Setting                 /byte_inc_tb/set_if/waitrequest

add wave -group Reader  -radix unsigned /byte_inc_tb/rd_if/address
add wave -group Reader                  /byte_inc_tb/rd_if/read
add wave -group Reader  -radix hex      /byte_inc_tb/rd_if/data
add wave -group Reader                  /byte_inc_tb/rd_if/datavalid
add wave -group Reader                  /byte_inc_tb/rd_if/waitrequest

add wave -group Writer  -radix unsigned /byte_inc_tb/wr_if/address
add wave -group Writer                  /byte_inc_tb/wr_if/write
add wave -group Writer  -radix hex      /byte_inc_tb/wr_if/data
add wave -group Writer  -radix unsigned /byte_inc_tb/wr_if/byteenable
add wave -group Writer                  /byte_inc_tb/wr_if/waitrequest
