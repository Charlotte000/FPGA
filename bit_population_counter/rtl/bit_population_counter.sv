module bit_population_counter #(
  parameter int unsigned WIDTH,
  parameter int unsigned PIPELINE_SIZE
)(
  input  logic                   clk_i,
  input  logic                   srst_i,

  input  logic [WIDTH-1:0]       data_i,
  input  logic                   data_val_i,

  output logic [$clog2(WIDTH):0] data_o,
  output logic                   data_val_o
);

localparam int unsigned PIPELINE_COUNT = ( WIDTH / PIPELINE_SIZE );

logic [PIPELINE_COUNT:0][WIDTH-1:0]       pipeline_data;
logic [PIPELINE_COUNT:0]                  pipeline_data_val;
logic [PIPELINE_COUNT:0][$clog2(WIDTH):0] pipeline_count;

int   pipeline_counter;
logic pipeline_ready;

genvar i;
generate
  for( i = 0; i < PIPELINE_COUNT; i++ )
    begin : pipeline_generator
      bit_counter_pipeline #(
        .WIDTH           ( WIDTH             ),
        .PIPELINE_SIZE   ( PIPELINE_SIZE     ),
        .PIPELINE_OFFSET ( i * PIPELINE_SIZE )
      ) bit_counter_pipeline_inst (
        .clk_i      ( clk_i                  ),
        .data_i     ( pipeline_data[i]       ),
        .data_val_i ( pipeline_data_val[i]   ),
        .count_i    ( pipeline_count[i]      ),
        .data_o     ( pipeline_data[i+1]     ),
        .data_val_o ( pipeline_data_val[i+1] ),
        .count_o    ( pipeline_count[i+1]    )
      );
    end
endgenerate

assign pipeline_ready = ( pipeline_counter >= PIPELINE_COUNT );

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      pipeline_counter <= '0;
    else
      pipeline_counter <= ( pipeline_counter + 1 );
  end

assign pipeline_data[0] = data_i;

assign pipeline_data_val[0] = data_val_i;

assign data_o = pipeline_count[PIPELINE_COUNT];

assign data_val_o = ( pipeline_ready && pipeline_data_val[PIPELINE_COUNT] );

assign pipeline_count[0] = '0;

endmodule
