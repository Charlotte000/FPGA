vlib work

vlog -sv ../rtl/decoder.v
vlog -sv ../rtl/mux_4_1.v
vlog -sv ../rtl/mux.v
vlog -sv mux_tb.sv

vsim -novopt mux_tb
add log -r /*
add wave -r *
run -all
