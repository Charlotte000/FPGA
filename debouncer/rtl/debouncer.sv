module debouncer #(
  parameter int unsigned CLK_FREQ_MHZ,
  parameter int unsigned GLITCH_TIME_NS
)(
  input  logic clk_i,
  input  logic key_i,
  output logic key_pressed_stb_o
);

localparam int unsigned GLITCH_CYCLES = ( CLK_FREQ_MHZ * GLITCH_TIME_NS / 1_000 );

logic          [1:0]                     key_buffer;
logic unsigned [$clog2(GLITCH_CYCLES):0] counter;

always_ff @( posedge clk_i )
  key_buffer <= ( ( key_buffer << 1 ) | key_i );

always_ff @( posedge clk_i )
  begin
    if( key_buffer[1] )
      counter <= '0;
    else
      if( counter <= GLITCH_CYCLES )
        counter <= ( counter + 1'b1 );
  end

assign key_pressed_stb_o = ( counter == GLITCH_CYCLES );

endmodule
