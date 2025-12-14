/*
SHOWAHEAD       = 1
REGISTER_OUTPUT = 0
*/
module fifo #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH,
  parameter int unsigned ALMOST_FULL_VALUE,
  parameter int unsigned ALMOST_EMPTY_VALUE
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

logic              wr_en;
logic [AWIDTH-1:0] wr_addr;

logic              rd_en;
logic [AWIDTH-1:0] rd_addr;

ram #(
  .DWIDTH ( DWIDTH ),
  .AWIDTH ( AWIDTH )
) ram (
  .clk_i     ( clk_i   ),
  .wr_en_i   ( wr_en   ),
  .wr_addr_i ( wr_addr ),
  .wr_data_i ( data_i  ),
  .rd_en_i   ( 1'b1    ),
  .rd_addr_i ( rd_addr + rd_en ),
  .rd_data_o ( q_o     )
);

assign wr_en = ( wrreq_i && ( !full_o ) );

assign rd_en = ( rdreq_i && ( !empty_o ) );

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      wr_addr <= '0;
    else
      wr_addr <= ( wr_addr + wr_en );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      rd_addr <= '0;
    else
      rd_addr <= ( rd_addr + rd_en );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      usedw_o <= '0;
    else
      usedw_o <= ( usedw_o + wr_en - rd_en );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      empty_o <= 1'b1;
    else
      empty_o <= ( ( usedw_o - rd_en ) == '0 );
  end

assign full_o         = usedw_o[AWIDTH];

assign almost_full_o  = ( usedw_o >= ALMOST_FULL_VALUE );

assign almost_empty_o = ( usedw_o < ALMOST_EMPTY_VALUE );

endmodule
