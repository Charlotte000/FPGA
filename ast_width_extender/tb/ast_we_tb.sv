`include "ast_packet.sv"
`include "ast_generator.sv"
`include "ast_monitor.sv"

`timescale 1ns/1ns

module ast_we_tb #(
  parameter int unsigned DATA_IN_W   = 64,
  parameter int unsigned EMPTY_IN_W  = $clog2( DATA_IN_W / 8 ) ? $clog2( DATA_IN_W / 8 ) : 1,
  parameter int unsigned CHANNEL_W   = 10,
  parameter int unsigned DATA_OUT_W  = 256,
  parameter int unsigned EMPTY_OUT_W = $clog2( DATA_OUT_W / 8 ) ? $clog2( DATA_OUT_W / 8 ) : 1,

  parameter time         PERIOD      = 10ns
);
  localparam int unsigned SNK_READY_CHANCE = 100; // Must be in range (0, 100]

bit clk;
bit srst;

ast_if #(
  .DATA_W    ( DATA_IN_W  ),
  .EMPTY_W   ( EMPTY_IN_W ),
  .CHANNEL_W ( CHANNEL_W  )
) src_if (
  .clk  ( clk  ),
  .srst ( srst )
);

ast_if #(
  .DATA_W    ( DATA_OUT_W  ),
  .EMPTY_W   ( EMPTY_OUT_W ),
  .CHANNEL_W ( CHANNEL_W   )
) snk_if (
  .clk  ( clk  ),
  .srst ( srst )
);

ast_width_extender #(
  .DATA_IN_W   ( DATA_IN_W   ),
  .EMPTY_IN_W  ( EMPTY_IN_W  ),
  .CHANNEL_W   ( CHANNEL_W   ),
  .DATA_OUT_W  ( DATA_OUT_W  ),
  .EMPTY_OUT_W ( EMPTY_OUT_W )
) DUT (
  .clk_i               ( clk                  ),
  .srst_i              ( srst                 ),

  .ast_data_i          ( src_if.data          ),
  .ast_startofpacket_i ( src_if.startofpacket ),
  .ast_endofpacket_i   ( src_if.endofpacket   ),
  .ast_valid_i         ( src_if.valid         ),
  .ast_empty_i         ( src_if.empty         ),
  .ast_channel_i       ( src_if.channel       ),
  .ast_ready_o         ( src_if.ready         ),

  .ast_data_o          ( snk_if.data          ),
  .ast_startofpacket_o ( snk_if.startofpacket ),
  .ast_endofpacket_o   ( snk_if.endofpacket   ),
  .ast_valid_o         ( snk_if.valid         ),
  .ast_empty_o         ( snk_if.empty         ),
  .ast_channel_o       ( snk_if.channel       ),
  .ast_ready_i         ( snk_if.ready         )
);

ast_generator #(
  .DATA_W    ( DATA_IN_W  ),
  .EMPTY_W   ( EMPTY_IN_W ),
  .CHANNEL_W ( CHANNEL_W  )
) generator = new( src_if );

ast_monitor #(
  .DATA_W    ( DATA_OUT_W  ),
  .EMPTY_W   ( EMPTY_OUT_W ),
  .CHANNEL_W ( CHANNEL_W   )
) monitor = new( snk_if, generator.mbx );

task automatic reset();
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
  @( posedge clk );
endtask

task automatic clock();
  forever
    #( PERIOD / 2.0 ) clk <= ( !clk );
endtask

initial
  begin
    src_if.valid <= 1'b0;
    snk_if.ready <= 1'b1;

    fork
      clock();
    join_none

    reset();

    monitor.start_listen( SNK_READY_CHANCE );


    // $display( "Begin test: Send different lengths" );
    // generator.send_different_lengths();
    // monitor.wait_for_ready();
    // $display( "End test:  Send different lengths" );

    $display( "Begin test: Send zero empty" );
    generator.send_zero_empty();
    monitor.wait_for_ready();
    $display( "End test:  Send zero empty" );

    $display( "Begin test: Send non zero empty" );
    generator.send_non_zero_empty();
    monitor.wait_for_ready();
    $display( "End test:  Send non zero empty" );

    // $display( "Begin test: Send random" );
    // generator.send_random();
    // monitor.wait_for_ready();
    // $display( "End test:   Send random" );

    // $display( "Begin test: Send same channel" );
    // generator.send_same_channel();
    // monitor.wait_for_ready();
    // $display( "End test:   Send same channel" );

    // $display( "Begin test: Send gibberish" );
    // generator.send_gibberish();
    // monitor.wait_for_ready();
    // $display( "End test:   Send gibberish" );

    $stop;
  end

endmodule
