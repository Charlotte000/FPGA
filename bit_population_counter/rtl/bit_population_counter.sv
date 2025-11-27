module bit_population_counter #(
  parameter WIDTH,
  parameter PIPE_SIZE
)(
  input  logic                   clk_i,
  input  logic                   srst_i,

  input  logic [WIDTH-1:0]       data_i,
  input  logic                   data_val_i,

  output logic [$clog2(WIDTH):0] data_o,
  output logic                   data_val_o
);

logic [$clog2(PIPE_SIZE):0] pipe_data_o;
int                         pipe_offset;
logic                       pipe_ready;

always_comb
  begin
    pipe_data_o = '0;
    for( int i = 0; i < PIPE_SIZE; i++ )
      pipe_data_o += data_i[i + pipe_offset];
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      pipe_offset <= 0;
    else
      if( pipe_ready )
        pipe_offset <= 0;
      else
        pipe_offset <= ( pipe_offset + PIPE_SIZE );
  end

assign pipe_ready = pipe_offset >= WIDTH;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_o <= '0;
    else
      if( pipe_ready )
        data_o <= 0;
      else
        data_o <= ( data_o + pipe_data_o );
  end

assign data_val_o = pipe_ready;

endmodule
