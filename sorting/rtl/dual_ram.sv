module dual_ram #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH,
  parameter int unsigned NUM_WORDS = ( 2 ** AWIDTH )
)(
  input  logic              clk_i,

  input  logic [AWIDTH-1:0] a_addr_i,
  input  logic              a_wr_en_i,
  input  logic [DWIDTH-1:0] a_wr_data_i,
  output logic [DWIDTH-1:0] a_rd_data_o,

  input  logic [AWIDTH-1:0] b_addr_i,
  input  logic              b_wr_en_i,
  input  logic [DWIDTH-1:0] b_wr_data_i,
  output logic [DWIDTH-1:0] b_rd_data_o
);

logic [DWIDTH-1:0] memory [NUM_WORDS-1:0];

// A
always_ff @( posedge clk_i )
  begin
    if( a_wr_en_i )
      begin
        memory[a_addr_i] <= a_wr_data_i;
        a_rd_data_o      <= a_wr_data_i;
      end
    else
      a_rd_data_o <= memory[a_addr_i];
  end

// B
always_ff @( posedge clk_i )
  begin
    if( b_wr_en_i )
      begin
        memory[b_addr_i] <= b_wr_data_i;
        b_rd_data_o      <= b_wr_data_i;
      end
    else
      b_rd_data_o <= memory[b_addr_i];
  end

endmodule
