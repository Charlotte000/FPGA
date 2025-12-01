`timescale 1ns/1ns

module bit_population_counter_tb #(
  parameter int unsigned PERIOD        = 10,
  parameter int unsigned WIDTH         = 128,
  parameter int unsigned PIPELINE_SIZE = 16,
  parameter int unsigned SKIP_CHANCE   = 50,
  parameter int unsigned TESTS_COUNT   = ( ( WIDTH + 1 ) + 1000 )
);

localparam int unsigned LATENCY = ( WIDTH / PIPELINE_SIZE );

bit                     clk;
bit                     srst;

logic [WIDTH-1:0]       data_i;
logic                   data_val_i;

logic [$clog2(WIDTH):0] data_o;
logic                   data_val_o;

typedef struct
{
  logic [WIDTH-1:0]       data;
  logic [$clog2(WIDTH):0] count;
} test;

mailbox #( test ) tests_mailbox = new( TESTS_COUNT );

bit_population_counter #(
  .WIDTH         ( WIDTH         ),
  .PIPELINE_SIZE ( PIPELINE_SIZE )
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

task automatic send_tests();
  test new_test;

  // 0000, 0001, 0011, 0111, ...
  for( int i = 0; i <= WIDTH; i++ )
    begin
      new_test = '{ data: ( ( ( WIDTH )'( 1 ) << i ) - 1'b1 ), count: i };
      tests_mailbox.put( new_test );

      data_i     <= new_test.data;
      data_val_i <= ( new_test.data !== 'x );
      @( posedge clk );
    end

  // Random
  for( int i = ( WIDTH + 1 ); i < TESTS_COUNT; i++ )
    begin
      logic [WIDTH-1:0] data;
      data = ( $urandom_range( 100, 1 ) <= SKIP_CHANCE ) ? ( 'x ) : ( $urandom_range( ( 2 ** WIDTH ) - 1, 0 ) );

      new_test = '{ data: data, count: $countones( data ) };
      tests_mailbox.put( new_test );

      data_i     <= new_test.data;
      data_val_i <= ( new_test.data !== 'x );
      @( posedge clk );
    end

  data_i     <= 'x;
  data_val_i <= 0;
endtask

task automatic check_tests();
  test new_test;

  repeat( LATENCY ) @( posedge clk );

  repeat( TESTS_COUNT )
    begin
      @( posedge clk );

      tests_mailbox.get(new_test);

      check(
        data_val_o === ( new_test.data !== 'x ),
        $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", new_test.data, "data_val_o", ( new_test.data !== 'x ), data_val_o )
      );

      if( data_val_o )
        check(
          data_o === new_test.count,
          $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", new_test.data, "data_o", new_test.count, data_o )
        );
    end

endtask

initial
  forever
    #( PERIOD / 2 ) clk = ( !clk );

initial
  begin
    data_val_i = 0;
    reset();

    fork
      send_tests();
      check_tests();
    join

    $display( "Tests Passed" );
    $stop;
  end

endmodule
