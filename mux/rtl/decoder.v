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
// CREATED		"Tue Oct 28 20:17:02 2025"

module decoder(
	data_1_i,
	data_0_i,
	decoder_0_o,
	decoder_1_o,
	decoder_2_o,
	decoder_3_o
);


input wire	data_1_i;
input wire	data_0_i;
output wire	decoder_0_o;
output wire	decoder_1_o;
output wire	decoder_2_o;
output wire	decoder_3_o;

wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;




assign	decoder_0_o = SYNTHESIZED_WIRE_4 & SYNTHESIZED_WIRE_5;

assign	decoder_1_o = data_0_i & SYNTHESIZED_WIRE_5;

assign	decoder_2_o = SYNTHESIZED_WIRE_4 & data_1_i;

assign	decoder_3_o = data_0_i & data_1_i;

assign	SYNTHESIZED_WIRE_4 =  ~data_0_i;

assign	SYNTHESIZED_WIRE_5 =  ~data_1_i;


endmodule
