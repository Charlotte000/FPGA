`include "ast_we_packet.sv"

class ast_we_monitor #(
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
  ).monitor _if;

  local mailbox #(
    ast_we_packet #(
      .CHANNEL_W ( CHANNEL_W  ),
      .EMPTY_W   ( EMPTY_IN_W )
    )
  ) mbx;

  function new(
    input virtual ast_we_if #(
      .DATA_IN_W   ( DATA_IN_W   ),
      .EMPTY_IN_W  ( EMPTY_IN_W  ),
      .CHANNEL_W   ( CHANNEL_W   ),
      .DATA_OUT_W  ( DATA_OUT_W  ),
      .EMPTY_OUT_W ( EMPTY_OUT_W )
    ).monitor _if,
    input mailbox #(
      ast_we_packet #(
        .CHANNEL_W ( CHANNEL_W  ),
        .EMPTY_W   ( EMPTY_IN_W )
      )
    ) mbx
  );
    this._if = _if;
    this.mbx = mbx;
  endfunction

  function bit check( input bit status, input string error_msg );
    assert( status )
    else
      begin
        $display( "%8d ns: %s", $time, error_msg );
        return 1'b0;
      end

    return 1'b1;
  endfunction

  function bit checkSignal( input integer unsigned dut_val, input integer unsigned ref_val, input string signal_name );
    return this.check( dut_val === ref_val, $sformatf( "%12s expected %5d but got %0d", signal_name, ref_val, dut_val ) );
  endfunction

  task listen( input int unsigned count );
    ast_we_packet #(
      .CHANNEL_W ( CHANNEL_W  ),
      .EMPTY_W   ( EMPTY_IN_W )
    ) packet;
    logic data [$];

    repeat( count )
      begin
        if( ( !this._if.src_valid ) || ( !this._if.src_ready ) )
          begin
            @( posedge this._if.clk );
            continue;
          end

        if( this._if.src_startofpacket )
          begin
            if( !this.check( ( data.size() == 0 ), "unexpected ast_startofpacket_o" ) )
              begin
                data.delete();
                void'( this.mbx.try_get( packet ) );
                @( posedge this._if.clk );
                continue;
              end
          end

        data = { >>{ data, this._if.src_data } };

        if( this._if.src_endofpacket )
          begin
            // Check packet
            void'( this.check( ( data.size() != 0 ),                       "unexpected ast_endofpacket_o" ) );
            void'( this.check( ( this.mbx.try_get( packet ) != 0 ),        "mailbox is empty"             ) );
            void'( this.checkSignal( this._if.src_channel, packet.channel, "ast_channel_o"                ) );

            if( this.checkSignal( ( data.size() - this._if.src_empty ), ( packet.data.size() - packet.empty ), "packet bit count" ) )
              void'( this.check(
                ( data[this._if.src_empty:data.size()-1] === packet.data[packet.empty:packet.data.size()-1] ),
                $sformatf( "wrong data ( channel=%d )", packet.channel )
              ) );

            data.delete();
          end

        @( posedge this._if.clk );
      end
  endtask

endclass
