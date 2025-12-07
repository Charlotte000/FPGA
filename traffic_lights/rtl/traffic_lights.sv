import definitions_pkg::*;

module traffic_lights #(
  parameter int unsigned BLINK_HALF_PERIOD_MS,
  parameter int unsigned BLINK_GREEN_TIME_TICK,
  parameter int unsigned RED_YELLOW_MS
)(
  input  logic            clk_2k_i,
  input  logic            srst_i,

  input  command_e        cmd_type_i,
  input  logic            cmd_valid_i,
  input  logic     [15:0] cmd_data_i,

  output logic            red_o,
  output logic            yellow_o,
  output logic            green_o
);

localparam int unsigned CLK_FREQ_KHZ           = 2;
localparam int unsigned RED_YELLOW_MAX_CYCLES  = ( RED_YELLOW_MS * CLK_FREQ_KHZ );
localparam int unsigned BLINK_MAX_CYCLES       = ( BLINK_HALF_PERIOD_MS * 2 * CLK_FREQ_KHZ );
localparam int unsigned GREEN_BLINK_MAX_CYCLES = ( BLINK_MAX_CYCLES * BLINK_GREEN_TIME_TICK );

localparam int unsigned CYCLES_W               = ( 16 + $clog2( CLK_FREQ_KHZ ) );

state_e state, next_state;

logic [CYCLES_W:0] red_max_cycles;
logic [CYCLES_W:0] yellow_max_cycles;
logic [CYCLES_W:0] green_max_cycles;

logic [CYCLES_W:0]                       red_curr_cycles;
logic [CYCLES_W:0]                       yellow_curr_cycles;
logic [CYCLES_W:0]                       green_curr_cycles;
logic [$clog2(RED_YELLOW_MAX_CYCLES):0]  red_yellow_curr_cycles;
logic [$clog2(GREEN_BLINK_MAX_CYCLES):0] green_blink_cycles;

logic [$clog2(BLINK_MAX_CYCLES):0] blink_cycles;
logic                              blink_on;

// Red cycles
always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      red_max_cycles <= '0;
    else
      if( cmd_valid_i && ( cmd_type_i == SET_RED ) )
        red_max_cycles <= CYCLES_W'( cmd_data_i * CLK_FREQ_KHZ );
  end

always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      red_curr_cycles <= '0;
    else
      if( state == RED_S )
        red_curr_cycles <= ( red_curr_cycles + 1'b1 );
      else
        red_curr_cycles <= '0;
  end

// Red + yellow cycles
always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      red_yellow_curr_cycles <= '0;
    else
      if( state == RED_YELLOW_S )
        red_yellow_curr_cycles <= ( red_yellow_curr_cycles + 1'b1 );
      else
        red_yellow_curr_cycles <= '0;
  end

// Yellow cycles
always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      yellow_max_cycles <= '0;
    else
      if( cmd_valid_i && ( cmd_type_i == SET_YELLOW ) )
        yellow_max_cycles <= CYCLES_W'( cmd_data_i * CLK_FREQ_KHZ );
  end

always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      yellow_curr_cycles <= '0;
    else
      if( state == YELLOW_S )
        yellow_curr_cycles <= ( yellow_curr_cycles + 1'b1 );
      else
        yellow_curr_cycles <= '0;
  end

// Green cycles
always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      green_max_cycles <= '0;
    else
      if( cmd_valid_i && ( cmd_type_i == SET_GREEN ) )
        green_max_cycles <= CYCLES_W'( cmd_data_i * CLK_FREQ_KHZ );
  end

always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      green_curr_cycles <= '0;
    else
      if( state == GREEN_S )
        green_curr_cycles <= ( green_curr_cycles + 1'b1 );
      else
        green_curr_cycles <= '0;
  end

// Green blink cycles
always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      green_blink_cycles <= '0;
    else
      if( state == GREEN_BLINK_S )
        green_blink_cycles <= ( green_blink_cycles + 1'b1 );
      else
        green_blink_cycles <= '0;
  end

// Blink cycles
assign blink_on = ( blink_cycles < ( BLINK_MAX_CYCLES / 2 ) );

always_ff @( posedge clk_2k_i )
  begin
    if( srst_i )
      blink_cycles <= '0;
    else
      if( ( blink_cycles != ( BLINK_MAX_CYCLES - 1'b1 ) ) && ( ( state == MANUAL_S ) || ( state == GREEN_BLINK_S ) ) )
        blink_cycles <= ( blink_cycles + 1'b1 );
      else
        blink_cycles <= '0;
  end

// FSM
always_comb
  begin
    next_state = state;
    case( next_state )
      RED_S:
        begin
          if( red_curr_cycles == ( red_max_cycles - 1'b1 ) )
            next_state = RED_YELLOW_S;
        end
      RED_YELLOW_S:
        begin
          if( red_yellow_curr_cycles == ( RED_YELLOW_MAX_CYCLES - 1'b1 ) )
            next_state = GREEN_S;
        end
      GREEN_S:
        begin
          if( green_curr_cycles == ( green_max_cycles - 1'b1 ) )
            next_state = GREEN_BLINK_S;
        end
      GREEN_BLINK_S:
        begin
          if( green_blink_cycles == GREEN_BLINK_MAX_CYCLES - 1'b1 )
            next_state = YELLOW_S;
        end
      YELLOW_S:
        begin
          if( yellow_curr_cycles == ( yellow_max_cycles - 1'b1 ) )
            next_state = RED_S;
        end
      MANUAL_S:
        begin
          if( cmd_valid_i && ( cmd_type_i == SET_ON ) )
            next_state = RED_S;
        end
      OFF_S:
        begin
          if( cmd_valid_i && ( cmd_type_i == SET_ON ) )
            next_state = RED_S;
        end
      default:
          next_state = state;
    endcase

    if( cmd_valid_i && ( cmd_type_i == SET_OFF ) )
      next_state = OFF_S;

    if( cmd_valid_i && ( cmd_type_i == SET_MANUAL ) )
      next_state = MANUAL_S;
  end

always_ff @( posedge clk_2k_i )
  if( srst_i )
    state <= RED_S;
  else
    state <= next_state;

// Output
assign red_o    = ( ( state == RED_S ) || ( state == RED_YELLOW_S ) );

assign yellow_o = (
  ( state == RED_YELLOW_S )             ||
  ( state == YELLOW_S )                 ||
  ( ( state == MANUAL_S ) && blink_on )
);

assign green_o  = (
  ( state == GREEN_S )                       ||
  ( ( state == GREEN_BLINK_S ) && blink_on )
);

endmodule
