`timescale 1ns/1ns

module priority_encoder_tb #(
  parameter PERIOD = 10,
  parameter WIDTH = 4
);

localparam WIDTH_MAX_VAL = ( ( 2 ** WIDTH ) - 1 );

bit               clk;
bit               srst;

logic [WIDTH-1:0] data_i;
logic             data_val_i;

logic [WIDTH-1:0] data_left_o;
logic [WIDTH-1:0] data_right_o;

logic             data_val_o;

priority_encoder #( .WIDTH ( WIDTH ) ) DUT (
  .clk_i        ( clk          ),
  .srst_i       ( srst         ),
  .data_i       ( data_i       ),
  .data_val_i   ( data_val_i   ),
  .data_left_o  ( data_left_o  ),
  .data_right_o ( data_right_o ),
  .data_val_o   ( data_val_o   )
);

task automatic reset();
  srst <= 1;
  @( posedge clk );
  srst <= 0;
endtask

task automatic check(
  input bit    result,
  input string error_msg
);
  if( !result )
    begin
      $display( error_msg );
      $stop;
    end
endtask

function automatic logic [WIDTH-1:0] left_bit( input logic [WIDTH-1:0] data );
  for( int i = ( WIDTH - 1 ); i >= 0; i-- )
    begin
      if( data[i] )
        return ( 1 << i );
    end

  return '0;
endfunction

function automatic logic [WIDTH-1:0] right_bit( input logic [WIDTH-1:0] data );
  for( int i = 0; i < WIDTH; i++ )
    begin
      if( data[i] )
        return ( 1 << i );
    end

  return '0;
endfunction

task automatic test_case( input logic [WIDTH-1:0] data );
  data_i     <= data;
  data_val_i <= 1;
  @( posedge clk );

  data_val_i <= 0;
  @( posedge clk );

  check(
    data_val_o == 1,
    $sformatf( "Test Failed: ( data = %b ) expected %s = %b but got %b", data, "data_val_o", 1, data_val_o )
  );

  check(
    data_left_o == left_bit( data ),
    $sformatf( "Test Failed: ( data = %b ) expected %s = %b but got %b", data, "data_left_o", left_bit( data ), data_left_o )
  );

  check(
    data_right_o == right_bit( data ),
    $sformatf( "Test Failed: ( data = %b ) expected %s = %b but got %b", data, "data_right_o", right_bit( data ), data_right_o )
  );
endtask


initial
  forever
    #( PERIOD / 2 ) clk = !clk;

initial
  begin
    data_val_i = 0;
    reset();

    test_case( 4'b0000 );
    test_case( 4'b1000 );
    test_case( 4'b0100 );
    test_case( 4'b0010 );
    test_case( 4'b0001 );
    test_case( 4'b1111 );

    repeat( 100 )
      test_case( $urandom_range( WIDTH_MAX_VAL, 0) );

    $display( "Tests Passed" );
    $stop;
  end


endmodule
