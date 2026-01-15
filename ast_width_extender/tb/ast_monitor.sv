`include "ast_packet.sv"
`include "ast_snk_driver.sv"

class ast_monitor #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W
);
  local ast_snk_driver #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W )
  ) driver;

  local mailbox #( ast_packet #( CHANNEL_W ) ) generator_mbx;

  function new(
    input virtual ast_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ).snk _if,
    input mailbox #( ast_packet #( CHANNEL_W ) ) generator_mbx
  );
    this.driver        = new( _if );
    this.generator_mbx = generator_mbx;
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

  task wait_for_ready();
    wait( this.generator_mbx.num() == 0 );
    wait( this.driver.mbx.num() == 0 );
  endtask

  task start_listen( input int unsigned ready_chance );
    fork
      // Start driver
      this.driver.start_recieve_packet();

      // Start send ready
      this.driver.start_send_ready( ready_chance );

      // Start monitoring
      begin
        ast_packet #( CHANNEL_W ) rx_packet;
        ast_packet #( CHANNEL_W ) tx_packet;
        forever
          begin
            this.driver.mbx.get( rx_packet );
            this.generator_mbx.get( tx_packet );

            void'( this.check(
              tx_packet.channel === rx_packet.channel,
              $sformatf( "ast_channel_o expected %5d but got %5d", tx_packet.channel, rx_packet.channel )
            ) );

            if( this.check(
              tx_packet.data.size() === rx_packet.data.size(),
              $sformatf( "packet size expected %5d but got %5d (channel=%0d)", tx_packet.data.size(), rx_packet.data.size(), rx_packet.channel )
            ) )
              begin
                void'( this.check(
                  tx_packet.data === rx_packet.data,
                  $sformatf( "wrong packet data (channel=%0d)", rx_packet.channel )
                ) );
              end
          end
      end
    join_none
  endtask

endclass
