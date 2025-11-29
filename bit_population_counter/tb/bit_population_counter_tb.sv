`timescale 1ns/1ns

module bit_population_counter_tb #(
  parameter int unsigned PERIOD        = 10,
  parameter int unsigned WIDTH         = 128,
  parameter int unsigned PIPELINE_SIZE = 16
);

localparam int unsigned SKIP_CHANCE    = 50;
localparam int unsigned PIPELINE_COUNT = ( WIDTH / PIPELINE_SIZE );
localparam int unsigned LATENCY        = PIPELINE_COUNT;

bit                     clk;
bit                     srst;

logic [WIDTH-1:0]       data_i;
logic                   data_val_i;

logic [$clog2(WIDTH):0] data_o;
logic                   data_val_o;

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

task automatic test_case( input logic [WIDTH-1:0] data [] );
  for( int i = 0; i < ( data.size() + LATENCY ); i++ )
    begin
      int j = ( i - LATENCY );

      if( i < data.size() )
        begin
          data_i     <= data[i];
          data_val_i <= ( data[i] !== 'x );
        end
      else
        begin
          data_i     <= 'x;
          data_val_i <= 0;
        end
      @( posedge clk );

      if( j >= 0 )
        begin

          check(
            data_val_o === ( data[j] !== 'x ),
            $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data[j], "data_val_o", ( data[j] !== 'x ), data_val_o )
          );

          if( data_val_o )
            check(
              data_o === $countones(data[j]),
              $sformatf( "Test Failed: ( data = %b ) expected %s = %0d but got %0d", data[j], "data_o", $countones(data[j]), data_o )
            );
        end
    end
endtask

initial
  forever
    #( PERIOD / 2 ) clk = ( !clk );

initial
  begin
    logic [WIDTH-1:0] data [];

    data_val_i = 0;
    reset();

    data = new [( 1 + WIDTH ) + 100];
    for( int i = 0; i <= WIDTH; i++ )
      data[i] = ( ( ( WIDTH )'( 1 ) << i ) - 1'b1 );

    for( int i = 0; i < 100; i++ )
      begin
        if( $urandom_range( 100, 1 ) <= SKIP_CHANCE )
          data[WIDTH + 1 + i] = 'x;
        else
          data[WIDTH + 1 + i] = $urandom_range( ( 2 ** WIDTH ) - 1, 0 );
      end

    test_case( data );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
