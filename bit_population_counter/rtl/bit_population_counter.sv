module bit_population_counter #(
  parameter WIDTH = 16
)(
  input  logic                   clk_i,
  input  logic                   srst_i,

  input  logic [WIDTH-1:0]       data_i,
  input  logic                   data_val_i,

  output logic [$clog2(WIDTH):0] data_o,
  output logic                   data_val_o
);

always_ff @( posedge clk_i )
  begin
    data_val_o <= ( ( !srst_i ) & data_val_i );
  end

always_comb
  begin
    data_o = '0;

    for( int i = 0; i < WIDTH; i++ )
      data_o += data_i[i];
  end

endmodule
