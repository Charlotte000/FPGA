interface amm_wr_if #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH,
  parameter int BYTE_CNT
)( input logic clk );

logic [ADDR_WIDTH-1:0] address;
logic                  write;
logic [DATA_WIDTH-1:0] writedata;
logic [BYTE_CNT-1:0]   byteenable;
logic                  waitrequest;

clocking cb @( posedge clk );
  input  address;
  input  write;
  input  writedata;
  input  byteenable;

  output waitrequest;
endclocking

clocking mon_cb @( posedge clk );
  input  address;
  input  write;
  input  writedata;
  input  byteenable;
  input  waitrequest;
endclocking

endinterface
