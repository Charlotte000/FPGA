`timescale 1ms/10us
module traffic_lights_tb #(
  parameter int unsigned BLINK_HALF_PERIOD_MS  = 2,
  parameter int unsigned BLINK_GREEN_TIME_TICK = 4,
  parameter int unsigned RED_YELLOW_MS         = 50
);

import definitions_pkg::*;

localparam int unsigned CLK_FREQ_KHZ = 2;
localparam real         PERIOD_MS     = ( 1.0 / CLK_FREQ_KHZ );

bit              clk_2k;
bit              srst_i;
command_e        cmd_type_i;
logic            cmd_valid_i;
logic     [15:0] cmd_data_i;
logic            red_o;
logic            yellow_o;
logic            green_o;

traffic_lights #(
  .BLINK_HALF_PERIOD_MS  ( BLINK_HALF_PERIOD_MS  ),
  .BLINK_GREEN_TIME_TICK ( BLINK_GREEN_TIME_TICK ),
  .RED_YELLOW_MS         ( RED_YELLOW_MS )
) DUT (
  .clk_2k_i    ( clk_2k      ),
  .srst_i      ( srst_i      ),
  .cmd_type_i  ( cmd_type_i  ),
  .cmd_valid_i ( cmd_valid_i ),
  .cmd_data_i  ( cmd_data_i  ),
  .red_o       ( red_o       ),
  .yellow_o    ( yellow_o    ),
  .green_o     ( green_o     )
);

task automatic check( input bit res, input string err_msg );
  assert( res )
  else
    begin
      $error( "Test Failed: %s", err_msg );
      $stop;
    end
endtask

task automatic reset();
  srst_i <= 1'b1;
  @( posedge clk_2k );
  srst_i <= 1'b0;
endtask

task automatic set_times(
  input time red,
  input time yellow,
  input time green
);
  cmd_valid_i <= 1'b1;

  // Set MANUAL mode
  cmd_type_i  <= SET_MANUAL;
  @( posedge clk_2k );

  // Set red time
  cmd_type_i <= SET_RED;
  cmd_data_i <= red;
  @( posedge clk_2k );

  // Set yellow time
  cmd_type_i  <= SET_YELLOW;
  cmd_data_i  <= yellow;
  @( posedge clk_2k );

  // Set green time
  cmd_type_i <= SET_GREEN;
  cmd_data_i <= green;
  @( posedge clk_2k );

  // Set ON mode
  cmd_type_i <= SET_ON;
  @( posedge clk_2k );

  cmd_valid_i <= 1'b0;
  cmd_type_i  <= command_e'('x);
  cmd_data_i  <= 'x;
endtask

task automatic set_manual();
  cmd_valid_i <= 1'b1;
  cmd_type_i  <= SET_MANUAL;
  @( posedge clk_2k );

  cmd_valid_i <= 1'b0;
  cmd_type_i  <= command_e'('x);
endtask

task automatic listen_standard_mode(
  input time red,
  input time yellow,
  input time green
);
  // Red
  repeat( red * CLK_FREQ_KHZ )
    begin
      @( posedge clk_2k );
      check( ( !green_o ) && ( !yellow_o ) && (  red_o ), "unexpected color" );
    end

  // Red + Yellow
  repeat( RED_YELLOW_MS * CLK_FREQ_KHZ )
    begin
      @( posedge clk_2k );
      check( ( !green_o ) && (  yellow_o ) && (  red_o ), "unexpected color" );
    end

  // Green
  repeat( green * CLK_FREQ_KHZ )
    begin
      @( posedge clk_2k );
      check( (  green_o ) && ( !yellow_o ) && ( !red_o ), "unexpected color" );
    end

  // Green blink
  repeat( BLINK_GREEN_TIME_TICK )
    begin
      // On
      repeat( BLINK_HALF_PERIOD_MS * CLK_FREQ_KHZ )
        begin
          @( posedge clk_2k );
          check( (  green_o ) && ( !yellow_o ) && ( !red_o ), "unexpected color" );
        end

      // Off
      repeat( BLINK_HALF_PERIOD_MS * CLK_FREQ_KHZ )
        begin
          @( posedge clk_2k );
          check( ( !green_o ) && ( !yellow_o ) && ( !red_o ), "unexpected color" );
        end
    end

  // Yellow
  repeat( yellow * CLK_FREQ_KHZ )
    begin
      @( posedge clk_2k );
      check( ( !green_o ) && (  yellow_o ) && ( !red_o ), "unexpected color" );
    end
endtask

task automatic listen_manual_mode( input int unsigned ticks );
  // Yellow blink
  repeat( ticks )
    begin
      // On
      repeat( BLINK_HALF_PERIOD_MS * CLK_FREQ_KHZ )
        begin
          @( posedge clk_2k );
          check( ( !green_o ) && (  yellow_o ) && ( !red_o ), "unexpected color" );
        end

      // Off
      repeat( BLINK_HALF_PERIOD_MS * CLK_FREQ_KHZ )
        begin
          @( posedge clk_2k );
          check( ( !green_o ) && ( !yellow_o ) && ( !red_o ), "unexpected color" );
        end
    end
endtask

task automatic clock();
  forever
    #( PERIOD_MS / 2 ) clk_2k = ( !clk_2k );
endtask

task automatic test();
  reset();

  // Test standard mode
  repeat( 100 )
    begin
      time red    = $urandom_range( 1, 100 ) * 1ms;
      time yellow = $urandom_range( 1, 100 ) * 1ms;
      time green  = $urandom_range( 1, 100 ) * 1ms;

      set_times(
        .red    ( red    ),
        .yellow ( yellow ),
        .green  ( green  )
      );
      listen_standard_mode(
        .red    ( red    ),
        .yellow ( yellow ),
        .green  ( green  )
      );
    end

  // Test manual mode
  set_manual();
  listen_manual_mode( 10 );
endtask

initial
  begin
    cmd_valid_i <= 1'b0;

    fork
      clock();
    join_none

    test();

    $display( "Tests Passed" );
    $stop;
  end

endmodule
