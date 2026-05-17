`timescale 1ns / 1ps
// ============================================================
// Address Mux
// sel = 1 -> pc_addr (fetch instruction address)
// sel = 0 -> ir_addr (operand address from instruction)
// Width is parameterized
// ============================================================
module addr_mux #(
    parameter WIDTH = 32
)(
    input              sel,
    input  [WIDTH-1:0] pc_addr,
    input  [WIDTH-1:0] ir_addr,
    output [WIDTH-1:0] addr_out
);

    assign addr_out = sel ? pc_addr : ir_addr;

endmodule