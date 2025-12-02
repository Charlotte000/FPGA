`timescale 1ns/1ns

module bit_population_counter_tb #(
  parameter int unsigned PERIOD        = 10,
  parameter int unsigned WIDTH         = 128,
  parameter int unsigned PIPELINE_SIZE = 16,
  parameter int unsigned SKIP_CHANCE   = 50,
  parameter int unsigned TESTS_COUNT   = ( ( WIDTH + 1 ) + 1000 )
);

bit                     clk;
bit                     srst;

logic [WIDTH-1:0]       data_i;
logic                   data_val_i;

logic [$clog2(WIDTH):0] data_o;
logic                   data_val_o;

mailbox #( logic [WIDTH-1:0] ) tests_mailbox = new( TESTS_COUNT );

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
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
endtask

task automatic check( input bit result, input string error_msg );
  if( !result )
    begin
      $display( error_msg );
      $stop;
    end
endtask

task automatic send_tests();
  int unsigned i = 0;
  logic [WIDTH-1:0] data;

  // 0000, 0001, 0011, 0111, ...
  while( i <= WIDTH )
    begin
      if( $urandom_range( 100, 1 ) <= SKIP_CHANCE )
        begin
          data_i     <= 'x;
          data_val_i <= 1'b0;
          @( posedge clk );
          continue;
        end

      data = ( ( WIDTH'( 1 ) << i ) - 1'b1 );

      data_i     <= data;
      data_val_i <= 1'b1;
      @( posedge clk );

      tests_mailbox.put( data );
      i++;
    end

  // Random
  while( i < TESTS_COUNT )
    begin
      if( $urandom_range( 100, 1 ) <= SKIP_CHANCE )
        begin
          data_i     <= 'x;
          data_val_i <= 1'b0;
          @( posedge clk );
          continue;
        end

      data = $urandom_range( ( 2 ** WIDTH ) - 1, 0 );

      data_i     <= data;
      data_val_i <= 1'b1;
      @( posedge clk );

      tests_mailbox.put( data );
      i++;
    end

  data_i     <= 'x;
  data_val_i <= 0;
endtask

task automatic check_tests();
  logic [WIDTH-1:0]       data;
  logic [$clog2(WIDTH):0] count;

  repeat( TESTS_COUNT )
    begin
      while( data_val_o !== 1'b1 )
        @( posedge clk );

      check( tests_mailbox.try_get( data ), "Test Failed: mailbox is empty" );
      count = $countones( data );

      check(
        data_val_o === 1'b1,
        $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data, "data_val_o", ( data !== 'x ), data_val_o )
      );
      check(
        data_o === count,
        $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data, "data_o", count, data_o )
      );

      @( posedge clk );
    end

endtask

initial
  forever
    #( PERIOD / 2 ) clk = ( !clk );

initial
  begin
    data_val_i = 1'b0;
    reset();

    fork
      send_tests();
      check_tests();
    join

    $display( "Tests Passed" );
    $stop;
  end

endmodule
