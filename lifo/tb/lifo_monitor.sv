class lifo_monitor #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH,
  parameter int unsigned ALMOST_FULL_VALUE,
  parameter int unsigned ALMOST_EMPTY_VALUE
);
  localparam int unsigned STACK_SIZE = ( 2 ** AWIDTH );

  local         logic   [DWIDTH-1:0] stack [$:STACK_SIZE];
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

  function void check( input string param_name, input integer unsigned dut_val, input integer unsigned ref_val, input time timestamp );
    assert( dut_val === ref_val )
    else $display( "%5d ns: %12s expected %5d but got %0d", timestamp, param_name, ref_val, dut_val );
  endfunction

  function void reset();
    this.stack.delete();
  endfunction

  task listen( input int unsigned count );
    logic [DWIDTH-1:0] q;
    time timestamp;

    repeat( count )
      begin
        q = 'x;

        // Read-only
        if( this._if.rdreq && ( !this._if.wrreq ) && ( this.stack.size() > 0 ) )
          q = this.stack.pop_back();

        // Write-only
        if( ( !this._if.rdreq ) && this._if.wrreq && ( this.stack.size() < STACK_SIZE ) )
          this.stack.push_back( this._if.data );

        // Read-write
        if( this._if.rdreq && this._if.wrreq )
          begin
            if( this.stack.size() > 0 )
              q = this.stack.pop_back();

            if( this.stack.size() < ( STACK_SIZE - 1 ) )
              this.stack.push_back( this._if.data );
          end

        timestamp = $time;

        @( posedge this._if.clk );

        this.check( "q",            this._if.q,            q                                          , timestamp );
        this.check( "almost_empty", this._if.almost_empty, ( this.stack.size() <= ALMOST_EMPTY_VALUE ), timestamp );
        this.check( "empty",        this._if.empty,        ( this.stack.size() == 0                  ), timestamp );
        this.check( "almost_full",  this._if.almost_full,  ( this.stack.size() >= ALMOST_FULL_VALUE  ), timestamp );
        this.check( "full",         this._if.full,         ( this.stack.size() == STACK_SIZE         ), timestamp );
        this.check( "usedw",        this._if.usedw,        ( this.stack.size()                       ), timestamp );
      end
  endtask
endclass
