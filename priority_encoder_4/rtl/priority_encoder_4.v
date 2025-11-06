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
// CREATED		"Wed Nov  5 14:33:00 2025"

module priority_encoder_4(
	data_0_i,
	data_1_i,
	data_2_i,
	data_3_i,
	data_val_i,
	data_left_0_o,
	data_left_1_o,
	data_left_2_o,
	data_left_3_o,
	data_right_0_o,
	data_right_1_o,
	data_right_2_o,
	data_right_3_o,
	data_val_o
);


input wire	data_0_i;
input wire	data_1_i;
input wire	data_2_i;
input wire	data_3_i;
input wire	data_val_i;
output wire	data_left_0_o;
output wire	data_left_1_o;
output wire	data_left_2_o;
output wire	data_left_3_o;
output wire	data_right_0_o;
output wire	data_right_1_o;
output wire	data_right_2_o;
output wire	data_right_3_o;
output wire	data_val_o;


assign	data_val_o = data_val_i;




priority_left_4	b2v_left(
	.data_3_i(data_3_i),
	.data_2_i(data_2_i),
	.data_1_i(data_1_i),
	.data_0_i(data_0_i),
	.data_left_3_o(data_left_3_o),
	.data_left_2_o(data_left_2_o),
	.data_left_1_o(data_left_1_o),
	.data_left_0_o(data_left_0_o));


priority_left_4	b2v_right(
	.data_3_i(data_0_i),
	.data_2_i(data_1_i),
	.data_1_i(data_2_i),
	.data_0_i(data_3_i),
	.data_left_3_o(data_right_0_o),
	.data_left_2_o(data_right_1_o),
	.data_left_1_o(data_right_2_o),
	.data_left_0_o(data_right_3_o));


endmodule
