vlib work

vlog -sv ../rtl/byte_inc.sv

vlog -sv ./amm/rd/amm_rd_if.sv
vlog -sv ./amm/wr/amm_wr_if.sv
vlog -sv ./amm/amm_package.sv

vlog -sv ./byte_inc/byte_inc_if.sv
vlog -sv ./byte_inc_package.sv

vlog -sv ./byte_inc_tb.sv

vsim -novopt byte_inc_tb
# vsim -novopt byte_inc_tb

add log -r /*
do wave.do
# add wave -r *

run -all
