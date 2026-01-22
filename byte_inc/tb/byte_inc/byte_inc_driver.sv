class byte_inc_driver #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual byte_inc_if #(
    .ADDR_WIDTH ( ADDR_WIDTH )
  ) set_if;

  local mailbox #(
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT )
  ) gen2drv;

  function new(
    input virtual byte_inc_if #( ADDR_WIDTH ) set_if,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) gen2drv
  );
    this.set_if  = set_if;
    this.gen2drv = gen2drv;
  endfunction

  local function void reset();
    this.set_if.cb.base_addr <= 'x;
    this.set_if.cb.length    <= 'x;
    this.set_if.cb.run       <= 1'b0;
  endfunction

  task run();
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) tr;
    forever
      begin
        this.gen2drv.peek( tr );
        @( this.set_if.cb );

        this.set_if.cb.base_addr <= tr.base_addr;
        this.set_if.cb.length    <= tr.length;
        this.set_if.cb.run       <= 1'b1;
        @( this.set_if.cb );
        this.reset();
        @( this.set_if.cb );

        wait( this.set_if.cb.waitrequest == 0 );
        this.gen2drv.get( tr );
      end
  endtask

endclass
