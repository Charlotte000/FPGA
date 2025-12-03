module debouncer_top #(
  parameter int unsigned CLK_FREQ_MHZ   = 150,
  parameter int unsigned GLITCH_TIME_NS = 100
)(
  input  logic clk_150_mhz_i,
  input  logic key_i,
  output logic key_pressed_stb_o
);

logic key;
logic key_pressed_stb;

debouncer #(
  .CLK_FREQ_MHZ   ( CLK_FREQ_MHZ   ),
  .GLITCH_TIME_NS ( GLITCH_TIME_NS )
) debouncer_inst (
  .clk_i             ( clk_150_mhz_i   ),
  .key_i             ( key             ),
  .key_pressed_stb_o ( key_pressed_stb )
);

always_ff @( posedge clk_150_mhz_i )
  key <= key_i;

always_ff @( posedge clk_150_mhz_i )
  key_pressed_stb_o <= key_pressed_stb;

endmodule
