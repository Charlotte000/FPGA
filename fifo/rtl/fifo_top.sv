module fifo_top #(
  parameter int unsigned DWIDTH             = 8,
  parameter int unsigned AWIDTH             = 12,
  parameter int unsigned ALMOST_FULL_VALUE  = 12,
  parameter int unsigned ALMOST_EMPTY_VALUE = 2,
  parameter bit          SHOWAHEAD          = 1,
  parameter bit          REGISTER_OUTPUT    = 0
)(
  input  logic              clk_i,
  input  logic              srst_i,

  input  logic [DWIDTH-1:0] data_i,

  input  logic              wrreq_i,
  input  logic              rdreq_i,

  output logic [DWIDTH-1:0] q_o,
  output logic [AWIDTH:0]   usedw_o,

  output logic              empty_o,
  output logic              full_o,
  output logic              almost_full_o,
  output logic              almost_empty_o
);

logic [DWIDTH-1:0] data;
logic              wrreq;
logic              rdreq;
logic [DWIDTH-1:0] q;
logic              empty;
logic              full;
logic [AWIDTH:0]   usedw;
logic              almost_full;
logic              almost_empty;

fifo #(
  .DWIDTH             ( DWIDTH             ),
  .AWIDTH             ( AWIDTH             ),
  .ALMOST_FULL_VALUE  ( ALMOST_FULL_VALUE  ),
  .ALMOST_EMPTY_VALUE ( ALMOST_EMPTY_VALUE ),
  .SHOWAHEAD          ( SHOWAHEAD          ),
  .REGISTER_OUTPUT    ( REGISTER_OUTPUT    )
) fifo_inst (
  .clk_i          ( clk_i        ),
  .srst_i         ( srst_i       ),
  .data_i         ( data         ),
  .wrreq_i        ( wrreq        ),
  .rdreq_i        ( rdreq        ),
  .q_o            ( q            ),
  .empty_o        ( empty        ),
  .full_o         ( full         ),
  .usedw_o        ( usedw        ),
  .almost_full_o  ( almost_full  ),
  .almost_empty_o ( almost_empty )
);

always_ff @( posedge clk_i )
  data <= data_i;

always_ff @( posedge clk_i )
  wrreq <= wrreq_i;

always_ff @( posedge clk_i )
  rdreq <= rdreq_i;

always_ff @( posedge clk_i )
  q_o <= q;

always_ff @( posedge clk_i )
  empty_o <= empty;

always_ff @( posedge clk_i )
  full_o <= full;

always_ff @( posedge clk_i )
  usedw_o <= usedw;

always_ff @( posedge clk_i )
  almost_full_o <= almost_full;

always_ff @( posedge clk_i )
  almost_empty_o <= almost_empty;

endmodule
