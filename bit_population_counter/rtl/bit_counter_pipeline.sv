module bit_counter_pipeline #(
  parameter int unsigned WIDTH,
  parameter int unsigned PIPELINE_SIZE,
  parameter int unsigned PIPELINE_OFFSET
)(
  input  logic                   clk_i,
  input  logic                   srst_i,

  input  logic [WIDTH-1:0]       data_i,
  input  logic                   data_val_i,
  input  logic [$clog2(WIDTH):0] count_i,

  output logic [WIDTH-1:0]       data_o,
  output logic                   data_val_o,
  output logic [$clog2(WIDTH):0] count_o
);

logic [$clog2(WIDTH):0] count;

always_comb
  begin
    count = count_i;
    for( int i = PIPELINE_OFFSET; i < ( PIPELINE_OFFSET + PIPELINE_SIZE ); i++ )
      count += data_i[i];
  end

always_ff @( posedge clk_i )
  data_o <= data_i;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_val_o <= 1'b0;
    else
      data_val_o <= data_val_i;
  end

always_ff @( posedge clk_i )
  count_o <= count;

endmodule
