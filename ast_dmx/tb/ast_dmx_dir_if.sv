interface ast_dmx_dir_if #(
  parameter int unsigned DIR_SEL_W
)( input logic clk );

logic [DIR_SEL_W-1:0] dir;

clocking src_cb @( posedge clk );
  output dir;
endclocking

endinterface
