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
// CREATED		"Wed Nov 12 16:00:25 2025"

module dff_16(
	clk_i,
	rst_i,
	data_i,
	data_o
);


input wire	clk_i;
input wire	rst_i;
input wire	[15:0] data_i;
output wire	[15:0] data_o;

reg	[15:0] data_o_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_16;





always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[0] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[0] <= data_i[0];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[1] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[1] <= data_i[1];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[10] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[10] <= data_i[10];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[11] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[11] <= data_i[11];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[12] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[12] <= data_i[12];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[13] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[13] <= data_i[13];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[14] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[14] <= data_i[14];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[15] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[15] <= data_i[15];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[2] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[2] <= data_i[2];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[3] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[3] <= data_i[3];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[4] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[4] <= data_i[4];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[5] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[5] <= data_i[5];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[6] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[6] <= data_i[6];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[7] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[7] <= data_i[7];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[8] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[8] <= data_i[8];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_16)
begin
if (!SYNTHESIZED_WIRE_16)
	begin
	data_o_ALTERA_SYNTHESIZED[9] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[9] <= data_i[9];
	end
end

assign	SYNTHESIZED_WIRE_16 =  ~rst_i;

assign	data_o = data_o_ALTERA_SYNTHESIZED;

endmodule
