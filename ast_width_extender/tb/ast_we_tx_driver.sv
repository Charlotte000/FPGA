class ast_we_tx_driver #(
  parameter int unsigned DATA_IN_W,
  parameter int unsigned EMPTY_IN_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DATA_OUT_W,
  parameter int unsigned EMPTY_OUT_W
);
  local virtual ast_we_if #(
    .DATA_IN_W   ( DATA_IN_W   ),
    .EMPTY_IN_W  ( EMPTY_IN_W  ),
    .CHANNEL_W   ( CHANNEL_W   ),
    .DATA_OUT_W  ( DATA_OUT_W  ),
    .EMPTY_OUT_W ( EMPTY_OUT_W )
  ).tx _if;

  function new(
    input virtual ast_we_if #(
      .DATA_IN_W   ( DATA_IN_W   ),
      .EMPTY_IN_W  ( EMPTY_IN_W  ),
      .CHANNEL_W   ( CHANNEL_W   ),
      .DATA_OUT_W  ( DATA_OUT_W  ),
      .EMPTY_OUT_W ( EMPTY_OUT_W )
    ).tx _if
  );
    this._if    = _if;
  endfunction

  local function logic [DATA_IN_W-1:0] getWord( ref ast_we_packet #( CHANNEL_W ) packet, output int unsigned empty );
    logic [DATA_IN_W-1:0] data = 'x;
    empty                      = '0;

    for( int unsigned i = 0; i < ( DATA_IN_W / 8 ); i++ )
      begin
        if( packet.data.size() > 0 )
          data[i*8 +: 8] = packet.data.pop_front(); // Grab next byte
        else
          begin
            empty = ( ( DATA_IN_W / 8 ) - i );      // No more bytes, calculate empty value
            break;
          end
      end

    return data;
  endfunction

  function void reset_output();
    this._if.snk_data          <= 'x;
    this._if.snk_startofpacket <= 'x;
    this._if.snk_endofpacket   <= 'x;
    this._if.snk_valid         <= 1'b0;
    this._if.snk_empty         <= 'x;
    this._if.snk_channel       <= 'x;
  endfunction

  task tx( input ast_we_packet #( CHANNEL_W ) packet );
    int unsigned empty;
    bit          sop;

    sop = 1'b1;
    while( packet.data.size() > 0 )
      begin
        if( this._if.snk_ready && ( $urandom_range(1, 100) <= packet.write_chance ) )
          begin
            this._if.snk_data          <= getWord( packet, empty );
            this._if.snk_startofpacket <= sop;
            this._if.snk_endofpacket   <= ( packet.data.size() == 0 );
            this._if.snk_valid         <= 1'b1;
            this._if.snk_empty         <= empty;
            this._if.snk_channel       <= ( sop ) ? ( packet.channel ) : ( 'x ); // channel only at sop

            sop = 1'b0;
          end
        else
          this.reset_output();

        @( posedge this._if.clk );
      end

    this.reset_output();
  endtask
endclass
