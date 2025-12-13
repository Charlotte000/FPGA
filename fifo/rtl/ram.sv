module ram #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH
)(
  input  logic              clk_i,

  input                     wr_en_i,
  input  logic [AWIDTH-1:0] wr_addr_i,
  input  logic [DWIDTH-1:0] wr_data_i,

  input                     rd_en_i,
  input  logic [AWIDTH-1:0] rd_addr_i,
  output logic [DWIDTH-1:0] rd_data_o
);

localparam int unsigned NUM_WORDS = ( 2 ** AWIDTH );

logic [DWIDTH-1:0] memory [NUM_WORDS-1:0];

// Read
always_ff @( posedge clk_i )
  begin
    if( rd_en_i )
      rd_data_o <= memory[rd_addr_i];
  end

// Write
always_ff @( posedge clk_i )
  begin
    if( wr_en_i )
      memory[wr_addr_i] <= wr_data_i;
  end

endmodule
