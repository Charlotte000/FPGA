class amm_ram #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  localparam int unsigned DATA_MAX = ( ( 2 ** DATA_WIDTH ) - 1 );
  localparam int unsigned ADDR_MAX = ( ( 2 ** ADDR_WIDTH ) - 1 );
  localparam int unsigned BYTE_MAX = ( ( 2 ** BYTE_CNT   ) - 1 );

  local logic [DATA_WIDTH-1:0] data [ADDR_MAX:0];

  function void fill_data_random();
    foreach( this.data[i] )
      this.data[i] = $urandom_range( 0, DATA_MAX );
  endfunction

  function void fill_data_plain();
    foreach( this.data[i] )
      this.data[i] = i;
  endfunction

  function void fill_data_same( input int unsigned value );
    foreach( this.data[i] )
      this.data[i] = value;
  endfunction

  function amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) copy();
    amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) c = new();
    c.data = this.data;
    return c;
  endfunction

  function logic [DATA_WIDTH-1:0] read( input logic [ADDR_WIDTH-1:0] addr );
    return this.data[addr];
  endfunction

  function void write(
    input logic [ADDR_WIDTH-1:0] addr,
    input logic [DATA_WIDTH-1:0] data,
    input logic [BYTE_CNT-1:0]   byteenable = BYTE_MAX
  );
    foreach( byteenable[i] )
      begin
        if( byteenable[i] )
          this.data[addr][i*8 +: 8] = data[i*8 +: 8];
      end
  endfunction

  function void dump( input int unsigned start, input int unsigned stop );
    for( int unsigned addr = start; addr <= stop; addr++ )
      $display( "%h: %h", addr, this.data[addr] );
  endfunction
endclass
