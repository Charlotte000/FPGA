// Copyright (C) 2025  Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Altera and sold by Altera or its authorized distributors.  Please
// refer to the Altera Software License Subscription Agreements 
// on the Quartus Prime software download page.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"
// CREATED		"Tue Nov 11 17:47:39 2025"

module delay_15(
	clk_i,
	rst_i,
	data_i,
	data_delay_i,
	data_o
);


input wire	clk_i;
input wire	rst_i;
input wire	data_i;
input wire	[3:0] data_delay_i;
output wire	data_o;

wire	[15:0] SYNTHESIZED_WIRE_0;





mux_16_1	b2v_mux(
	.data_i(SYNTHESIZED_WIRE_0),
	.sel_i(data_delay_i),
	.data_o(data_o));


queue_15	b2v_queue(
	.data_i(data_i),
	.rst_i(rst_i),
	.clk_i(clk_i),
	.data_o(SYNTHESIZED_WIRE_0));


endmodule
