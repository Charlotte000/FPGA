// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Wed Nov 12 16:00:10 2025"

module crc_16_ansi(
	clk_i,
	rst_i,
	data_i,
	data_o
);


input wire	clk_i;
input wire	rst_i;
input wire	data_i;
output wire	[15:0] data_o;

wire	[15:0] SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;

assign	data_o = SYNTHESIZED_WIRE_0;




dff_16	b2v_dff_16(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i(SYNTHESIZED_WIRE_0),
	.data_o(SYNTHESIZED_WIRE_1));


algorithm	b2v_inst(
	.new_data_i(data_i),
	.data_i(SYNTHESIZED_WIRE_1),
	.data_o(SYNTHESIZED_WIRE_0));


endmodule
