vlib work

vlog -sv ../rtl/definitions_pkg.sv
vlog -sv ../rtl/traffic_lights.sv
vlog -sv traffic_lights_tb.sv

vsim -novopt traffic_lights_tb
add log -r /*

do wave.do
# add wave -r *

run -all
