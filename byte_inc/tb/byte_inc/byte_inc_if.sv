interface byte_inc_if #(
  parameter int ADDR_WIDTH
)( input logic clk );

logic [ADDR_WIDTH-1:0] base_addr;
logic [ADDR_WIDTH-1:0] length;
logic                  run;
logic                  waitrequest;

clocking cb @( posedge clk );
  output base_addr;
  output length;
  output run;

  input  waitrequest;
endclocking

clocking mon_cb @( posedge clk );
  input  base_addr;
  input  length;
  input  run;
  input  waitrequest;
endclocking

endinterface
