`include "ast_we_packet.sv"
`include "ast_we_tx_driver.sv"

class ast_we_generator #(
  parameter int unsigned DATA_IN_W,
  parameter int unsigned EMPTY_IN_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DATA_OUT_W,
  parameter int unsigned EMPTY_OUT_W
);
  localparam int unsigned MAX_PACKET_LENGTH = 65536; // In bytes

  localparam int unsigned DATA_IN_MAX  = ( ( 2 ** DATA_IN_W  ) - 1 );
  localparam int unsigned EMPTY_IN_MAX = ( ( 2 ** EMPTY_IN_W ) - 1 );
  localparam int unsigned CHANNEL_MAX  = ( ( 2 ** CHANNEL_W  ) - 1 );

  mailbox #( ast_we_packet #( CHANNEL_W ) ) mbx; // Need for ast_we_monitor

  local ast_we_tx_driver #(
    .DATA_IN_W   ( DATA_IN_W   ),
    .EMPTY_IN_W  ( EMPTY_IN_W  ),
    .CHANNEL_W   ( CHANNEL_W   ),
    .DATA_OUT_W  ( DATA_OUT_W  ),
    .EMPTY_OUT_W ( EMPTY_OUT_W )
  ) driver;

  local virtual ast_we_if #(
    .DATA_IN_W   ( DATA_IN_W   ),
    .EMPTY_IN_W  ( EMPTY_IN_W  ),
    .CHANNEL_W   ( CHANNEL_W   ),
    .DATA_OUT_W  ( DATA_OUT_W  ),
    .EMPTY_OUT_W ( EMPTY_OUT_W )
  ).tx _if;

  function new(
    input virtual ast_we_if #(
      .DATA_IN_W   ( DATA_IN_W   ),
      .EMPTY_IN_W  ( EMPTY_IN_W  ),
      .CHANNEL_W   ( CHANNEL_W   ),
      .DATA_OUT_W  ( DATA_OUT_W  ),
      .EMPTY_OUT_W ( EMPTY_OUT_W )
    ).tx _if
  );
    this.mbx    = new();
    this.driver = new( _if );
    this._if    = _if;
  endfunction

  local task send( input ast_we_packet #( CHANNEL_W ) packet );
    this.mbx.put( packet.copy() );
    this.driver.tx( packet.copy() );
  endtask

  task start_send_ready( input int unsigned src_ready_chance );
    forever
      begin
        this._if.src_ready <= ( $urandom_range( 0, 100 ) <= src_ready_chance );
        @( posedge this._if.clk );
      end
  endtask

  task send_different_lengths();
    ast_we_packet #( CHANNEL_W ) packet;

    for( int unsigned length = MAX_PACKET_LENGTH; length >= ( MAX_PACKET_LENGTH - 50 ); length-- )
      begin
        packet = new(
          .data_size    ( length ),
          .write_chance ( 50     )
        );
        this.send( packet );
      end

    for( int unsigned length = 50; length >= 1; length-- )
      begin
        packet = new(
          .data_size    ( length ),
          .write_chance ( 50     )
        );
        this.send( packet );
      end
  endtask

  task send_random( input int unsigned per_count = 100 );
    ast_we_packet #( CHANNEL_W ) packet;

    for( int unsigned write_chance = 25; write_chance <= 100; write_chance += 25 ) // write_chance = [ 25, 50, 75, 100 ]
      repeat( per_count )
        begin
          packet = new(
            .data_size    ( $urandom_range( 9, 100 ) ),
            .write_chance ( write_chance             )
          );
          this.send( packet );
        end
  endtask

  task send_same_channel(
    input int unsigned count   = 1000,
    input int unsigned channel = 1
  );
    ast_we_packet #( CHANNEL_W ) packet;

    repeat( count )
      begin
        packet = new(
          .data_size    ( $urandom_range( 9, 100 )  ),
          .channel      ( ( CHANNEL_W )'( channel ) ),
          .write_chance ( 50                        )
        );
        this.send( packet );
      end
  endtask

  task send_gibberish( input int unsigned count = 100 );
    repeat( count )
      begin
        this._if.snk_data          <= $urandom_range( 0, DATA_IN_MAX  );
        this._if.snk_startofpacket <= $urandom_range( 0, 1 );
        this._if.snk_endofpacket   <= $urandom_range( 0, 1 );
        this._if.snk_valid         <= 1'b0;
        this._if.snk_empty         <= $urandom_range( 0, EMPTY_IN_MAX );
        this._if.snk_channel       <= $urandom_range( 0, CHANNEL_MAX  );
        @( posedge this._if.clk );
      end
  endtask
endclass
