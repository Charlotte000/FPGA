import ast_dmx_package::*;

`timescale 1ns/1ns
module ast_dmx_tb #(
  parameter int unsigned DATA_WIDTH    = 64,
  parameter int unsigned EMPTY_WIDTH   = $clog2( DATA_WIDTH / 8 ),
  parameter int unsigned CHANNEL_WIDTH = 8,
  parameter int unsigned TX_DIR        = 4,
  parameter int unsigned DIR_SEL_WIDTH = TX_DIR == 1 ? 1 : $clog2( TX_DIR ),

  parameter time         PERIOD        = 10ns
);

bit clk;
bit srst;

default clocking cb @( posedge clk );
endclocking

ast_dmx_dir_if #( DIR_SEL_WIDTH ) src_dir_if ( clk );
ast_dmx_if #(
  .DATA_W    ( DATA_WIDTH    ),
  .EMPTY_W   ( EMPTY_WIDTH   ),
  .CHANNEL_W ( CHANNEL_WIDTH )
) src_if ( clk );

ast_dmx_if #(
  .DATA_W    ( DATA_WIDTH    ),
  .EMPTY_W   ( EMPTY_WIDTH   ),
  .CHANNEL_W ( CHANNEL_WIDTH )
) snk_if [TX_DIR-1:0] ( clk );

logic [DATA_WIDTH-1:0]    snk_data          [TX_DIR-1:0];
logic                     snk_startofpacket [TX_DIR-1:0];
logic                     snk_endofpacket   [TX_DIR-1:0];
logic                     snk_valid         [TX_DIR-1:0];
logic [EMPTY_WIDTH-1:0]   snk_empty         [TX_DIR-1:0];
logic [CHANNEL_WIDTH-1:0] snk_channel       [TX_DIR-1:0];
logic                     snk_ready         [TX_DIR-1:0];

generate
  for( genvar i = 0; i < TX_DIR; i++ )
    begin
      assign snk_if[i].data          = snk_data[i];
      assign snk_if[i].startofpacket = snk_startofpacket[i];
      assign snk_if[i].endofpacket   = snk_endofpacket[i];
      assign snk_if[i].valid         = snk_valid[i];
      assign snk_if[i].empty         = snk_empty[i];
      assign snk_if[i].channel       = snk_channel[i];
      assign snk_ready[i]            = snk_if[i].ready;
    end
endgenerate

ast_dmx #(
  .DATA_WIDTH    ( DATA_WIDTH    ),
  .EMPTY_WIDTH   ( EMPTY_WIDTH   ),
  .CHANNEL_WIDTH ( CHANNEL_WIDTH ),
  .TX_DIR        ( TX_DIR        ),
  .DIR_SEL_WIDTH ( DIR_SEL_WIDTH )
) DUT (
  .clk_i               ( clk                  ),
  .srst_i              ( srst                 ),
  .dir_i               ( src_dir_if.dir       ),

  .ast_data_i          ( src_if.data          ),
  .ast_startofpacket_i ( src_if.startofpacket ),
  .ast_endofpacket_i   ( src_if.endofpacket   ),
  .ast_valid_i         ( src_if.valid         ),
  .ast_empty_i         ( src_if.empty         ),
  .ast_channel_i       ( src_if.channel       ),
  .ast_ready_o         ( src_if.ready         ),

  .ast_data_o          ( snk_data             ),
  .ast_startofpacket_o ( snk_startofpacket    ),
  .ast_endofpacket_o   ( snk_endofpacket      ),
  .ast_valid_o         ( snk_valid            ),
  .ast_empty_o         ( snk_empty            ),
  .ast_channel_o       ( snk_channel          ),
  .ast_ready_i         ( snk_ready            )
);

ast_dmx_environment #(
  .DATA_W    ( DATA_WIDTH    ),
  .EMPTY_W   ( EMPTY_WIDTH   ),
  .CHANNEL_W ( CHANNEL_WIDTH ),
  .TX_DIR    ( TX_DIR        ),
  .DIR_SEL_W ( DIR_SEL_WIDTH )
) env = new( src_dir_if, src_if, snk_if );

task automatic reset();
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
  @( posedge clk );
endtask

initial
  forever
    #( PERIOD / 2.0 ) clk <= ( !clk );

initial
  begin
    src_dir_if.dir <= '0;
    src_if.valid   <= 1'b0;

    reset();

    env.run();

    $stop;
  end
endmodule
