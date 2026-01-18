class ast_dmx_packet #(
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DIR_SEL_W
);
  localparam int unsigned CHANNEL_MAX = ( ( 2 ** CHANNEL_W ) - 1 );
  localparam int unsigned DIR_SEL_MAX = ( ( 2 ** DIR_SEL_W ) - 1 );

  logic        [7:0]           data         [$];
  logic        [CHANNEL_W-1:0] channel;
  logic        [DIR_SEL_W-1:0] dir;
  int unsigned                 write_chance; // Only makes sense at ast_dmx_driver

  function new(
    input logic        [CHANNEL_W-1:0] channel      = $urandom_range( 0, CHANNEL_MAX ),
    input logic        [DIR_SEL_W-1:0] dir          = $urandom_range( 0, DIR_SEL_MAX ),
    input int unsigned                 write_chance = 50
  );
    this.channel      = channel;
    this.dir          = dir;
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

  function ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) copy();
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) c = new( this.channel, this.dir, this.write_chance );
    c.data = this.data;
    return c;
  endfunction
endclass
