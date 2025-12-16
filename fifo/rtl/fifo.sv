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

logic fifo_has_data;
logic output_has_valid;
logic need_load_output;
logic output_is_last;

ram #(
  .DWIDTH ( DWIDTH ),
  .AWIDTH ( AWIDTH )
) ram (
  .clk_i     ( clk_i   ),
  .wr_en_i   ( wr_en   ),
  .wr_addr_i ( wr_addr ),
  .wr_data_i ( data_i  ),
  .rd_en_i   ( rd_en   ),
  .rd_addr_i ( rd_addr ),
  .rd_data_o ( q_o     )
);

// RAM
assign wr_en = ( wrreq_i && ( !full_o ) );

assign rd_en = ( ( rdreq_i && output_has_valid && !output_is_last ) || need_load_output );

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

// Internal state
assign output_is_last   = ( output_has_valid && ( usedw_o == 1'b1 ) );

assign need_load_output = ( fifo_has_data && ( !output_has_valid ) );

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      fifo_has_data <= 1'b0;
    else
      fifo_has_data <= ( wr_en || ( usedw_o > 1'b1 ) );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      output_has_valid <= 1'b0;
    else
      if( need_load_output )
        output_has_valid <= 1'b1;
      else
        if( rdreq_i && output_is_last )
          output_has_valid <= 1'b0;
  end

// Output
always_ff @( posedge clk_i )
  begin
    if( srst_i )
      usedw_o <= '0;
    else
      if( rdreq_i && output_is_last )
        usedw_o <= wr_en;
      else
        if( output_has_valid )
          usedw_o <= ( usedw_o + wr_en - rd_en );
        else
          usedw_o <= ( usedw_o + wr_en );
  end

assign empty_o        = ( !output_has_valid );

assign full_o         = usedw_o[AWIDTH];

assign almost_full_o  = ( usedw_o >= ALMOST_FULL_VALUE );

assign almost_empty_o = ( usedw_o < ALMOST_EMPTY_VALUE );

endmodule
