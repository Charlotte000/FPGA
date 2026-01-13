class ast_we_rx_driver #(
  parameter int unsigned DATA_IN_W,
  parameter int unsigned EMPTY_IN_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DATA_OUT_W,
  parameter int unsigned EMPTY_OUT_W
);
  mailbox #( ast_we_packet #( CHANNEL_W ) ) mbx;

  local virtual ast_we_if #(
    .DATA_IN_W   ( DATA_IN_W   ),
    .EMPTY_IN_W  ( EMPTY_IN_W  ),
    .CHANNEL_W   ( CHANNEL_W   ),
    .DATA_OUT_W  ( DATA_OUT_W  ),
    .EMPTY_OUT_W ( EMPTY_OUT_W )
  ).rx _if;

  local logic unsigned [7:0] data_buffer [$];

  function new(
    input virtual ast_we_if #(
      .DATA_IN_W   ( DATA_IN_W   ),
      .EMPTY_IN_W  ( EMPTY_IN_W  ),
      .CHANNEL_W   ( CHANNEL_W   ),
      .DATA_OUT_W  ( DATA_OUT_W  ),
      .EMPTY_OUT_W ( EMPTY_OUT_W )
    ).rx _if
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

  task rx();
    forever
      begin
        if( ( !this._if.src_valid ) || ( !this._if.src_ready ) )
          begin
            @( posedge this._if.clk );
            continue;
          end

        if( this._if.src_startofpacket )
          begin
            if( !this.check( ( this.data_buffer.size() == 0 ), "unexpected ast_startofpacket_o" ) )
              begin
                this.data_buffer.delete();
                @( posedge this._if.clk );
                continue;
              end
          end

        // Retrieve data
        for( int unsigned i = 0; i < ( DATA_OUT_W / 8 ); i++ )
          this.data_buffer.push_back(this._if.src_data[i*8 +: 8]);

        if( this._if.src_endofpacket )
          begin
            ast_we_packet #( CHANNEL_W ) packet = new( 0, this._if.src_channel );
            packet.data = { >>{ this.data_buffer with [ 0 +: (this.data_buffer.size() - this._if.src_empty) ] } };
            this.mbx.put( packet );
            this.data_buffer.delete();
          end

        @( posedge this._if.clk );
      end
  endtask

endclass
