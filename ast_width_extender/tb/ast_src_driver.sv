class ast_src_driver #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W
);
  localparam int unsigned DATA_MAX    = ( ( 2 ** DATA_W    ) - 1 );
  localparam int unsigned EMPTY_MAX   = ( ( 2 ** EMPTY_W   ) - 1 );
  localparam int unsigned CHANNEL_MAX = ( ( 2 ** CHANNEL_W ) - 1 );

  local virtual ast_if #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W )
  ).src _if;

  function new(
    input virtual ast_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ).src _if
  );
    this._if    = _if;
  endfunction

  local function logic [DATA_W-1:0] getWord( ref ast_packet #( CHANNEL_W ) packet, output int unsigned empty );
    logic [DATA_W-1:0] data = 'x;
    empty                   = '0;

    for( int unsigned i = 0; i < ( DATA_W / 8 ); i++ )
      begin
        if( packet.data.size() > 0 )
          data[i*8 +: 8] = packet.data.pop_front(); // Grab next byte
        else
          begin
            empty = ( ( DATA_W / 8 ) - i ); // No more bytes, calculate empty value
            break;
          end
      end

    return data;
  endfunction

  function void reset();
    this._if.data          <= 'x;
    this._if.startofpacket <= 'x;
    this._if.endofpacket   <= 'x;
    this._if.valid         <= 1'b0;
    this._if.empty         <= 'x;
    this._if.channel       <= 'x;
  endfunction

  task send_packet( input ast_packet #( CHANNEL_W ) packet );
    int unsigned empty;
    bit          sop;

    sop = 1'b1;
    while( packet.data.size() > 0 )
      begin
        if( this._if.ready && ( $urandom_range(1, 100) <= packet.write_chance ) )
          begin
            this._if.data          <= getWord( packet, empty );
            this._if.startofpacket <= sop;
            this._if.endofpacket   <= ( packet.data.size() == 0 );
            this._if.valid         <= 1'b1;
            this._if.empty         <= empty;
            this._if.channel       <= ( sop ) ? ( packet.channel ) : ( 'x ); // channel only at sop

            sop = 1'b0;
          end
        else
          this.reset();

        @( posedge this._if.clk );
      end

    this.reset();
  endtask

  task send_gibberish( input int unsigned count = 100 );
    repeat( count )
      begin
        this._if.data          <= $urandom_range( 0, DATA_MAX );
        this._if.startofpacket <= $urandom_range( 0, 1 );
        this._if.endofpacket   <= $urandom_range( 0, 1 );
        this._if.valid         <= 1'b0;
        this._if.empty         <= $urandom_range( 0, EMPTY_MAX );
        this._if.channel       <= $urandom_range( 0, CHANNEL_MAX );
        @( posedge this._if.clk );
      end

    this.reset();
  endtask

endclass
