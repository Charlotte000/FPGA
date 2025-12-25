module sorting #(
  parameter int unsigned DWIDTH,
  parameter int unsigned MAX_PKT_LEN
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

localparam int unsigned AWIDTH = $clog2( MAX_PKT_LEN + 1 );

enum
{
  WAIT_S,
  INPUT_PACKET_S,
  SORTING_S,
  SEND_S
} state, next_state;

logic [AWIDTH-1:0] data_size;
logic [AWIDTH-1:0] avalon_addr;
logic              avalon_a_wr_en;
logic [DWIDTH-1:0] avalon_a_wr_data;

assign avalon_a_wr_en   = ( snk_valid_i && ( ( state == INPUT_PACKET_S ) || snk_startofpacket_i ) );
assign avalon_a_wr_data = snk_data_i;

logic [AWIDTH-1:0] sort_a_addr;
logic              sort_a_wr_en;
logic [DWIDTH-1:0] sort_a_wr_data;
logic [DWIDTH-1:0] sort_a_rd_data;
logic [AWIDTH-1:0] sort_b_addr;
logic              sort_b_wr_en;
logic [DWIDTH-1:0] sort_b_wr_data;
logic [DWIDTH-1:0] sort_b_rd_data;

// RAM
dual_ram #(
  .DWIDTH    ( DWIDTH      ),
  .AWIDTH    ( AWIDTH      ),
  .NUM_WORDS ( MAX_PKT_LEN )
) dual_ram (
  .clk_i       ( clk_i                                                              ),
  .a_addr_i    ( ( state == SORTING_S ) ? ( sort_a_addr    ) : ( avalon_addr      ) ),
  .a_wr_en_i   ( ( state == SORTING_S ) ? ( sort_a_wr_en   ) : ( avalon_a_wr_en   ) ),
  .a_wr_data_i ( ( state == SORTING_S ) ? ( sort_a_wr_data ) : ( avalon_a_wr_data ) ),
  .a_rd_data_o ( sort_a_rd_data                                                     ),
  .b_addr_i    ( sort_b_addr                                                        ),
  .b_wr_en_i   ( sort_b_wr_en                                                       ),
  .b_wr_data_i ( sort_b_wr_data                                                     ),
  .b_rd_data_o ( sort_b_rd_data                                                     )
);

// Avalon interface
always_ff @( posedge clk_i )
  begin
    if( srst_i )
      avalon_addr <= '0;
    else
      if( state == SEND_S )
        avalon_addr <= ( avalon_addr + 1'b1 );
      else
        if( ( state == INPUT_PACKET_S ) || ( snk_valid_i && snk_startofpacket_i ) )
          avalon_addr <= ( avalon_addr + snk_valid_i );
        else
          avalon_addr <= '0;
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_size <= '0;
    else
      if( snk_valid_i && snk_endofpacket_i )
        data_size <= ( avalon_addr + 1'b1 );
  end

// Bubble sort
logic sort_finish;
bubble_sort #(
  .DWIDTH ( DWIDTH ),
  .AWIDTH ( AWIDTH )
) bubble_sort (
  .clk_i       ( clk_i              ),
  .srst_i      ( srst_i             ),
  .enable_i    ( state == SORTING_S ),
  .data_size_i ( data_size          ),
  .a_addr_o    ( sort_a_addr        ),
  .a_wr_en_o   ( sort_a_wr_en       ),
  .a_wr_data_o ( sort_a_wr_data     ),
  .a_rd_data_i ( sort_a_rd_data     ),
  .b_addr_o    ( sort_b_addr        ),
  .b_wr_en_o   ( sort_b_wr_en       ),
  .b_wr_data_o ( sort_b_wr_data     ),
  .b_rd_data_i ( sort_b_rd_data     ),
  .ready_o     ( sort_finish        )
);

// FSM
always_comb
  begin
    next_state = state;
    case( state )
      WAIT_S:
        if( snk_valid_i && snk_endofpacket_i )
          next_state = SORTING_S;
        else
          if( snk_valid_i && snk_startofpacket_i )
            next_state = INPUT_PACKET_S;
      INPUT_PACKET_S:
        if( snk_valid_i && snk_endofpacket_i )
          next_state = SORTING_S;
      SORTING_S:
        if( sort_finish )
          next_state = SEND_S;
      SEND_S:
        if( avalon_addr == data_size )
          next_state = WAIT_S;
      default:
        next_state = WAIT_S;
    endcase
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      state <= WAIT_S;
    else  
      state <= next_state;
  end

// Output
assign src_data_o          = sort_a_rd_data;

assign snk_ready_o         = ( ( state == WAIT_S ) || ( state == INPUT_PACKET_S ) );

assign src_startofpacket_o = ( ( state == SEND_S ) && ( avalon_addr == 1'b1 ) );

assign src_endofpacket_o   = ( ( state == SEND_S ) && ( avalon_addr == data_size ) );

assign src_valid_o         = ( ( state == SEND_S ) && ( avalon_addr >= 1'b1 ) );

endmodule
