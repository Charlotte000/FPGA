`timescale 1ns/1ps

typedef logic [15:0] crc_16_hash;

module crc_16_ansi_tb #(
  parameter PERIOD   = 6.666,
  parameter POLY     = 16'h8005,
  parameter CRC_INIT = 16'h0000,
  parameter DATA_W   = 32
);

bit                clk;
bit                rst;

logic              data_i;
crc_16_hash        data_o;

logic [DATA_W-1:0] data;

crc_16_ansi DUT (
  .clk_i  ( clk    ),
  .rst_i  ( rst    ),
  .data_i ( data_i ),
  .data_o ( data_o )
);

function void crc_16_step( input logic data, inout crc_16_hash hash );
  hash = ( data ^ ( ( hash >> 15 ) & 1 ) ) ? ( ( hash << 1 ) ^ POLY ) : ( hash << 1 );
endfunction

function automatic crc_16_hash crc_16( input logic [DATA_W-1:0] data );
  crc_16_hash result;
  result = CRC_INIT;

  for( int i = 0; i < DATA_W; i++ )
    crc_16_step( data[i], result );

  return result;
endfunction

task automatic test_case();
  crc_16_hash result_true;

  reset();

  // Feed data
  for( int i = 0; i < DATA_W; i++ )
    begin
      data_i = data[i];
      @( posedge clk );
    end

  // Check result
  result_true = crc_16( data );
  if( data_o !== result_true )
    begin
      $display( "Test Failed: ( data = %h ) expected %h but got %h", data, result_true, data_o );
      $stop;
    end
endtask

task reset();
  @( posedge clk );
  rst = 1;
  @( posedge clk );
  rst = 0;
endtask

initial
  forever
    #( PERIOD / 2 ) clk = !clk;

initial
  begin
    data_i = 0;
    reset();

    for( int i = 0; i < 100; i++ )
      begin
        data = $urandom_range( 2 ** DATA_W - 1, 0 );
        test_case();
      end

    $display( "Tests Passed" );
    $stop;
  end

endmodule