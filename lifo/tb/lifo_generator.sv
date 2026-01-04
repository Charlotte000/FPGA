class lifo_generator #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH
);
  local virtual lifo_if _if;

  function new( virtual lifo_if _if );
    this._if = _if;
  endfunction

  task send_random(
    input int unsigned count,
    input int unsigned rd_chance,
    input int unsigned wr_chance
  );
    repeat( count )
      begin
        this._if.rdreq <= 1'b0;
        this._if.wrreq <= 1'b0;
        this._if.data  <= 'x;

        // Random read
        if( $urandom_range( 1, 100 ) <= rd_chance )
          begin
            this._if.rdreq <= 1'b1;
          end

        // Random write
        if( $urandom_range( 1, 100 ) <= wr_chance )
          begin
            this._if.wrreq <= 1'b1;
            this._if.data  <= $urandom_range( 0, ( 2 ** DWIDTH - 1 ) );
          end

        @( posedge this._if.clk );
      end
  endtask

  task send_fill( input int unsigned count );
    for( int unsigned i = 0; i < count; i++ )
      begin
        this._if.rdreq <= 1'b0;
        this._if.wrreq <= 1'b1;
        this._if.data  <= i;

        @( posedge this._if.clk );
      end
  endtask

  task send_read( input int unsigned count );
    repeat( count )
      begin
        this._if.rdreq <= 1'b1;
        this._if.wrreq <= 1'b0;
        this._if.data  <= 'x;

        @( posedge this._if.clk );
      end
  endtask

  task send_timeout( input int unsigned count );
    repeat( count )
      begin
        this._if.rdreq <= 1'b0;
        this._if.wrreq <= 1'b0;
        this._if.data  <= 'x;

        @( posedge this._if.clk );
      end
  endtask

  task run();
    this.send_timeout( 2 );

    // Full write/read
    this.send_fill( 2 ** AWIDTH );
    this.send_read( 2 ** AWIDTH );

    // Overflow
    this.send_fill( ( 2 ** AWIDTH ) * 2 );
    this.send_read( ( 2 ** AWIDTH ) * 2 );

    // Random
    this.send_random( 1000, 25, 75 );
    this.send_random( 1000, 50, 50 );
    this.send_random( 10000, 75, 50 );

    this.send_timeout( 2 );
  endtask

endclass
