class byte_inc_scoreboard #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  localparam int unsigned ADDR_MAX = ( ( 2 ** ADDR_WIDTH ) - 1 );

  local mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) src2scb;

  local mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) snk2scb;

  function new(
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) src2scb,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) snk2scb
  );
    this.src2scb = src2scb;
    this.snk2scb = snk2scb;
  endfunction

  local static function amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) make_ref_ram( input byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) src_tr);
    amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ref_ram = src_tr.ram_snapshot.copy();

    int unsigned                  base_addr;
    int unsigned                  offset;
    logic        [DATA_WIDTH-1:0] data;

    for( int unsigned i = 0; i < src_tr.length; i++ )
      begin
        base_addr = ( src_tr.base_addr + ( i / BYTE_CNT ) );
        offset    = ( i % BYTE_CNT );

        // Overflow
        if( base_addr > ADDR_MAX )
          break;

        data = ref_ram.read( base_addr );
        data[ ( offset * 8 ) +: 8 ] += 1'b1;
        ref_ram.write( base_addr, data );
      end

    return ref_ram;
  endfunction

  task check_transaction(
    input byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) src_tr,
    input byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) snk_tr
  );
    amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ref_ram = byte_inc_scoreboard::make_ref_ram( src_tr );

    assert( src_tr.base_addr === snk_tr.base_addr )
    else $display( "%8d ns: %6s expected %0d but got %0d", $time, "base_addr", src_tr.base_addr, snk_tr.base_addr );

    assert( src_tr.length === snk_tr.length )
    else $display( "%8d ns: %6s expected %0d but got %0d", $time, "length", src_tr.length, snk_tr.length );

    // Compare ref vs snk
    for( int unsigned base_addr = 0; base_addr <= ADDR_MAX; base_addr++ )
      begin
        logic [DATA_WIDTH-1:0] ref_data = ref_ram.read( base_addr );
        logic [DATA_WIDTH-1:0] snk_data = snk_tr.ram_snapshot.read( base_addr );

        assert( ref_data === snk_data )
        else $display(
          "%8d ns: %6s expected %h but got %h (addr=%d) (base_addr=%d, length=%d) ",
          $time,
          "data",
          ref_data,
          snk_data,
          ADDR_WIDTH'( base_addr ),
          src_tr.base_addr,
          src_tr.length
        );
      end
  endtask

  task run();
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) src_tr;
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) snk_tr;
    forever
      begin
        // Dont remove yet
        this.src2scb.peek( src_tr );
        this.snk2scb.peek( snk_tr );

        this.check_transaction( src_tr, snk_tr );

        // Now remove
        this.src2scb.get( src_tr );
        this.snk2scb.get( snk_tr );
      end
  endtask
endclass
