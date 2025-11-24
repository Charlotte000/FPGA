module priority_encoder #(
    parameter WIDTH = 4
)(
  input  logic             clk_i,
  input  logic             srst_i,

  input  logic [WIDTH-1:0] data_i,
  input  logic             data_val_i,

  output logic [WIDTH-1:0] data_left_o,
  output logic [WIDTH-1:0] data_right_o,

  output logic             data_val_o
);

logic [WIDTH-1:0] data_buffer;

always_ff @( posedge clk_i )
  begin
    if( data_val_i )
      data_buffer <= data_i;
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_val_o <= 0;
    else
      data_val_o <= data_val_i;
  end

always_comb
  begin
    data_left_o = '0;
    for( int i = ( WIDTH - 1 ); i >= 0; i-- )
      begin
        if( data_buffer[i] )
          begin
            data_left_o = ( ( WIDTH'( 1 ) ) << i );
            break;
          end
      end
  end

always_comb
  begin
    data_right_o = '0;
    for( int i = 0; i <= ( WIDTH - 1 ); i++ )
      begin
        if( data_buffer[i] )
          begin
            data_right_o = ( ( WIDTH'( 1 ) ) << i );
            break;
          end
      end
  end

endmodule
