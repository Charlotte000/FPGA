`timescale 1ns/1ns

module bit_population_counter_tb #(
  parameter PERIOD = 10,
  parameter WIDTH  = 16
);

bit                     clk;
bit                     srst;

logic [WIDTH-1:0]       data_i;
logic                   data_val_i;

logic [$clog2(WIDTH):0] data_o;
logic                   data_val_o;

bit_population_counter #( .WIDTH ( WIDTH ) ) DUT (
  .clk_i      ( clk        ),
  .srst_i     ( srst       ),
  .data_i     ( data_i     ),
  .data_val_i ( data_val_i ),
  .data_o     ( data_o     ),
  .data_val_o ( data_val_o )
);

task automatic reset();
  srst <= 1;
  @( posedge clk );
  srst <= 0;
endtask

task automatic check( input bit result, input string error_msg );
  if( !result )
    begin
      $display( error_msg );
      $stop;
    end
endtask

function automatic int count_bits( input logic [WIDTH-1:0] data );
  int count;
  count = 0;
  foreach( data[i] )
    count += data[i];

  return count;
endfunction

task automatic test_case( input logic [WIDTH-1:0] data );
  data_i     <= data;
  data_val_i <= 1;
  @( posedge clk );
  check(
    data_val_o == 0,
    $sformatf( "Test Failed: ( data = %b ) expected %s = %b but got %b", data, "data_val_o", 1'b0, data_val_o )
  );

  data_val_i <= 0;
  @( posedge clk );
  check(
    data_val_o == 1,
    $sformatf( "Test Failed: ( data = %b ) expected %s = %b but got %b", data, "data_val_o", 1'b1, data_val_o )
  );
  check(
    data_o == count_bits(data),
    $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data, "data_o", count_bits(data), data_o )
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
    test_case( 4'b0001 );
    test_case( 4'b0011 );
    test_case( 4'b0111 );
    test_case( 4'b1111 );

    repeat( 100 )
      test_case( $urandom_range( ( 2 ** WIDTH ) - 1, 0) );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
