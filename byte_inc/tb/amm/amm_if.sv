interface amm_if #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH,
  parameter int BYTE_CNT
)( input logic clk );

logic [ADDR_WIDTH-1:0] address;
logic                  waitrequest;

logic                  read;
logic [DATA_WIDTH-1:0] readdata;
logic                  readdatavalid;

logic                  write;
logic [DATA_WIDTH-1:0] writedata;
logic [BYTE_CNT-1:0]   byteenable;

clocking cb @( posedge clk );
  input  address;
  output waitrequest;

  input  read;
  output readdata;
  output readdatavalid;

  input  write;
  input  writedata;
  input  byteenable;
endclocking

clocking mon_cb @( posedge clk );
  input  address;
  input  waitrequest;

  input  read;
  input  readdata;
  input  readdatavalid;

  input  write;
  input  writedata;
  input  byteenable;
endclocking

endinterface
