interface amm_rd_if #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH
)( input logic clk );

logic [ADDR_WIDTH-1:0] address;
logic                  read;
logic [DATA_WIDTH-1:0] readdata;
logic                  readdatavalid;
logic                  waitrequest;

clocking cb @( posedge clk );
  input  address;
  input  read;

  output readdata;
  output readdatavalid;
  output waitrequest;
endclocking

clocking mon_cb @( posedge clk );
  input  address;
  input  read;
  input  readdata;
  input  readdatavalid;
  input  waitrequest;
endclocking

endinterface
