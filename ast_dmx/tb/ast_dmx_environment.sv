class ast_dmx_environment #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned TX_DIR,
  parameter int unsigned DIR_SEL_W
);
  local ast_dmx_generator #(
    .DATA_W    ( DATA_W    ),
    .CHANNEL_W ( CHANNEL_W ),
    .DIR_SEL_W ( DIR_SEL_W )
  ) generator;

  local ast_dmx_driver #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W ),
    .DIR_SEL_W ( DIR_SEL_W )
  ) driver;

  local ast_dmx_monitor #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W ),
    .TX_DIR    ( TX_DIR    ),
    .DIR_SEL_W ( DIR_SEL_W )
  ) monitor;

  local ast_dmx_scoreboard #(
    .CHANNEL_W ( CHANNEL_W ),
    .DIR_SEL_W ( DIR_SEL_W )
  ) scoreboard;

  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) gen2drv = new();
  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) drv2scb = new();
  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) mon2scb = new();

  function new(
    input virtual ast_dmx_dir_if #( DIR_SEL_W ) src_dir_if,
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) src_if,
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) snk_if [TX_DIR-1:0]
  );
    this.generator  = new( this.gen2drv );
    this.driver     = new( src_dir_if, src_if, this.gen2drv, this.drv2scb );
    this.monitor    = new( snk_if, this.mon2scb );
    this.scoreboard = new( this.drv2scb, this.mon2scb );
  endfunction

  task run( input int unsigned timeout = 10_000_000 );
    fork : run
      this.generator.send_different_lengths();
      // this.generator.send_zero_empty();
      // this.generator.send_non_zero_empty();
      // this.generator.send_random();
      // this.generator.send_same_channel();
      // this.driver.send_gibberish();

      this.driver.run();
      this.monitor.run( 100 );
      this.scoreboard.run();
    join_none

    // Wait for the first packet
    #10_000;

    // Timeout
    repeat( timeout )
      begin
        if( ( this.gen2drv.num() == 0 ) && ( this.drv2scb.num() == 0 ) && ( this.mon2scb.num() == 0 ) )
          break;

        #1;
      end

    disable run;

    // Check remaining packets
    assert( this.gen2drv.num() == 0 )
    else
      $display(
        "%8d ns: Not all packets were sent (%0d) (you might want to increase timeout)",
        $time,
        this.gen2drv.num()
      );

    assert( this.monitor.checkFinished() && ( this.drv2scb.num() == 0 ) && ( this.mon2scb.num() == 0 ) )
    else
      $display(
        "%8d ns: Not all packets were checked (%0d/%0d)",
        $time,
        this.drv2scb.num(),
        this.mon2scb.num()
      );
  endtask

endclass
