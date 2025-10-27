vlib work

vlog -sv ../rtl/mux.v
vlog -sv mux_tb.sv

vsim -novopt mux_tb
add log -r /*
add wave -r *
run -all
