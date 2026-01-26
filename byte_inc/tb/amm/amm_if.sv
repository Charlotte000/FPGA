interface amm_if #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH,
  parameter int BYTE_CNT
)( input logic clk );

logic [ADDR_WIDTH-1:0] address;
logic [DATA_WIDTH-1:0] data;
logic                  waitrequest;

logic                  read;
logic                  datavalid;

logic                  write;
logic [BYTE_CNT-1:0]   byteenable;

clocking rd_cb @( posedge clk );
  input  address;
  input  read;

  output data;
  output datavalid;
  output waitrequest;
endclocking

clocking wr_cb @( posedge clk );
  input  address;
  input  data;
  input  write;
  input  byteenable;

  output waitrequest;
endclocking

clocking mon_cb @( posedge clk );
  input  address;
  input  data;
  input  waitrequest;

  input  read;
  input  datavalid;

  input  write;
  input  byteenable;
endclocking

endinterface
