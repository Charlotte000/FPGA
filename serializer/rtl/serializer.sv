module serializer #(
  parameter DATA_W        = 16,
  parameter MOD_W         = $clog2(DATA_W),
  parameter MOD_IGNORE_LO = 1,
  parameter MOD_IGNORE_HI = 2
)(
  input  logic              clk_i,
  input  logic              srst_i,

  input  logic [DATA_W-1:0] data_i,
  input  logic [MOD_W-1:0]  data_mod_i,
  input  logic              data_val_i,

  output logic              ser_data_o,
  output logic              ser_data_val_o,

  output logic              busy_o
);

logic [DATA_W-1:0] data_buffer;
logic [MOD_W:0]    counter_curr;
logic [MOD_W-1:0]  counter_max;
logic              busy;
logic              counter_avail;

assign ser_data_o     = data_buffer[15];

assign ser_data_val_o = busy;

assign busy_o         = busy;

assign counter_avail  = counter_curr <= counter_max;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      data_buffer <= 0;
    else
      if( data_val_i )
        data_buffer <= data_i;
      else
        if( busy && counter_avail )
          data_buffer <= ( data_buffer << 1 );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      counter_curr <= 0;
    else
      if( data_val_i )
        counter_curr <= 1;
      else
        if( busy && counter_avail )
          counter_curr <= ( counter_curr + 1 );
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      counter_max <= 0;
    else
      if( data_val_i )
        counter_max  <= ( data_mod_i - 1 ); // 4'b0000 - 1 = 4'b1111
  end

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      busy <= 0;
    else
      if( data_val_i )
        busy <= !( ( MOD_IGNORE_LO <= data_mod_i ) && ( data_mod_i <= MOD_IGNORE_HI ) );
      else
        if( !( busy && counter_avail ) )
          busy <= 0;
  end

endmodule
