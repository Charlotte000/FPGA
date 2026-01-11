`ifndef AST_WE_PACKET_H
`define AST_WE_PACKET_H

class ast_we_packet #(
  parameter int unsigned CHANNEL_W,
  parameter int unsigned EMPTY_W
);
  localparam int unsigned CHANNEL_MAX = ( ( 2 ** CHANNEL_W ) - 1 );
  localparam int unsigned EMPTY_MAX   = ( ( 2 ** EMPTY_W )   - 1 );

  bit unsigned                 data    [$];
  bit unsigned [EMPTY_W-1:0]   empty;
  bit unsigned [CHANNEL_W-1:0] channel;

  function new(
    input int unsigned                 data_size,
    input bit unsigned [EMPTY_W-1:0]   empty     = $urandom_range( 0, EMPTY_MAX   ),
    input bit unsigned [CHANNEL_W-1:0] channel   = $urandom_range( 0, CHANNEL_MAX )
  );
    this.empty   = empty;
    this.channel = channel;

    repeat( data_size )
      this.data.push_back( $urandom_range( 0, 1 ) );

    // for( int unsigned i = 0; i < data_size / 64; i++ )
    //   this.data = {>>{ this.data, 64'( i ) }};

  endfunction
endclass

`endif
