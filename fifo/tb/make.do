vlib work

vlog -sv /opt/fpga/quartus/18.1/modelsim_ase/altera/verilog/src/altera_mf.v
vlog -sv ../rtl/ram.sv
vlog -sv ../rtl/fifo.sv
vlog -sv ./fifo_tb.sv

vsim -novopt fifo_tb
add log -r /*

do wave.do
# add wave -r *

run -all
