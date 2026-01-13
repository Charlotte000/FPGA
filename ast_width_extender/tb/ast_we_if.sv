interface ast_we_if #(
  parameter int unsigned DATA_IN_W,
  parameter int unsigned EMPTY_IN_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DATA_OUT_W,
  parameter int unsigned EMPTY_OUT_W
)(
  input logic clk,
  input logic srst
);

logic [DATA_IN_W-1:0]   snk_data;
logic                   snk_startofpacket;
logic                   snk_endofpacket;
logic                   snk_valid;
logic [EMPTY_IN_W-1:0]  snk_empty;
logic [CHANNEL_W-1:0]   snk_channel;
logic                   snk_ready;

logic [DATA_OUT_W-1:0]  src_data;
logic                   src_startofpacket;
logic                   src_endofpacket;
logic                   src_valid;
logic [EMPTY_OUT_W-1:0] src_empty;
logic [CHANNEL_W-1:0]   src_channel;
logic                   src_ready;

modport tx(
  input  clk,
  input  srst,

  input  snk_ready,

  output snk_data,
  output snk_startofpacket,
  output snk_endofpacket,
  output snk_valid,
  output snk_empty,
  output snk_channel,

  output src_ready
);

modport rx(
  input clk,
  input srst,

  input snk_data,
  input snk_startofpacket,
  input snk_endofpacket,
  input snk_valid,
  input snk_empty,
  input snk_channel,
  input snk_ready,

  input src_data,
  input src_startofpacket,
  input src_endofpacket,
  input src_valid,
  input src_empty,
  input src_channel,
  input src_ready
);

endinterface
