vlib work

vlog -sv ../rtl/priority_left_4.v
vlog -sv ../rtl/priority_encoder_4.v
vlog -sv priority_encoder_4_tb.sv

vsim -novopt priority_encoder_4_tb
add log -r /*
add wave -r *
run -all
