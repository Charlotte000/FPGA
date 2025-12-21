vlib work

vlog -sv ../rtl/dual_ram.sv
vlog -sv ../rtl/bubble_sort.sv
vlog -sv ../rtl/sorting.sv
vlog -sv ./sorting_tb.sv

vsim -novopt sorting_tb
add log -r /*

do wave.do
# add wave -r *

run -all
