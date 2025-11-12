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
// CREATED		"Tue Nov 11 17:47:08 2025"

module queue_15(
	data_i,
	clk_i,
	rst_i,
	data_o
);


input wire	data_i;
input wire	clk_i;
input wire	rst_i;
output wire	[15:0] data_o;

reg	[15:0] data_o_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_15;





always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[1] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[1] <= data_o_ALTERA_SYNTHESIZED[0];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[10] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[10] <= data_o_ALTERA_SYNTHESIZED[9];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[11] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[11] <= data_o_ALTERA_SYNTHESIZED[10];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[12] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[12] <= data_o_ALTERA_SYNTHESIZED[11];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[13] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[13] <= data_o_ALTERA_SYNTHESIZED[12];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[14] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[14] <= data_o_ALTERA_SYNTHESIZED[13];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[15] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[15] <= data_o_ALTERA_SYNTHESIZED[14];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[2] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[2] <= data_o_ALTERA_SYNTHESIZED[1];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[3] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[3] <= data_o_ALTERA_SYNTHESIZED[2];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[4] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[4] <= data_o_ALTERA_SYNTHESIZED[3];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[5] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[5] <= data_o_ALTERA_SYNTHESIZED[4];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[6] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[6] <= data_o_ALTERA_SYNTHESIZED[5];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[7] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[7] <= data_o_ALTERA_SYNTHESIZED[6];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[8] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[8] <= data_o_ALTERA_SYNTHESIZED[7];
	end
end


always@(posedge clk_i or negedge SYNTHESIZED_WIRE_15)
begin
if (!SYNTHESIZED_WIRE_15)
	begin
	data_o_ALTERA_SYNTHESIZED[9] <= 0;
	end
else
	begin
	data_o_ALTERA_SYNTHESIZED[9] <= data_o_ALTERA_SYNTHESIZED[8];
	end
end

assign	SYNTHESIZED_WIRE_15 =  ~rst_i;

assign	data_o = data_o_ALTERA_SYNTHESIZED;
assign	data_o_ALTERA_SYNTHESIZED[0] = data_i;

endmodule
