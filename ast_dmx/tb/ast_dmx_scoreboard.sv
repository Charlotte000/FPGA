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

  local function void check_packet(
    input ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) drv_packet,
    input ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) mon_packet
  );
    assert( drv_packet.dir === mon_packet.dir )
    else
      begin
        $display(
          "%8d ns: %13s expected %5d but got %0d",
          $time,
          "dir",
          drv_packet.dir,
          mon_packet.dir
        );
        return;
      end

    assert( drv_packet.channel === mon_packet.channel )
    else
      $display(
        "%8d ns: %13s expected %5d but got %0d (dir=%0d)",
        $time,
        "ast_channel_o",
        drv_packet.channel,
        mon_packet.channel,
        mon_packet.dir
      );

    assert( drv_packet.data.size() === mon_packet.data.size() )
    else
      begin
        $display(
          "%8d ns: %13s expected %5d but got %0d (channel=%0d)",
          $time,
          "packet size",
          drv_packet.data.size(),
          mon_packet.data.size(),
          mon_packet.channel
        );
        return;
      end

    assert( drv_packet.data === mon_packet.data )
    else
      $display( "%8d ns: wrong packet data (channel=%0d)", $time, mon_packet.channel );
  endfunction

  task run();
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) drv_packet;
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) mon_packet;

    forever
      begin
        // Dont remove yet
        this.drv2scb.peek( drv_packet );
        this.mon2scb.peek( mon_packet );

        this.check_packet( drv_packet, mon_packet );

        // Now remove
        this.drv2scb.get( drv_packet );
        this.mon2scb.get( mon_packet );
      end
  endtask

endclass
