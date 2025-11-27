module bit_population_counter_top #(
  parameter WIDTH     = 128,
  parameter PIPE_SIZE = 1
)(
  input  logic                   clk_150_mhz_i,
  input  logic                   srst_i,

  input  logic [WIDTH-1:0]       data_i,
  input  logic                   data_val_i,

  output logic [$clog2(WIDTH):0] data_o,
  output logic                   data_val_o
);

logic                   srst;
logic [WIDTH-1:0]       data;
logic                   data_val;
logic [$clog2(WIDTH):0] data_out;
logic                   data_val_out;

bit_population_counter #(
  .WIDTH     ( WIDTH     ),
  .PIPE_SIZE ( PIPE_SIZE )
) bit_counter_inst (
  .clk_i      ( clk_150_mhz_i ),
  .srst_i     ( srst          ),
  .data_i     ( data          ),
  .data_val_i ( data_val      ),
  .data_o     ( data_out      ),
  .data_val_o ( data_val_out  )
);

always_ff @( posedge clk_150_mhz_i )
  srst <= srst_i;

always_ff @( posedge clk_150_mhz_i )
  data <= data_i;

always_ff @( posedge clk_150_mhz_i )
  data_val <= data_val_i;

always_ff @( posedge clk_150_mhz_i )
  data_o <= data_out;

always_ff @( posedge clk_150_mhz_i )
  data_val_o <= data_val_out;

endmodule
