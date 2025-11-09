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
// CREATED		"Sun Nov  9 16:09:15 2025"

module mux_16_1(
	data_i,
	sel_i,
	data_o
);


input wire	[15:0] data_i;
input wire	[3:0] sel_i;
output wire	data_o;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;





mux_4_1	b2v_mux_0(
	.direction_1_i(sel_i[1]),
	.direction_0_i(sel_i[0]),
	.data0_i(data_i[0]),
	.data1_i(data_i[1]),
	.data2_i(data_i[2]),
	.data3_i(data_i[3]),
	.data_o(SYNTHESIZED_WIRE_0));


mux_4_1	b2v_mux_1(
	.direction_1_i(sel_i[1]),
	.direction_0_i(sel_i[0]),
	.data0_i(data_i[4]),
	.data1_i(data_i[5]),
	.data2_i(data_i[6]),
	.data3_i(data_i[7]),
	.data_o(SYNTHESIZED_WIRE_1));


mux_4_1	b2v_mux_2(
	.direction_1_i(sel_i[1]),
	.direction_0_i(sel_i[0]),
	.data0_i(data_i[8]),
	.data1_i(data_i[9]),
	.data2_i(data_i[10]),
	.data3_i(data_i[11]),
	.data_o(SYNTHESIZED_WIRE_2));


mux_4_1	b2v_mux_3(
	.direction_1_i(sel_i[1]),
	.direction_0_i(sel_i[0]),
	.data0_i(data_i[12]),
	.data1_i(data_i[13]),
	.data2_i(data_i[14]),
	.data3_i(data_i[15]),
	.data_o(SYNTHESIZED_WIRE_3));


mux_4_1	b2v_mux_4(
	.direction_1_i(sel_i[3]),
	.direction_0_i(sel_i[2]),
	.data0_i(SYNTHESIZED_WIRE_0),
	.data1_i(SYNTHESIZED_WIRE_1),
	.data2_i(SYNTHESIZED_WIRE_2),
	.data3_i(SYNTHESIZED_WIRE_3),
	.data_o(data_o));


endmodule
