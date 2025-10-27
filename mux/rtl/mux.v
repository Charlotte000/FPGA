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
// CREATED		"Mon Oct 27 18:26:33 2025"

module mux(
	direction_1,
	direction_0,
	data0_1,
	data1_1,
	data3_1,
	data2_1,
	data0_0,
	data1_0,
	data2_0,
	data3_0,
	data_o_1,
	data_o_0
);


input wire	direction_1;
input wire	direction_0;
input wire	data0_1;
input wire	data1_1;
input wire	data3_1;
input wire	data2_1;
input wire	data0_0;
input wire	data1_0;
input wire	data2_0;
input wire	data3_0;
output wire	data_o_1;
output wire	data_o_0;

wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_25;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_19;




assign	SYNTHESIZED_WIRE_22 = SYNTHESIZED_WIRE_20 & SYNTHESIZED_WIRE_21;

assign	SYNTHESIZED_WIRE_23 = direction_0 & SYNTHESIZED_WIRE_21;

assign	SYNTHESIZED_WIRE_24 = SYNTHESIZED_WIRE_20 & direction_1;

assign	SYNTHESIZED_WIRE_25 = direction_0 & direction_1;

assign	SYNTHESIZED_WIRE_12 = SYNTHESIZED_WIRE_22 & data0_0;

assign	SYNTHESIZED_WIRE_16 = SYNTHESIZED_WIRE_22 & data0_1;

assign	SYNTHESIZED_WIRE_15 = SYNTHESIZED_WIRE_23 & data1_0;

assign	SYNTHESIZED_WIRE_19 = SYNTHESIZED_WIRE_23 & data1_1;

assign	SYNTHESIZED_WIRE_13 = SYNTHESIZED_WIRE_24 & data2_0;

assign	SYNTHESIZED_WIRE_17 = SYNTHESIZED_WIRE_24 & data2_1;

assign	SYNTHESIZED_WIRE_14 = SYNTHESIZED_WIRE_25 & data3_0;

assign	SYNTHESIZED_WIRE_18 = SYNTHESIZED_WIRE_25 & data3_1;

assign	SYNTHESIZED_WIRE_20 =  ~direction_0;

assign	SYNTHESIZED_WIRE_21 =  ~direction_1;

assign	data_o_0 = SYNTHESIZED_WIRE_12 | SYNTHESIZED_WIRE_13 | SYNTHESIZED_WIRE_14 | SYNTHESIZED_WIRE_15;

assign	data_o_1 = SYNTHESIZED_WIRE_16 | SYNTHESIZED_WIRE_17 | SYNTHESIZED_WIRE_18 | SYNTHESIZED_WIRE_19;


endmodule
