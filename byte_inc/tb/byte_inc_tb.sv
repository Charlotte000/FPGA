import byte_inc_package::*;

`timescale 1ns/1ns
module byte_inc_tb #(
  parameter int unsigned DATA_WIDTH = 64,
  parameter int unsigned ADDR_WIDTH = 10,
  parameter int unsigned BYTE_CNT   = ( DATA_WIDTH / 8 ),

  parameter time         PERIOD     = 10ns
);

bit clk;
bit srst;

default clocking cb @( posedge clk );
endclocking

byte_inc_if #(
  .ADDR_WIDTH ( ADDR_WIDTH )
) set_if ( clk );

amm_rd_if #(
  .DATA_WIDTH ( DATA_WIDTH ),
  .ADDR_WIDTH ( ADDR_WIDTH )
) rd_if ( clk );

amm_wr_if #(
  .DATA_WIDTH ( DATA_WIDTH ),
  .ADDR_WIDTH ( ADDR_WIDTH ),
  .BYTE_CNT   ( BYTE_CNT   )
) wr_if ( clk );

byte_inc #(
  .DATA_WIDTH ( DATA_WIDTH ),
  .ADDR_WIDTH ( ADDR_WIDTH ),
  .BYTE_CNT   ( BYTE_CNT   )
) DUT (
  .clk_i                  ( clk                 ),
  .srst_i                 ( srst                ),
  .base_addr_i            ( set_if.base_addr    ),
  .length_i               ( set_if.length       ),
  .run_i                  ( set_if.run          ),
  .waitrequest_o          ( set_if.waitrequest  ),
  .amm_rd_address_o       ( rd_if.address       ),
  .amm_rd_read_o          ( rd_if.read          ),
  .amm_rd_readdata_i      ( rd_if.readdata      ),
  .amm_rd_readdatavalid_i ( rd_if.readdatavalid ),
  .amm_rd_waitrequest_i   ( rd_if.waitrequest   ),
  .amm_wr_address_o       ( wr_if.address       ),
  .amm_wr_write_o         ( wr_if.write         ),
  .amm_wr_writedata_o     ( wr_if.writedata     ),
  .amm_wr_byteenable_o    ( wr_if.byteenable    ),
  .amm_wr_waitrequest_i   ( wr_if.waitrequest   )
);

byte_inc_environment #(
  .DATA_WIDTH ( DATA_WIDTH ),
  .ADDR_WIDTH ( ADDR_WIDTH ),
  .BYTE_CNT   ( BYTE_CNT   )
) env = new( set_if, rd_if, wr_if );

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
    set_if.run          <= 1'b0;
    rd_if.readdatavalid <= 1'b0;
    rd_if.waitrequest   <= 1'b0;
    wr_if.waitrequest   <= 1'b0;

    reset();

    env.run();

    $stop;
  end
endmodule
