`timescale 1ns/1ns

module debouncer_tb #(
  parameter int unsigned CLK_FREQ_MHZ   = 100,
  parameter int unsigned GLITCH_TIME_NS = 100
);

localparam real PERIOD = ( 1_000.0 / CLK_FREQ_MHZ );
localparam int unsigned GLITCH_CYCLES = ( CLK_FREQ_MHZ * GLITCH_TIME_NS / 1_000 );

bit   clk;
bit   key_i;
logic key_pressed_stb_o;

debouncer #(
  .CLK_FREQ_MHZ   ( CLK_FREQ_MHZ   ),
  .GLITCH_TIME_NS ( GLITCH_TIME_NS )
) DUT (
  .clk_i             ( clk               ),
  .key_i             ( key_i             ),
  .key_pressed_stb_o ( key_pressed_stb_o )
);

task automatic check( input bit result, input string error_msg );
  if( !result )
    begin
      $display( error_msg );
      $stop;
    end
endtask

task automatic send_consecutive( input int unsigned cycles );
  // Off x 1
  key_i <= 1'b1;
  @( posedge clk );

  // On x i
  repeat( cycles - 1 )
    begin
      key_i <= 1'b0;
      @( posedge clk );
    end
endtask

task automatic send_random( input int unsigned cycles, input int unsigned off_chance );
  repeat( cycles )
    begin
      key_i <= ( $urandom_range( 100, 1 ) <= off_chance );
      @( posedge clk );
    end
endtask

task automatic listen( input int unsigned cycles );
  logic [3:0] key_buffer;
  time last_off;
  bit stb;

  repeat( cycles )
    begin
      @( posedge clk );
      key_buffer = { key_buffer[2:0], key_i };

      if( key_buffer[3] )
        last_off = $time;

      stb = ( ( $time - last_off ) == GLITCH_TIME_NS );
      check(
        key_pressed_stb_o == stb,
        $sformatf( "Test Failed: expected %s = %0d but got %0d", "key_pressed_stb_o", stb, key_pressed_stb_o )
      );
    end
endtask

initial
  forever
    #( PERIOD / 2 ) clk = ( !clk );

initial
  begin
    key_i <= 1'b1;
    repeat( 3 ) @( posedge clk );

    fork
      // Send tests
      begin
        send_consecutive( GLITCH_CYCLES - 2 );
        send_consecutive( GLITCH_CYCLES - 1 );
        send_consecutive( GLITCH_CYCLES     );
        send_consecutive( GLITCH_CYCLES + 1 );
        send_consecutive( GLITCH_CYCLES + 2 );

        send_random( ( GLITCH_CYCLES * 2   ), 100 );
        send_random( ( GLITCH_CYCLES * 100 ), 90  );
        send_random( ( GLITCH_CYCLES * 100 ), 10  );
        send_random( ( GLITCH_CYCLES * 2   ), 0   );
      end

      // Check tests
      listen( ( GLITCH_CYCLES * 5 ) + GLITCH_CYCLES * ( 2 + 100 + 100 + 2 ) );
    join

    $display( "Tests Passed" );
    $stop;
  end

endmodule
