vlib work

vlog -sv ../rtl/deserializer.sv
vlog -sv deserializer_tb.sv

vsim -novopt deserializer_tb
add log -r /*

do wave.do

run -all
