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

task automatic reset();
  data_buffer  <= 0;
  counter_curr <= 0;
  counter_max  <= 0;
  busy         <= 0;
endtask

task automatic init_transmit();
  data_buffer  <= data_i;
  counter_curr <= 1;
  counter_max  <= ( data_mod_i - 1 ); // 4'b0000 - 1 = 4'b1111
  busy         <= !( ( MOD_IGNORE_LO <= data_mod_i ) && ( data_mod_i <= MOD_IGNORE_HI ) );
endtask

task automatic transmit();
  if( busy && ( counter_curr <= counter_max ) )
    begin
      counter_curr <= ( counter_curr + 1 );
      data_buffer  <= ( data_buffer << 1 );
    end
  else
    busy   <= 0;
endtask

assign ser_data_o     = data_buffer[15];
assign ser_data_val_o = busy;
assign busy_o         = busy;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      reset();
    else
      if( data_val_i )
        init_transmit();
      else
        transmit();
  end

endmodule
