module sorting_top #(
  parameter int unsigned DWIDTH      = 4,
  parameter int unsigned MAX_PKT_LEN = 64
)(
  input  logic              clk_i,
  input  logic              srst_i,

  input  logic [DWIDTH-1:0] snk_data_i,
  input  logic              snk_startofpacket_i,
  input  logic              snk_endofpacket_i,
  input  logic              snk_valid_i,
  output logic              snk_ready_o,

  output logic [DWIDTH-1:0] src_data_o,
  output logic              src_startofpacket_o,
  output logic              src_endofpacket_o,
  output logic              src_valid_o,
  input  logic              src_ready_i
);

logic [DWIDTH-1:0] snk_data;
logic              snk_startofpacket;
logic              snk_endofpacket;
logic              snk_valid;
logic              snk_ready;

logic [DWIDTH-1:0] src_data;
logic              src_startofpacket;
logic              src_endofpacket;
logic              src_valid;

logic              src_ready;

sorting #(
  .DWIDTH      ( DWIDTH      ),
  .MAX_PKT_LEN ( MAX_PKT_LEN )
) sorting (
  .clk_i               ( clk_i             ),
  .srst_i              ( srst_i            ),
  .snk_data_i          ( snk_data          ),
  .snk_startofpacket_i ( snk_startofpacket ),
  .snk_endofpacket_i   ( snk_endofpacket   ),
  .snk_valid_i         ( snk_valid         ),
  .snk_ready_o         ( snk_ready         ),
  .src_data_o          ( src_data          ),
  .src_startofpacket_o ( src_startofpacket ),
  .src_endofpacket_o   ( src_endofpacket   ),
  .src_valid_o         ( src_valid         ),
  .src_ready_i         ( src_ready         )
);

always_ff @( posedge clk_i )
  snk_data <= snk_data_i;

always_ff @( posedge clk_i )
  snk_startofpacket <= snk_startofpacket_i;

always_ff @( posedge clk_i )
  snk_endofpacket <= snk_endofpacket_i;

always_ff @( posedge clk_i )
  snk_valid <= snk_valid_i;

always_ff @( posedge clk_i )
  snk_ready_o <= snk_ready;

always_ff @( posedge clk_i )
  src_data_o <= src_data;

always_ff @( posedge clk_i )
  src_startofpacket_o <= src_startofpacket;

always_ff @( posedge clk_i )
  src_endofpacket_o <= src_endofpacket;

always_ff @( posedge clk_i )
  src_valid_o <= src_valid;

always_ff @( posedge clk_i )
  src_ready <= src_ready_i;


endmodule
