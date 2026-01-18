class ast_dmx_scoreboard #(
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DIR_SEL_W
);
  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) drv2scb;
  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) mon2scb;

  function new(
    input mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) drv2scb,
    input mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) mon2scb
  );
    this.drv2scb = drv2scb;
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

  task run();
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) drv_packet;
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) mon_packet;

    forever
      begin
        this.drv2scb.get( drv_packet );
        this.mon2scb.get( mon_packet );

        if( !ast_dmx_scoreboard::check(
          drv_packet.dir === mon_packet.dir,
          $sformatf( "          dir expected %5d but got %0d", drv_packet.dir, mon_packet.dir )
        )) continue;

        void'( ast_dmx_scoreboard::check(
          drv_packet.channel === mon_packet.channel,
          $sformatf( "ast_channel_o expected %5d but got %0d (dir=%0d)", drv_packet.channel, mon_packet.channel, mon_packet.dir )
        ) );

        if( !ast_dmx_scoreboard::check(
          drv_packet.data.size() === mon_packet.data.size(),
          $sformatf( "  packet size expected %5d but got %0d (channel=%0d)", drv_packet.data.size(), mon_packet.data.size(), mon_packet.channel )
        ) ) continue;

        void'( ast_dmx_scoreboard::check(
          drv_packet.data === mon_packet.data,
          $sformatf( "wrong packet data (channel=%0d)", mon_packet.channel )
        ) );
      end
  endtask

endclass
