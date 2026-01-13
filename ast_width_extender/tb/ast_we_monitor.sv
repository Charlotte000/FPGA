`include "ast_we_packet.sv"
`include "ast_we_rx_driver.sv"

class ast_we_monitor #(
  parameter int unsigned DATA_IN_W,
  parameter int unsigned EMPTY_IN_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DATA_OUT_W,
  parameter int unsigned EMPTY_OUT_W
);
  local ast_we_rx_driver #(
    .DATA_IN_W   ( DATA_IN_W   ),
    .EMPTY_IN_W  ( EMPTY_IN_W  ),
    .CHANNEL_W   ( CHANNEL_W   ),
    .DATA_OUT_W  ( DATA_OUT_W  ),
    .EMPTY_OUT_W ( EMPTY_OUT_W )
  ) driver;

  function new(
    input virtual ast_we_if #(
      .DATA_IN_W   ( DATA_IN_W   ),
      .EMPTY_IN_W  ( EMPTY_IN_W  ),
      .CHANNEL_W   ( CHANNEL_W   ),
      .DATA_OUT_W  ( DATA_OUT_W  ),
      .EMPTY_OUT_W ( EMPTY_OUT_W )
    ).rx _if
  );
    this.driver = new( _if );
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

  task wait_for_ready();
    wait( this.driver.mbx.num() == 0 );
  endtask

  task start_listen( input mailbox #( ast_we_packet #( CHANNEL_W ) ) tx_mbx );
    fork
      this.driver.rx();

      begin
        ast_we_packet #( CHANNEL_W ) rx_packet;
        ast_we_packet #( CHANNEL_W ) tx_packet;
        forever
          begin
            this.driver.mbx.get( rx_packet );
            tx_mbx.get( tx_packet );

            void'( this.check(
              tx_packet.channel == rx_packet.channel,
              $sformatf( "ast_channel_o expected %5d but got %5d", tx_packet.channel, rx_packet.channel )
            ) );

            if( this.check(
              tx_packet.data.size() == rx_packet.data.size(),
              $sformatf( "packet size expected %5d but got %5d (channel=%0d)", tx_packet.data.size(), rx_packet.data.size(), rx_packet.channel )
            ) )
              begin
                void'( this.check(
                  tx_packet.data == rx_packet.data,
                  $sformatf( "wrong packet data (channel=%0d)", rx_packet.channel )
                ) );
              end
          end
      end
    join_any
  endtask

endclass
