add wave                 /lifo_tb/lifo_if/clk
add wave                 /lifo_tb/lifo_if/srst

add wave                 /lifo_tb/lifo_if/rdreq

add wave                 /lifo_tb/lifo_if/wrreq
add wave -radix unsigned /lifo_tb/lifo_if/data

add wave -radix unsigned /lifo_tb/lifo_if/q

add wave                 /lifo_tb/lifo_if/full
add wave                 /lifo_tb/lifo_if/almost_full
add wave                 /lifo_tb/lifo_if/almost_empty
add wave                 /lifo_tb/lifo_if/empty

add wave -radix unsigned /lifo_tb/lifo_if/usedw
