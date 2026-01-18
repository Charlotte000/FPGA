vlib work

vlog -sv ../rtl/ast_dmx.sv
vlog -sv ./ast_dmx_if.sv
vlog -sv ./ast_dmx_dir_if.sv
vlog -sv ./ast_dmx_package.sv
vlog -sv ./ast_dmx_tb.sv

vsim -novopt -suppress 3839 -suppress 3838 ast_dmx_tb

add log -r /*
do wave.do
# add wave -r *

run -all
