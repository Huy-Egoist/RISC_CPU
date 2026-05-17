`timescale 1ns / 1ps
// ============================================================
// Generic Register (32-bit)
// Synchronous reset, active high
// Load on posedge clk when load=1
// ============================================================
module register #(
    parameter WIDTH = 32
)(
    input              clk,
    input              rst,    // synchronous, active high
    input              load,
    input  [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

    always @(posedge clk) begin
        if (rst)
            data_out <= {WIDTH{1'b0}};
        else if (load)
            data_out <= data_in;
    end

endmodule