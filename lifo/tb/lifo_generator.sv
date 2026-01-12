class lifo_generator #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH
);
  local virtual lifo_if #(
    .DWIDTH ( DWIDTH ),
    .AWIDTH ( AWIDTH )
  ) _if;

  function new(
    input virtual lifo_if #(
      .DWIDTH ( DWIDTH ),
      .AWIDTH ( AWIDTH )
    ) _if
  );
    this._if = _if;
  endfunction

  function void reset_output();
    this._if.data  <= 'x;
    this._if.wrreq <= 1'b0;
    this._if.rdreq <= 1'b0;
  endfunction

  task send_random(
    input int unsigned count,
    input int unsigned rd_chance,
    input int unsigned wr_chance
  );
    repeat( count )
      begin
        this.reset_output();

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

    this.reset_output();
  endtask

  task send_fill( input int unsigned count );
    for( int unsigned i = 0; i < count; i++ )
      begin
        this._if.rdreq <= 1'b0;
        this._if.wrreq <= 1'b1;
        this._if.data  <= $urandom_range( 0, ( 2 ** DWIDTH - 1 ) );

        @( posedge this._if.clk );
      end

    this.reset_output();
  endtask

  task send_read( input int unsigned count );
    repeat( count )
      begin
        this._if.rdreq <= 1'b1;
        this._if.wrreq <= 1'b0;
        this._if.data  <= 'x;

        @( posedge this._if.clk );
      end

    this.reset_output();
  endtask

  task send_timeout( input int unsigned count );
    repeat( count )
      begin
        this.reset_output();
        @( posedge this._if.clk );
      end

    this.reset_output();
  endtask
endclass
