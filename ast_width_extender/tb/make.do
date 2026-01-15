vlib work

vlog -sv ../rtl/ast_width_extender.sv
vlog -sv ./ast_if.sv
vlog -sv ./ast_we_tb.sv

vsim -novopt ast_we_tb

add log -r /*
do wave.do
# add wave -r *

run -all
