vlib work

vlog -sv ../rtl/lifo.sv
vlog -sv ./lifo_if.sv
vlog -sv ./lifo_generator.sv
vlog -sv ./lifo_monitor.sv
vlog -sv ./lifo_tb.sv

vsim -novopt lifo_tb

add log -r /*
do wave.do
# add wave -r *

run -all
