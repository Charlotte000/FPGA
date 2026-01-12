`include "ast_we_packet.sv"

class ast_we_generator #(
  parameter int unsigned DATA_IN_W,
  parameter int unsigned EMPTY_IN_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DATA_OUT_W,
  parameter int unsigned EMPTY_OUT_W
);
  localparam int unsigned DATA_IN_MAX       = ( ( 2 ** DATA_IN_W ) - 1  );
  localparam int unsigned EMPTY_IN_MAX      = ( ( 2 ** EMPTY_IN_W ) - 1 );
  localparam int unsigned CHANNEL_MAX       = ( ( 2 ** CHANNEL_W ) - 1  );

  local virtual ast_we_if #(
    .DATA_IN_W   ( DATA_IN_W   ),
    .EMPTY_IN_W  ( EMPTY_IN_W  ),
    .CHANNEL_W   ( CHANNEL_W   ),
    .DATA_OUT_W  ( DATA_OUT_W  ),
    .EMPTY_OUT_W ( EMPTY_OUT_W )
  ).generator _if;

  local mailbox #(
    ast_we_packet #(
      .CHANNEL_W ( CHANNEL_W  ),
      .EMPTY_W   ( EMPTY_IN_W )
    )
  ) mbx;

  function new(
    input virtual ast_we_if #(
      .DATA_IN_W   ( DATA_IN_W   ),
      .EMPTY_IN_W  ( EMPTY_IN_W  ),
      .CHANNEL_W   ( CHANNEL_W   ),
      .DATA_OUT_W  ( DATA_OUT_W  ),
      .EMPTY_OUT_W ( EMPTY_OUT_W )
    ).generator _if,
    input mailbox #(
      ast_we_packet #(
        .CHANNEL_W ( CHANNEL_W  ),
        .EMPTY_W   ( EMPTY_IN_W )
      )
    ) mbx
  );
    this._if = _if;
    this.mbx = mbx;
  endfunction

  function void reset();
    this._if.snk_data          <= 'x;
    this._if.snk_startofpacket <= 'x;
    this._if.snk_endofpacket   <= 'x;
    this._if.snk_valid         <= 1'b0;
    this._if.snk_empty         <= 'x;
    this._if.snk_channel       <= 'x;
  endfunction

  task send_packet(
    input ast_we_packet #(
      .CHANNEL_W ( CHANNEL_W  ),
      .EMPTY_W   ( EMPTY_IN_W )
    ) packet,
    input int unsigned write_chance
  );
    int unsigned data_size = ( packet.data.size() / DATA_IN_W );
    int unsigned i         = 0;
    while( i < data_size )
      begin
        if( this._if.snk_ready && ( $urandom_range(1, 100) <= write_chance ) )
          begin
            this._if.snk_data          <= { >>{ packet.data with [i*DATA_IN_W +: DATA_IN_W] } };
            this._if.snk_startofpacket <= ( i == 0 );
            this._if.snk_endofpacket   <= ( i == ( data_size - 1 ) );
            this._if.snk_valid         <= 1'b1;
            this._if.snk_empty         <= ( i == ( data_size - 1 ) ) ? ( packet.empty ) : ( '0 ); // empty   only at eop
            this._if.snk_channel       <= ( i == 0 ) ? ( packet.channel ) : ( '0 );               // channel only at sop
            i++;
          end
        else
          this.reset();

        @( posedge this._if.clk );
      end

    this.reset();
    this.mbx.put( packet );
  endtask

  task send_random(
    input int unsigned count,
    input int unsigned write_chance
  );
    repeat( count )
      begin
        ast_we_packet #(
          .CHANNEL_W ( CHANNEL_W  ),
          .EMPTY_W   ( EMPTY_IN_W )
        ) packet = new( DATA_IN_W * $urandom_range( 1, 100 ) );
        this.send_packet( packet, write_chance );
      end
  endtask

  task send_gibberish( input int unsigned count );
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

    this.reset();
  endtask

  task send_timeout( input int unsigned count );
    repeat( count )
      begin
        this.reset();
        @( posedge this._if.clk );
      end
  endtask
endclass
