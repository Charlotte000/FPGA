`include "ast_packet.sv"
`include "ast_src_driver.sv"

class ast_generator #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W
);
  localparam int unsigned MAX_PACKET_LENGTH = 65536; // In bytes

  mailbox #( ast_packet #( CHANNEL_W ) ) mbx; // Need for ast_we_monitor

  local ast_src_driver #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W )
  ) driver;

  function new(
    input virtual ast_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ).src _if
  );
    this.mbx    = new();
    this.driver = new( _if );
  endfunction

  local task send( input ast_packet #( CHANNEL_W ) packet );
    this.mbx.put( packet.copy() );
    this.driver.send_packet( packet.copy() );
  endtask

  task send_different_lengths();
    ast_packet #( CHANNEL_W ) packet;

    for( int unsigned length = MAX_PACKET_LENGTH; length >= ( MAX_PACKET_LENGTH - 50 ); length-- )
      begin
        packet = new();
        packet.randomize_data( length );
        this.send( packet );
      end

    for( int unsigned length = 50; length >= 1; length-- )
      begin
        packet = new();
        packet.randomize_data( length );
        this.send( packet );
      end
  endtask

  task send_random( input int unsigned per_count = 100 );
    ast_packet #( CHANNEL_W ) packet;

    for( int unsigned write_chance = 25; write_chance <= 100; write_chance += 25 ) // write_chance = { 25, 50, 75, 100 }
      repeat( per_count )
        begin
          packet = new( .write_chance ( write_chance ) );
          packet.randomize_data( $urandom_range( 9, 100 ) );
          this.send( packet );
        end
  endtask

  task send_same_channel(
    input int unsigned count   = 1000,
    input int unsigned channel = 1
  );
    ast_packet #( CHANNEL_W ) packet;

    repeat( count )
      begin
        packet = new( .channel ( ( CHANNEL_W )'( channel ) ) );
        packet.randomize_data( $urandom_range( 9, 100 ) );
        this.send( packet );
      end
  endtask

  task send_gibberish( input int unsigned count = 100 );
    this.driver.send_gibberish( count );
  endtask
endclass
