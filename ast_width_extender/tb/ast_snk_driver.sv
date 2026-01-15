class ast_snk_driver #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W
);
  mailbox #( ast_packet #( CHANNEL_W ) ) mbx;

  local virtual ast_if #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W )
  ).snk _if;

  local logic [7:0] data_buffer [$];

  function new(
    input virtual ast_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ).snk _if
  );
    this.mbx = new();
    this._if    = _if;
  endfunction

  local function bit check( input bit status, input string error_msg );
    assert( status )
    else
      begin
        $display( "%8d ns: %s", $time, error_msg );
        return 1'b0;
      end

    return 1'b1;
  endfunction

  task start_send_ready( input int unsigned ready_chance );
    forever
      begin
        this._if.ready <= ( $urandom_range( 0, 100 ) <= ready_chance );
        @( posedge this._if.clk );
      end
  endtask

  task start_recieve_packet();
    forever
      begin
        if( ( !this._if.valid ) || ( !this._if.ready ) )
          begin
            @( posedge this._if.clk );
            continue;
          end

        if( this._if.startofpacket )
          begin
            if( !this.check( ( this.data_buffer.size() == 0 ), "unexpected ast_startofpacket_o" ) )
              begin
                this.data_buffer.delete();
                @( posedge this._if.clk );
                continue;
              end
          end

        // Retrieve data
        for( int unsigned i = 0; i < ( DATA_W / 8 ); i++ )
          this.data_buffer.push_back(this._if.data[i*8 +: 8]);

        if( this._if.endofpacket )
          begin
            ast_packet #( CHANNEL_W ) packet = new( this._if.channel );
            packet.data = { >>{ this.data_buffer with [ 0 +: (this.data_buffer.size() - this._if.empty) ] } };
            this.mbx.put( packet );
            this.data_buffer.delete();
          end

        @( posedge this._if.clk );
      end
  endtask

endclass
