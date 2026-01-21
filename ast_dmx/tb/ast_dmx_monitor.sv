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

  local logic [7:0] data_buffer [$];

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

  local task start_set_ready(
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) _if,
    input int unsigned ready_chance
  );
    forever
      begin
        _if.snk_cb.ready <= ( $urandom_range( 0, 100 ) <= ready_chance );
        @( _if.snk_cb );
      end
  endtask

  local task start_check_unknown(
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) _if
  );
    forever
      begin
        assert( !$isunknown( _if.snk_cb.valid ) )
        else
          $display( "%8d ns: ast_valid_o is unknown", $time );

        assert(
          ( _if.snk_cb.valid === 1'b1 ) ->
          ( ( !$isunknown( _if.snk_cb.data          ) ) &&
            ( !$isunknown( _if.snk_cb.startofpacket ) ) &&
            ( !$isunknown( _if.snk_cb.endofpacket   ) ) &&
            ( !$isunknown( _if.snk_cb.empty         ) ) &&
            ( !$isunknown( _if.snk_cb.channel       ) )
          )
        )
        else
          $display( "%8d ns: ast output is unknown", $time );

        @( _if.snk_cb );
      end
  endtask

  local task start_input_packet(
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) _if,
    input bit [DIR_SEL_W-1:0] dir
  );
    forever
      begin
        if( ( !_if.snk_cb.valid ) || ( !_if.ready ) )
          begin
            @( _if.snk_cb );
            continue;
          end

        if( _if.snk_cb.startofpacket )
          begin
            assert( this.data_buffer.size() == 0 )
            else
              begin
                $display( "%8d ns: unexpected ast_startofpacket_o (dir=%0d)", $time, dir );
                this.data_buffer.delete();
                @( _if.snk_cb );
                continue;
              end
          end

        // Retrieve data
        for( int unsigned i = 0; i < ( DATA_W / 8 ); i++ )
          this.data_buffer.push_back( _if.snk_cb.data[i*8 +: 8] );

        if( _if.snk_cb.endofpacket )
          begin
            ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet = new( _if.snk_cb.channel, dir );
            packet.data = { >>{ this.data_buffer with [ 0 +: (this.data_buffer.size() - _if.snk_cb.empty) ] } };
            this.mon2scb.put( packet );
            this.data_buffer.delete();
          end

        @( _if.snk_cb );
      end
  endtask

  task run( input int unsigned ready_chance );
    foreach( this._if[j] )
      begin
        automatic int unsigned i = j;
        fork
          this.start_set_ready( this._if[i], ready_chance );
          // this.start_check_unknown( this._if[i] );
          this.start_input_packet( this._if[i], i );
        join_none
      end
  endtask

  function bit checkFinished();
    return ( this.data_buffer.size() == 0 );
  endfunction

endclass
