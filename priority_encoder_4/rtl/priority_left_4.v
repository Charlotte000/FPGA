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
// CREATED		"Mon Nov  3 12:35:00 2025"

module priority_left_4(
	data_3_i,
	data_2_i,
	data_1_i,
	data_0_i,
	data_val_o,
	data_left_3_o,
	data_left_2_o,
	data_left_1_o,
	data_left_0_o
);


input wire	data_3_i;
input wire	data_2_i;
input wire	data_1_i;
input wire	data_0_i;
output wire	data_val_o;
output wire	data_left_3_o;
output wire	data_left_2_o;
output wire	data_left_1_o;
output wire	data_left_0_o;

wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_10;

assign	data_left_3_o = data_3_i;



assign	data_left_2_o = SYNTHESIZED_WIRE_11 & data_2_i;

assign	data_left_1_o = SYNTHESIZED_WIRE_11 & SYNTHESIZED_WIRE_12 & data_1_i;

assign	data_left_0_o = SYNTHESIZED_WIRE_11 & SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & data_0_i;

assign	SYNTHESIZED_WIRE_11 =  ~data_3_i;

assign	SYNTHESIZED_WIRE_12 =  ~data_2_i;

assign	SYNTHESIZED_WIRE_13 =  ~data_1_i;

assign	SYNTHESIZED_WIRE_10 =  ~data_0_i;

assign	data_val_o =  ~SYNTHESIZED_WIRE_6;

assign	SYNTHESIZED_WIRE_6 = SYNTHESIZED_WIRE_11 & SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_10;


endmodule
