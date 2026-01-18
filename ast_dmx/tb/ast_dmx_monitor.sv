class ast_dmx_monitor #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned TX_DIR,
  parameter int unsigned DIR_SEL_W
);
  local virtual ast_dmx_if #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W )
  ) _if [TX_DIR-1:0];

  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) mon2scb;

  function new(
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) _if [TX_DIR-1:0],
    input mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) mon2scb
  );
    this._if     = _if;
    this.mon2scb = mon2scb;
  endfunction

  local static function bit check( input bit status, input string error_msg );
    assert( status )
    else
      begin
        $display( "%8d ns: %s", $time, error_msg );
        return 1'b0;
      end

    return 1'b1;
  endfunction

  local task start_listen(
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) _if,
    input bit          [DIR_SEL_W-1:0] dir,
    input int unsigned                 ready_chance
  );
    logic [7:0] data_buffer [$];
    forever
      begin
        // Set ready
        if( $urandom_range( 0, 100 ) > ready_chance )
          begin
            _if.snk_cb.ready <= 1'b0;
            @( _if.snk_cb );
            continue;
          end

        _if.snk_cb.ready <= 1'b1;

        // Listen data
        if( !_if.snk_cb.valid )
          begin
            @( _if.snk_cb );
            continue;
          end

        if( _if.snk_cb.startofpacket )
          begin
            if( !ast_dmx_monitor::check(
              ( data_buffer.size() == 0 ),
              $sformatf( "unexpected ast_startofpacket_o (dir=%0d)", dir )
            ) )
              begin
                data_buffer.delete();
                @( _if.snk_cb );
                continue;
              end
          end

        // Retrieve data
        for( int unsigned i = 0; i < ( DATA_W / 8 ); i++ )
          data_buffer.push_back( _if.snk_cb.data[i*8 +: 8] );

        if( _if.snk_cb.endofpacket )
          begin
            ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet = new( _if.snk_cb.channel, dir );
            packet.data = { >>{ data_buffer with [ 0 +: (data_buffer.size() - _if.snk_cb.empty) ] } };
            this.mon2scb.put( packet );
            data_buffer.delete();
          end

        @( _if.snk_cb );
      end
  endtask

  task run( input int unsigned ready_chance );
    foreach( this._if[j] )
      begin
        automatic int unsigned i = j;
        fork
          this.start_listen( this._if[i], i, ready_chance );
        join_none
      end
  endtask

endclass
