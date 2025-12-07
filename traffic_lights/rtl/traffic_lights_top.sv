import definitions_pkg::*;

module traffic_lights_top #(
  parameter int unsigned BLINK_HALF_PERIOD_MS  = 1000,
  parameter int unsigned BLINK_GREEN_TIME_TICK = 5,
  parameter int unsigned RED_YELLOW_MS         = 2000
)(
  input  logic        clk_2k_i,
  input  logic        srst_i,

  input  command_e    cmd_type_i,
  input  logic        cmd_valid_i,
  input  logic [15:0] cmd_data_i,

  output logic        red_o,
  output logic        yellow_o,
  output logic        green_o
);

logic        srst;
command_e    cmd_type;
logic        cmd_valid;
logic [15:0] cmd_data;
logic        red;
logic        yellow;
logic        green;

traffic_lights #(
  .BLINK_HALF_PERIOD_MS  ( BLINK_HALF_PERIOD_MS  ),
  .BLINK_GREEN_TIME_TICK ( BLINK_GREEN_TIME_TICK ),
  .RED_YELLOW_MS         ( RED_YELLOW_MS )
) traffic_lights_inst (
  .clk_2k_i    ( clk_2k_i  ),
  .srst_i      ( srst      ),
  .cmd_type_i  ( cmd_type  ),
  .cmd_valid_i ( cmd_valid ),
  .cmd_data_i  ( cmd_data  ),
  .red_o       ( red       ),
  .yellow_o    ( yellow    ),
  .green_o     ( green     )
);

always_ff @( posedge clk_2k_i )
  srst <= srst_i;

always_ff @( posedge clk_2k_i )
  cmd_type <= cmd_type_i;

always_ff @( posedge clk_2k_i )
  cmd_valid <= cmd_valid_i;

always_ff @( posedge clk_2k_i )
  cmd_data <= cmd_data_i;

always_ff @( posedge clk_2k_i )
  red_o <= red;

always_ff @( posedge clk_2k_i )
  yellow_o <= yellow;

always_ff @( posedge clk_2k_i )
  green_o <= green;

endmodule
