`ifndef AST_WE_PACKET_H
`define AST_WE_PACKET_H

class ast_we_packet #(
  parameter int unsigned CHANNEL_W
);
  localparam int unsigned CHANNEL_MAX = ( ( 2 ** CHANNEL_W ) - 1 );

  bit unsigned [7:0]           data         [$];
  bit unsigned [CHANNEL_W-1:0] channel;
  int unsigned                 write_chance; // Only makes sense at ast_we_tx_driver

  function new(
    input int unsigned                 data_size, // In bytes
    input bit unsigned [CHANNEL_W-1:0] channel      = $urandom_range( 0, CHANNEL_MAX ),
    input int unsigned                 write_chance = 50
  );
    this.channel      = channel;
    this.write_chance = write_chance;

    // Generate random data
    repeat( data_size )
      this.data.push_back( $urandom_range( 0, 255 ) );

    // Generate non-random data
    // for( int unsigned i = 0; i < data_size; i++ )
    //   this.data.push_back( i + 1 );
  endfunction

  function ast_we_packet #( CHANNEL_W ) copy();
    ast_we_packet #( CHANNEL_W ) c = new( 0, this.channel, this.write_chance );
    c.data = this.data;
    return c;
  endfunction
endclass

`endif
