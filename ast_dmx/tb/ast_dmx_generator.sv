class ast_dmx_generator #(
  parameter int unsigned DATA_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DIR_SEL_W
);
  localparam int unsigned MAX_PACKET_LENGTH = 65536; // In bytes
  localparam int unsigned DIR_SEL_MAX       = ( ( 2 ** DIR_SEL_W ) - 1 );

  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) gen2drv;

  function new(
    input mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) gen2drv
  );
    this.gen2drv = gen2drv;
  endfunction

  task send_different_lengths();
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet;

    for( int unsigned dir = 0; dir <= DIR_SEL_MAX; dir++ )
      begin
        for( int unsigned length = MAX_PACKET_LENGTH; length >= ( MAX_PACKET_LENGTH - 4 ); length-- )
          begin
            packet = new( .dir ( dir ) );
            packet.randomize_data( length );
            this.gen2drv.put( packet );
          end

        for( int unsigned length = 5; length >= 1; length-- )
          begin
            packet = new( .dir ( dir ) );
            packet.randomize_data( length );
            this.gen2drv.put( packet );
          end
      end
  endtask

  task send_zero_empty( input int unsigned count = 100 );
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet;

    for( int unsigned dir = 0; dir <= DIR_SEL_MAX; dir++ )
      begin
        repeat( count )
          begin
            packet = new( .dir ( dir ) );
            packet.randomize_data( $urandom_range( 1, 100 ) * ( DATA_W / 8 ) );
            this.gen2drv.put( packet );
          end
      end
  endtask

  task send_non_zero_empty( input int unsigned count = 100 );
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet;

    for( int unsigned dir = 0; dir <= DIR_SEL_MAX; dir++ )
      begin
        repeat( count )
          begin
            packet = new( .dir ( dir ) );
            packet.randomize_data( ( $urandom_range( 1, 100 ) * DATA_W / 8 ) + $urandom_range( 1, ( ( DATA_W / 8 ) - 1 ) ) );
            this.gen2drv.put( packet );
          end
      end
  endtask

  task send_random( input int unsigned per_count = 100 );
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet;

    for( int unsigned write_chance = 25; write_chance <= 100; write_chance += 25 ) // write_chance = { 25, 50, 75, 100 }
      repeat( per_count )
        begin
          packet = new( .write_chance ( write_chance ) );
          packet.randomize_data( $urandom_range( 9, 100 ) );
          this.gen2drv.put( packet );
        end
  endtask

  task send_same_channel(
    input int unsigned                 count   = 100,
    input bit          [CHANNEL_W-1:0] channel = 1
  );
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet;

    for( int unsigned dir = 0; dir <= DIR_SEL_MAX; dir++ )
      begin
        repeat( count )
          begin
            packet = new( .channel ( channel ), .dir ( dir ) );
            packet.randomize_data( $urandom_range( 9, 100 ) );
            this.gen2drv.put( packet );
          end
      end
  endtask
endclass
