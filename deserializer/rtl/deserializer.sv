module deserializer #(
  parameter DATA_W = 16
)(
  input  logic              clk_i,
  input  logic              srst_i,

  input  logic              data_i,
  input  logic              data_val_i,

  output logic [DATA_W-1:0] deser_data_o,
  output logic              deser_data_val_o
);

localparam COUNTER_W = $clog2(DATA_W);

logic [COUNTER_W-1:0] counter;
logic                 counter_end;
logic [DATA_W-1:0]    data_buffer;

assign counter_end = ( counter == ( DATA_W - 1 ) );

assign deser_data_o = data_buffer;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_buffer <= '0;
    else
      if( data_val_i )
        data_buffer <= ( ( data_buffer << 1 ) | data_i );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      counter <= '0;
    else
      if( data_val_i )
        if( !counter_end )
          counter <= COUNTER_W'( counter + 1 );
        else
          counter <= 0;
  end

always_ff @( posedge clk_i )
  begin
    if( data_val_i && counter_end )
      deser_data_val_o <= 1;
    else
      deser_data_val_o <= 0;
  end

endmodule
