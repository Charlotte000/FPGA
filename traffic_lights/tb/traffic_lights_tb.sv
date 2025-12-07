`timescale 1ms/10us

module traffic_lights_tb #(
  parameter int unsigned BLINK_HALF_PERIOD_MS  = 1,
  parameter int unsigned BLINK_GREEN_TIME_TICK = 4,
  parameter int unsigned RED_YELLOW_MS         = 7
);

import definitions_pkg::*;

localparam int unsigned FREQUENCY_KHZ = 2;
localparam real         PERIOD_MS     = ( 1.0 / FREQUENCY_KHZ );

bit          clk_2k;
bit          srst_i;
command_e    cmd_type_i;
logic        cmd_valid_i;
logic [15:0] cmd_data_i;
logic        red_o;
logic        yellow_o;
logic        green_o;

time         red_time;
time         yellow_time;
time         green_time;

state_e      state;

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
    $error( "Test Failed: %s", err_msg );
    // $stop;
endtask

task automatic reset();
  srst_i <= 1'b1;
  @( posedge clk_2k );
  srst_i <= 1'b0;
  state  <= RED_S;
endtask

task automatic set_times(
  input logic [15:0] red,
  input logic [15:0] yellow,
  input logic [15:0] green
);
  cmd_valid_i <= 1'b1;

  // Set MANUAL mode
  cmd_type_i  <= SET_MANUAL;
  @( posedge clk_2k );
  state       <= MANUAL_S;

  // Set red time
  cmd_type_i <= SET_RED;
  cmd_data_i <= red;
  red_time   <= red;
  @( posedge clk_2k );

  // Set yellow time
  cmd_type_i  <= SET_YELLOW;
  cmd_data_i  <= yellow;
  yellow_time <= yellow;
  @( posedge clk_2k );

  // Set green time
  cmd_type_i <= SET_GREEN;
  cmd_data_i <= green;
  green_time <= green;
  @( posedge clk_2k );

  // Set ON mode
  cmd_type_i <= SET_ON;
  @( posedge clk_2k );

  cmd_valid_i <= 1'b0;
  cmd_type_i  <= command_e'('x);
  cmd_data_i  <= 'x;

  state       <= RED_S;
endtask

task automatic clock();
  forever
    #( PERIOD_MS / 2 ) clk_2k = ( !clk_2k );
endtask

task automatic send();
  reset();

  set_times(
    .red    ( 16'd10 ),
    .yellow ( 16'd10 ),
    .green  ( 16'd10 )
  );

  repeat( 100 ) @( posedge clk_2k );

  // Stop
  disable test_threads;
endtask

task automatic listen();
  time red_last, yellow_last, green_last;
  state_e prev_state;
  forever
    begin
      prev_state = state;
      @( posedge clk_2k );

      if( state != prev_state )
        begin
          case( state )
            RED_S:
              red_last    = $time;
            YELLOW_S:
              yellow_last = $time;
            GREEN_S:
              green_last  = $time;
          endcase
        end

      case( state )
        RED_S:
          begin
            check( ( !green_o ) && ( !yellow_o ) && (  red_o ), "unexpected color" );
            check( ( $time - red_last ) < red_time,             "unexpected timing" );
          end
        RED_YELLOW_S:
          begin
            check( ( !green_o ) && (  yellow_o ) && (  red_o ), "unexpected color" );
          end
        GREEN_S:
          begin
            check( (  green_o ) && (  yellow_o ) && ( !red_o ), "unexpected color" );
            check( ( $time - green_last ) < green_time,         "unexpected timing" );
          end
        GREEN_BLINK_S:
          begin
            check( (  green_o ) && ( !yellow_o ) && ( !red_o ), "unexpected color" );
          end
        YELLOW_S:
          begin
            check( ( !green_o ) && (  yellow_o ) && ( !red_o ), "unexpected color" );
            check( ( $time - yellow_last ) < yellow_last,       "unexpected timing" );
          end
        MANUAL_S:
          begin
            check( ( !green_o ) && (  yellow_o ) && ( !red_o ), "unexpected color" );
          end
        OFF_S:
          begin
            check( ( !green_o ) && ( !yellow_o ) && ( !red_o ), "unexpected color" );
          end
      endcase
    end
endtask

initial
  begin
    cmd_valid_i <= 1'b0;

    fork : test_threads
      clock();
      send();
      listen();
    join

    $display( "Tests Passed" );
  end

endmodule
