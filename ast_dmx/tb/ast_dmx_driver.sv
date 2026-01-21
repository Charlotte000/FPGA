class ast_dmx_driver #(
  parameter int unsigned DATA_W,
  parameter int unsigned EMPTY_W,
  parameter int unsigned CHANNEL_W,
  parameter int unsigned DIR_SEL_W
);
  localparam int unsigned DATA_MAX    = ( ( 2 ** DATA_W    ) - 1 );
  localparam int unsigned EMPTY_MAX   = ( ( 2 ** EMPTY_W   ) - 1 );
  localparam int unsigned CHANNEL_MAX = ( ( 2 ** CHANNEL_W ) - 1 );
  localparam int unsigned DIR_SEL_MAX = ( ( 2 ** DIR_SEL_W ) - 1 );

  local virtual ast_dmx_dir_if #( DIR_SEL_W ) _if_dir;
  local virtual ast_dmx_if #(
    .DATA_W    ( DATA_W    ),
    .EMPTY_W   ( EMPTY_W   ),
    .CHANNEL_W ( CHANNEL_W )
  ) _if;

  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) gen2drv;
  local mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) drv2scb;

  function new(
    input virtual ast_dmx_dir_if #( DIR_SEL_W ) _if_dir,
    input virtual ast_dmx_if #(
      .DATA_W    ( DATA_W    ),
      .EMPTY_W   ( EMPTY_W   ),
      .CHANNEL_W ( CHANNEL_W )
    ) _if,
    input mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) gen2drv,
    input mailbox #( ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) ) drv2scb
  );
    this._if_dir = _if_dir;
    this._if     = _if;

    this.gen2drv = gen2drv;
    this.drv2scb = drv2scb;
  endfunction

  local function logic [DATA_W-1:0] getWord( ref ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet, output int unsigned empty );
    logic [DATA_W-1:0] data = 'x;
    empty                   = '0;

    for( int unsigned i = 0; i < ( DATA_W / 8 ); i++ )
      begin
        if( packet.data.size() > 0 )
          data[i*8 +: 8] = packet.data.pop_front(); // Grab next byte
        else
          begin
            empty = ( ( DATA_W / 8 ) - i ); // No more bytes, calculate empty value
            break;
          end
      end

    return data;
  endfunction

  local task start_check_unknown();
    forever
      begin
        assert( !$isunknown( this._if.src_cb.ready ) )
        else
          $display( "%8d ns: ast_ready_o is unknown", $time );

        @( this._if.src_cb );
      end
  endtask

  local task start_send_packets();
    ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet;
    forever
      begin
        this.gen2drv.peek( packet ); // Dont remove yet
        this.drv2scb.put( packet.copy() );

        this.send_packet( packet );

        this.gen2drv.get( packet ); // Now remove
      end
  endtask

  function void reset();
    this._if_dir.src_cb.dir       <= '0;
    this._if.src_cb.data          <= 'x;
    this._if.src_cb.startofpacket <= 'x;
    this._if.src_cb.endofpacket   <= 'x;
    this._if.src_cb.valid         <= 1'b0;
    this._if.src_cb.empty         <= 'x;
    this._if.src_cb.channel       <= 'x;
  endfunction

  task send_packet( input ast_dmx_packet #( CHANNEL_W, DIR_SEL_W ) packet );
    int unsigned empty;
    bit          sop;

    sop = 1'b1;
    while( packet.data.size() > 0 )
      begin
        if( this._if.src_cb.ready && ( $urandom_range(1, 100) <= packet.write_chance ) )
          begin
            this._if_dir.src_cb.dir       <= ( sop ) ? ( packet.dir ) : ( 'x ); // dir only at sop
            this._if.src_cb.data          <= getWord( packet, empty );
            this._if.src_cb.startofpacket <= sop;
            this._if.src_cb.endofpacket   <= ( packet.data.size() == 0 );
            this._if.src_cb.valid         <= 1'b1;
            this._if.src_cb.empty         <= empty;
            this._if.src_cb.channel       <= packet.channel;

            sop = 1'b0;
          end
        else
          this.reset();

        @( this._if.src_cb );
      end

    this.reset();
  endtask

  task send_gibberish( input int unsigned count = 100 );
    repeat( count )
      begin
        this._if_dir.src_cb.dir       <= $urandom_range( 0, DIR_SEL_MAX );
        this._if.src_cb.data          <= $urandom_range( 0, DATA_MAX );
        this._if.src_cb.startofpacket <= $urandom_range( 0, 1 );
        this._if.src_cb.endofpacket   <= $urandom_range( 0, 1 );
        this._if.src_cb.valid         <= 1'b0;
        this._if.src_cb.empty         <= $urandom_range( 0, EMPTY_MAX );
        this._if.src_cb.channel       <= $urandom_range( 0, CHANNEL_MAX );
        @( this._if.src_cb );
      end

    this.reset();
  endtask

  task run();
    fork
      this.start_check_unknown();
      this.start_send_packets();
    join_none
  endtask

endclass
