/*
for (int j = 0; j < n - 1; j++)
{
  bool is_sorted = true;
  for (int i = 0; i < n - 1 - j; i++)
  {
    if (data[i] > data[i + 1])
    {
      swap(data[i], data[i+1]);
      is_sorted = false;
    }
  }

  if (is_sorted) break;
}
*/
module bubble_sort #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH
)(
  input  logic              clk_i,
  input  logic              srst_i,

  input  logic              enable_i,
  input  logic [AWIDTH-1:0] data_size_i,

  output logic [AWIDTH-1:0] a_addr_o,
  output logic              a_wr_en_o,
  output logic [DWIDTH-1:0] a_wr_data_o,
  input  logic [DWIDTH-1:0] a_rd_data_i,

  output logic [AWIDTH-1:0] b_addr_o,
  output logic              b_wr_en_o,
  output logic [DWIDTH-1:0] b_wr_data_o,
  input  logic [DWIDTH-1:0] b_rd_data_i,

  output logic              ready_o
);

logic [AWIDTH-1:0] n;
logic [AWIDTH-1:0] i;
logic [AWIDTH-1:0] j;

logic              delay;
logic              enable;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      delay <= 1'b1;
    else
      if( enable_i )
        delay <= ( delay ^ enable_i );
      else
        delay <= 1'b1;
  end

assign enable = ( enable_i && ( !delay ) );

// Indexing
assign n = data_size_i;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      i <= '0;
    else
      if( !ready_o )
        begin
          if( enable )
            begin
              if( i < ( n - 2'd2 - j ) )
                i <= ( i + 1'b1 );
              else
                i <= '0;
            end
        end
      else
        i <= '0;
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      j <= '0;
    else
      if( !ready_o )
        begin
          if( enable )
            begin
              if( i >= ( n - 2'd2 - j ) )
                j <= ( j + 1'b1 );
            end
        end
      else
        j <= '0;
  end

// Swap
assign a_addr_o    = i;
assign b_addr_o    = ( i + 1'b1 );

assign a_wr_data_o = b_rd_data_i;
assign b_wr_data_o = a_rd_data_i;

assign a_wr_en_o   = ( enable && ( !ready_o ) && ( a_rd_data_i > b_rd_data_i ) );
assign b_wr_en_o   = a_wr_en_o;

assign ready_o     = ( j >= ( n - 1'b1 ) );

endmodule
