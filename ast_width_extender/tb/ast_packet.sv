`ifndef AST_PACKET_H
`define AST_PACKET_H

class ast_packet #(
  parameter int unsigned CHANNEL_W
);
  localparam int unsigned CHANNEL_MAX = ( ( 2 ** CHANNEL_W ) - 1 );

  logic        [7:0]           data         [$];
  logic        [CHANNEL_W-1:0] channel;
  int unsigned                 write_chance; // Only makes sense at ast_src_driver

  function new(
    input logic        [CHANNEL_W-1:0] channel      = $urandom_range( 0, CHANNEL_MAX ),
    input int unsigned                 write_chance = 50
  );
    this.channel      = channel;
    this.write_chance = write_chance;
  endfunction

  function void randomize_data(
    input int unsigned data_size // In bytes
  );
    repeat( data_size )
      this.data.push_back( $urandom_range( 0, 255 ) );
  endfunction

  function void fill_data(
    input int unsigned data_size // In bytes
  );
    for( int unsigned i = 0; i < data_size; i++ )
      this.data.push_back( i );
  endfunction

  function ast_packet #( CHANNEL_W ) copy();
    ast_packet #( CHANNEL_W ) c = new( this.channel, this.write_chance );
    c.data = this.data;
    return c;
  endfunction
endclass

`endif
