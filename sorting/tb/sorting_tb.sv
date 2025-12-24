`timescale 1ns/1ns
module sorting_tb #(
  parameter int unsigned DWIDTH      = 64,
  parameter int unsigned MAX_PKT_LEN = 128,

  parameter time         PERIOD      = 10ns
);

bit                clk;
bit                srst;

logic [DWIDTH-1:0] snk_data;
logic              snk_startofpacket;
logic              snk_endofpacket;
logic              snk_valid;
logic              snk_ready;

logic [DWIDTH-1:0] src_data;
logic              src_startofpacket;
logic              src_endofpacket;
logic              src_valid;

logic              src_ready;

sorting #(
  .DWIDTH      ( DWIDTH      ),
  .MAX_PKT_LEN ( MAX_PKT_LEN )
) DUT (
  .clk_i               ( clk               ),
  .srst_i              ( srst              ),
  .snk_data_i          ( snk_data          ),
  .snk_startofpacket_i ( snk_startofpacket ),
  .snk_endofpacket_i   ( snk_endofpacket   ),
  .snk_valid_i         ( snk_valid         ),
  .snk_ready_o         ( snk_ready         ),
  .src_data_o          ( src_data          ),
  .src_startofpacket_o ( src_startofpacket ),
  .src_endofpacket_o   ( src_endofpacket   ),
  .src_valid_o         ( src_valid         ),
  .src_ready_i         ( src_ready         )
);

task automatic reset();
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
  @( posedge clk );
endtask

task automatic clock();
  forever
    #( PERIOD / 2.0 ) clk <= ( !clk );
endtask

task automatic send_data(
  input logic [DWIDTH-1:0] data        [],
  input int unsigned       skip_chance
);
  int unsigned i = 0;

  while( i < data.size() )
    begin
      assert( snk_ready == 1'b1 )
      else
        begin
          $display( "Test Failed: snk_ready_o != 1" );
          $stop;
        end

      if( $urandom_range( 1, 100 ) <= skip_chance )
        begin
          snk_data          <= 'x;
          snk_startofpacket <= 1'b0;
          snk_endofpacket   <= 1'b0;
          snk_valid         <= 1'b0;
        end
      else
        begin
          snk_data          <= data[i];
          snk_startofpacket <= ( i == 0 );
          snk_endofpacket   <= ( i == ( data.size() - 1 ) );
          snk_valid         <= 1'b1;

          i++;
        end

      @( posedge clk );
    end

  snk_data          <= 'x;
  snk_startofpacket <= 1'b0;
  snk_endofpacket   <= 1'b0;
  snk_valid         <= 1'b0;
endtask

task automatic wait_for_data(
  input int unsigned data_size,
  input int unsigned max_wait_tick = ( data_size * data_size * 2 )
);
  repeat( max_wait_tick )
    begin
      if( src_valid && src_startofpacket )
        return;

      @( posedge clk );
    end

  $display( "Test Failed: src_startofpacket_o != 1" );
  $stop;
endtask

task automatic compare_data( input logic [DWIDTH-1:0] data [] );
  for( int unsigned i = 0; i < data.size(); i++ )
    begin
      bit end_of_packet = ( i == ( data.size() - 1 ) );

      if( !src_valid )
        begin
          @( posedge clk );
          continue;
        end

      assert( src_data == data[i] )
      else
        begin
          $display( "Test Failed: src_data_o ( %0d != %0d )", src_data, data[i] );
          $stop;
        end

      assert( src_endofpacket == end_of_packet )
      else
        begin
          $display( "Test Failed: src_endofpacket_o != %b", end_of_packet );
          $stop;
        end

      @( posedge clk );
    end
endtask

task automatic test_sort(
  input logic        [DWIDTH-1:0] data                [],
  input int unsigned              send_skip_chance
);
  send_data( data, send_skip_chance );
  data.sort();
  wait_for_data( data.size() );
  compare_data( data );
endtask

initial
  begin
    logic [DWIDTH-1:0] data [];

    snk_startofpacket <= 1'b0;
    snk_endofpacket   <= 1'b0;
    snk_valid         <= 1'b0;
    src_ready         <= 1'b1;

    fork
      clock();
    join_none

    reset();

    // Random data / random length
    repeat( 100 )
      begin
        data = new [$urandom_range( 2, MAX_PKT_LEN )];
        for( int unsigned i = 0; i < data.size(); i++ )
          data[i] = $urandom_range( 0, ( ( 2 ** DWIDTH ) - 1 ) );

        test_sort( data, 50 );
        data.delete();
      end

    // Random data / all lengths
    for( int unsigned size = 2; size <= MAX_PKT_LEN; size++ )
      begin
        data = new [size];
        for( int unsigned i = 0; i < data.size(); i++ )
          data[i] = $urandom_range( 0, ( ( 2 ** DWIDTH ) - 1 ) );

        test_sort( data, 0 );
        data.delete();
      end

    // Sorted data
    data = new [10];
    for( int unsigned i = 0; i < data.size(); i++ )
      data[i] = i;

    test_sort( data, 0 );
    data.delete();

    // Reverse data
    data = new [10];
    for( int unsigned i = 0; i < data.size(); i++ )
      data[i] = ( 10 - i );

    test_sort( data, 0 );
    data.delete();

    $display( "Tests Passed" );
    $stop;
  end

endmodule
