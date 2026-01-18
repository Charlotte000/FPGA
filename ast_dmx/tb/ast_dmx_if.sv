interface ast_dmx_if #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W
)( input logic clk );

logic [DATA_W-1:0]    data;
logic                 startofpacket;
logic                 endofpacket;
logic                 valid;
logic [EMPTY_W-1:0]   empty;
logic [CHANNEL_W-1:0] channel;
logic                 ready;

clocking src_cb @( posedge clk );
  output data;
  output startofpacket;
  output endofpacket;
  output valid;
  output empty;
  output channel;
  input  ready;
endclocking

clocking snk_cb @( posedge clk );
  input  data;
  input  startofpacket;
  input  endofpacket;
  input  valid;
  input  empty;
  input  channel;
  output ready;
endclocking

endinterface
