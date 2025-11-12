vlib work

vlog -sv ../../mux/rtl/decoder.v
vlog -sv ../../mux/rtl/mux_4_1.v
vlog -sv ../rtl/mux_16_1.v
vlog -sv ../rtl/queue_15.v
vlog -sv ../rtl/delay_15.v
vlog -sv delay_15_tb.sv

vsim -novopt delay_15_tb
add log -r /*

do wave.do

run -all
