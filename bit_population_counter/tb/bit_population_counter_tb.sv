`timescale 1ns/1ns

module bit_population_counter_tb #(
  parameter PERIOD    = 10,
  parameter WIDTH     = 128,
  parameter PIPE_SIZE = 16
);

bit                     clk;
bit                     srst;

logic [WIDTH-1:0]       data_i;
logic                   data_val_i;

logic [$clog2(WIDTH):0] data_o;
logic                   data_val_o;

bit_population_counter #(
  .WIDTH     ( WIDTH     ),
  .PIPE_SIZE ( PIPE_SIZE )
) DUT (
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

task automatic test_case( input logic [WIDTH-1:0] data, input int unsigned break_chance );
  data_i     <= data;
  data_val_i <= 1;
  @( posedge clk );

  data_i     <= 'x;
  data_val_i <= 0;
  repeat( ( WIDTH / PIPE_SIZE ) + 1 )
    begin
      if( $urandom_range( 100, 1 ) <= break_chance )
          return;
      @( posedge clk );
    end

  check(
    data_val_o == 1,
    $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data, "data_val_o", 1, data_val_o )
  );
  check(
    data_o == $countones(data),
    $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data, "data_o", $countones(data), data_o )
  );
endtask

initial
  forever
    #( PERIOD / 2 ) clk = ( !clk );

initial
  begin
    data_val_i = 0;
    reset();

    for( int i = 0; i <= WIDTH; i++ )
      test_case( ( ( WIDTH )'( 1 ) << i ) - 1'b1, 0 );

    repeat( 100 )
      test_case( $urandom_range( ( 2 ** WIDTH ) - 1, 0), 0 );

    repeat( 100 )
      test_case( $urandom_range( ( 2 ** WIDTH ) - 1, 0), 50 );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
