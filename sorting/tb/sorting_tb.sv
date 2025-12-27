`timescale 1ns/1ns
module sorting_tb #(
  parameter int unsigned DWIDTH      = 64,
  parameter int unsigned MAX_PKT_LEN = 128,

  parameter time         PERIOD      = 10ns
);

localparam int unsigned DATA_MAX = ( ( 2 ** DWIDTH ) - 1 );

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

typedef logic [DWIDTH-1:0] data_t [];

mailbox #( data_t ) mbx = new();

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
  input data_t       data,
  input int unsigned skip_chance
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

      assert( src_valid == 1'b0 )
      else
        begin
          $display( "Test Failed: src_valid_o != 0" );
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

  mbx.put( data );
endtask

task automatic wait_for_next_packet(
  input int unsigned data_size,
  input bit          send_gibberish = 1'b1,
  input int unsigned max_wait_tick  = ( ( data_size * data_size * 2 ) + 2 )
);
  repeat( max_wait_tick )
    begin
      @( posedge clk );

      if( snk_ready )
        return;

      if( send_gibberish && ( !( src_endofpacket && src_valid ) ) )
        begin
          // Send gibberish
          snk_data          <= $urandom_range( 0, DATA_MAX );
          snk_startofpacket <= $urandom_range( 0, 1 );
          snk_endofpacket   <= $urandom_range( 0, 1 );
          snk_valid         <= $urandom_range( 0, 1 );
        end
      else
        begin
          snk_data          <= 'x;
          snk_startofpacket <= 1'b0;
          snk_endofpacket   <= 1'b0;
          snk_valid         <= 1'b0;
        end
    end

  $display( "Test Failed: no data output" );
  $stop;
endtask

task automatic tx();
  data_t data;

  // Random data / random length
  repeat( 100 )
    begin
      data = new [$urandom_range( 1, MAX_PKT_LEN )];
      foreach( data[i] )
        data[i] = $urandom_range( 0, DATA_MAX );

      send_data( data, 50 );
      wait_for_next_packet( data.size() );
    end

  // Random data / all lengths
  for( int unsigned size = 1; size <= MAX_PKT_LEN; size++ )
    begin
      data = new [size];
      foreach( data[i] )
        data[i] = $urandom_range( 0, DATA_MAX );

      send_data( data, 0 );
      wait_for_next_packet( data.size() );
    end

  // Sorted data
  data = new [10];
  for( int unsigned i = 0; i < data.size(); i++ )
    data[i] = i;

  send_data( data, 0 );
  wait_for_next_packet( data.size() );

  // Reverse data
  data = new [10];
  for( int unsigned i = 0; i < data.size(); i++ )
    data[i] = ( 10 - i );

  send_data( data, 0 );

  // Timeout
  repeat( data.size() * data.size() * 2 )
    @( posedge clk );
endtask

task automatic rx();
  forever
    begin
      int unsigned i;
      data_t       data;

      // Wait for packet
      if( ( !src_valid ) || ( !src_startofpacket ) )
        begin
          @( posedge clk );
          continue;
        end

      assert( mbx.try_get( data ) == 1'b1 )
      else
        begin
          $display( "Test Failed: missing data" );
          $stop;
        end
      data.sort();

      // Recieve packet
      i = 0;
      while( i < data.size() )
        begin
          bit sop = ( i == 0 );
          bit eop = ( i == ( data.size() - 1 ) );

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

          assert( src_startofpacket == sop )
          else
            begin
              $display( "Test Failed: src_startofpacket_o != %b", sop );
              $stop;
            end

          assert( src_endofpacket == eop )
          else
            begin
              $display( "Test Failed: src_endofpacket_o != %b", eop );
              $stop;
            end

          i++;
          @( posedge clk );
        end
    end
endtask

initial
  begin
    snk_startofpacket <= 1'b0;
    snk_endofpacket   <= 1'b0;
    snk_valid         <= 1'b0;
    src_ready         <= 1'b1;

    fork
      clock();
    join_none

    reset();

    fork
      tx();
      rx();
    join_any


    $display( "Tests Passed" );
    $stop;
  end

endmodule
