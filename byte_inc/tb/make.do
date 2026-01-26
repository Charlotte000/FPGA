vlib work

vlog -sv ../rtl/byte_inc.sv

vlog -sv ./amm/amm_if.sv
vlog -sv ./amm/amm_package.sv

vlog -sv ./byte_inc/byte_inc_if.sv
vlog -sv ./byte_inc_package.sv

vlog -sv ./byte_inc_tb.sv

vsim -novopt -suppress 3839 byte_inc_tb

add log -r /*
do wave.do
# add wave -r *

run -all
