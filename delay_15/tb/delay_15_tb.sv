`timescale 1ns/1ps
`define PERIOD 6.666

module delay_15_tb #(
  parameter DELAY_W = 4
);

bit                 clk;
bit                 rst;

logic               data_i;
logic [DELAY_W-1:0] data_delay_i;

logic               data_o;

delay_15 DUT (
  .clk_i        ( clk          ),
  .rst_i        ( rst          ),
  .data_i       ( data_i       ),
  .data_delay_i ( data_delay_i ),
  .data_o       ( data_o       )
);

task reset();
  ##1 rst = 1;
  ##1 rst = 0;
endtask

task test_case(
  input logic               data,
  input logic [DELAY_W-1:0] data_delay
);
  data_i       = data;
  data_delay_i = data_delay;
  // #0.001;

  for( int i = 0; i < data_delay; i++ )
    begin
      data_i = ( i == 0 ) ? ( data ) : ( !data );
      ##1;
    end

  if( data_o !== data )
    begin
      $display( "Test Failed: ( data_delay_i = %b ) expected %b but got %b", data_delay_i, data, data_o );
      $stop;
    end
endtask

initial
  forever
    #( `PERIOD / 2 ) clk = !clk;

default clocking cb @ ( posedge clk );
endclocking

initial
  begin
    reset();
    data_delay_i = 1;

    for( int i = 0; i < 100; i++ )
      test_case( $urandom_range( 1, 0 ), $urandom_range( 2 ** DELAY_W - 1, 0 ) );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
