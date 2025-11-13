vlib work

vlog -sv ../rtl/algorithm.v
vlog -sv ../rtl/dff_16.v
vlog -sv ../rtl/crc_16_ansi.v
vlog -sv crc_16_ansi_tb.sv

vsim -novopt crc_16_ansi_tb
add log -r /*

do wave.do

run -all
