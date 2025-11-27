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

logic [WIDTH-1:0]           pipe_data_i;
logic [$clog2(PIPE_SIZE):0] pipe_data_o;
int                         pipe_offset;
logic                       pipe_busy;
logic                       pipe_done;

always_ff @( posedge clk_i )
  begin
    if( data_val_i )
      pipe_data_i <= data_i;
  end

always_comb
  begin
    pipe_data_o = '0;
    for( int i = 0; i < PIPE_SIZE; i++ )
      pipe_data_o += pipe_data_i[i + pipe_offset];
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      pipe_offset <= 0;
    else
      if( data_val_i || pipe_done )
        pipe_offset <= 0;
      else
        pipe_offset <= ( pipe_offset + PIPE_SIZE );
  end

assign pipe_busy = ( pipe_offset > 0 ) && ( !pipe_done );

assign pipe_done = ( pipe_offset >= WIDTH );

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_o <= '0;
    else
      if( data_val_i || pipe_done )
        data_o <= '0;
      else
        data_o <= ( data_o + pipe_data_o );
  end

assign data_val_o = pipe_done;

endmodule
