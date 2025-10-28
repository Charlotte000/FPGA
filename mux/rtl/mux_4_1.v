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
// CREATED		"Tue Oct 28 20:16:44 2025"

module mux_4_1(
	data0_i,
	data1_i,
	data2_i,
	data3_i,
	direction_1_i,
	direction_0_i,
	data_o
);


input wire	data0_i;
input wire	data1_i;
input wire	data2_i;
input wire	data3_i;
input wire	direction_1_i;
input wire	direction_0_i;
output wire	data_o;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;




assign	SYNTHESIZED_WIRE_4 = SYNTHESIZED_WIRE_0 & data0_i;

assign	SYNTHESIZED_WIRE_7 = SYNTHESIZED_WIRE_1 & data1_i;

assign	SYNTHESIZED_WIRE_5 = SYNTHESIZED_WIRE_2 & data2_i;

assign	SYNTHESIZED_WIRE_6 = SYNTHESIZED_WIRE_3 & data3_i;


decoder	b2v_inst(
	.data_1_i(direction_1_i),
	.data_0_i(direction_0_i),
	.decoder_0_o(SYNTHESIZED_WIRE_0),
	.decoder_1_o(SYNTHESIZED_WIRE_1),
	.decoder_2_o(SYNTHESIZED_WIRE_2),
	.decoder_3_o(SYNTHESIZED_WIRE_3));

assign	data_o = SYNTHESIZED_WIRE_4 | SYNTHESIZED_WIRE_5 | SYNTHESIZED_WIRE_6 | SYNTHESIZED_WIRE_7;


endmodule
