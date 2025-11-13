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
// CREATED		"Wed Nov 12 15:59:21 2025"

module algorithm(
	new_data_i,
	data_i,
	data_o
);


input wire	new_data_i;
input wire	[15:0] data_i;
output wire	[15:0] data_o;

wire	[15:0] data_o_ALTERA_SYNTHESIZED;




assign	data_o_ALTERA_SYNTHESIZED[1] = data_i[0];


assign	data_o_ALTERA_SYNTHESIZED[11] = data_i[10];


assign	data_o_ALTERA_SYNTHESIZED[12] = data_i[11];


assign	data_o_ALTERA_SYNTHESIZED[13] = data_i[12];


assign	data_o_ALTERA_SYNTHESIZED[14] = data_i[13];


assign	data_o_ALTERA_SYNTHESIZED[3] = data_i[2];


assign	data_o_ALTERA_SYNTHESIZED[4] = data_i[3];


assign	data_o_ALTERA_SYNTHESIZED[5] = data_i[4];


assign	data_o_ALTERA_SYNTHESIZED[6] = data_i[5];


assign	data_o_ALTERA_SYNTHESIZED[7] = data_i[6];


assign	data_o_ALTERA_SYNTHESIZED[8] = data_i[7];


assign	data_o_ALTERA_SYNTHESIZED[9] = data_i[8];


assign	data_o_ALTERA_SYNTHESIZED[10] = data_i[9];


assign	data_o_ALTERA_SYNTHESIZED[0] = data_i[15] ^ new_data_i;

assign	data_o_ALTERA_SYNTHESIZED[2] = data_i[1] ^ data_o_ALTERA_SYNTHESIZED[0];

assign	data_o_ALTERA_SYNTHESIZED[15] = data_i[14] ^ data_o_ALTERA_SYNTHESIZED[0];

assign	data_o = data_o_ALTERA_SYNTHESIZED;

endmodule
