`include "ast_we_packet.sv"
`include "ast_we_generator.sv"
`include "ast_we_monitor.sv"

`timescale 1ns/1ns

module ast_we_tb #(
  parameter int unsigned DATA_IN_W   = 64,
  parameter int unsigned EMPTY_IN_W  = $clog2( DATA_IN_W / 8 ) ? $clog2( DATA_IN_W / 8 ) : 1,
  parameter int unsigned CHANNEL_W   = 10,
  parameter int unsigned DATA_OUT_W  = 256,
  parameter int unsigned EMPTY_OUT_W = $clog2( DATA_OUT_W / 8 ) ? $clog2( DATA_OUT_W / 8 ) : 1,

  parameter time         PERIOD      = 10ns
);

bit clk;
bit srst;

ast_we_if #(
  .DATA_IN_W   ( DATA_IN_W   ),
  .EMPTY_IN_W  ( EMPTY_IN_W  ),
  .CHANNEL_W   ( CHANNEL_W   ),
  .DATA_OUT_W  ( DATA_OUT_W  ),
  .EMPTY_OUT_W ( EMPTY_OUT_W )
) ast_we_if (
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
  .clk_i               ( ast_we_if.clk               ),
  .srst_i              ( ast_we_if.srst              ),

  .ast_data_i          ( ast_we_if.snk_data          ),
  .ast_startofpacket_i ( ast_we_if.snk_startofpacket ),
  .ast_endofpacket_i   ( ast_we_if.snk_endofpacket   ),
  .ast_valid_i         ( ast_we_if.snk_valid         ),
  .ast_empty_i         ( ast_we_if.snk_empty         ),
  .ast_channel_i       ( ast_we_if.snk_channel       ),
  .ast_ready_o         ( ast_we_if.snk_ready         ),

  .ast_data_o          ( ast_we_if.src_data          ),
  .ast_startofpacket_o ( ast_we_if.src_startofpacket ),
  .ast_endofpacket_o   ( ast_we_if.src_endofpacket   ),
  .ast_valid_o         ( ast_we_if.src_valid         ),
  .ast_empty_o         ( ast_we_if.src_empty         ),
  .ast_channel_o       ( ast_we_if.src_channel       ),
  .ast_ready_i         ( ast_we_if.src_ready         )
);

mailbox #(
  ast_we_packet #(
    .CHANNEL_W ( CHANNEL_W  ),
    .EMPTY_W   ( EMPTY_IN_W )
  )
) mbx = new();

ast_we_generator #(
  .DATA_IN_W   ( DATA_IN_W   ),
  .EMPTY_IN_W  ( EMPTY_IN_W  ),
  .CHANNEL_W   ( CHANNEL_W   ),
  .DATA_OUT_W  ( DATA_OUT_W  ),
  .EMPTY_OUT_W ( EMPTY_OUT_W )
) generator = new( ast_we_if.generator, mbx );

ast_we_monitor #(
  .DATA_IN_W   ( DATA_IN_W   ),
  .EMPTY_IN_W  ( EMPTY_IN_W  ),
  .CHANNEL_W   ( CHANNEL_W   ),
  .DATA_OUT_W  ( DATA_OUT_W  ),
  .EMPTY_OUT_W ( EMPTY_OUT_W )
) monitor = new( ast_we_if.monitor, mbx );

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
    ast_we_if.snk_valid <= 1'b0;
    ast_we_if.src_ready <= 1'b1;

    fork
      clock();
    join_none

    reset();

    fork
      generator.run();
      monitor.run();
    join_any

    $stop;
  end

endmodule
