`timescale 1ns / 1ps
// ============================================================
// Program Counter
// Width: 32-bit (parameter)
// - Synchronous reset, active high -> count = 0
// - inc_pc: increment by 1
// - ld_pc:  load value from data_in
// - Priority: rst > ld_pc > inc_pc
// ============================================================
module program_counter #(
    parameter WIDTH = 32
)(
    input              clk,
    input              rst,      // synchronous, active high
    input              inc_pc,   // increment
    input              ld_pc,    // load
    input  [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] pc_out
);

    always @(posedge clk) begin
        if (rst)
            pc_out <= {WIDTH{1'b0}};
        else if (ld_pc)
            pc_out <= data_in;
        else if (inc_pc)
            pc_out <= pc_out + 1'b1;
    end

endmodule
