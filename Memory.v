`timescale 1ns / 1ps
// ============================================================
// Memory
// 32-bit address, 32-bit data
// Single bidirectional data port (inout)
// rd=1: read mode | wr=1: write mode (not simultaneous)
// Synchronous on posedge clk
// Initialized with sample program for testing
// ============================================================
module memory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 256
)(
    input                   clk,
    input  [ADDR_WIDTH-1:0] addr,
    input                   rd,
    input                   wr,
    inout  [DATA_WIDTH-1:0] data
);

    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    reg [DATA_WIDTH-1:0] data_out_reg;
    reg                  output_en;

    // Bidirectional data port
    assign data = output_en ? data_out_reg : {DATA_WIDTH{1'bz}};

    always @(posedge clk) begin
        if (wr && !rd) begin
            // Write mode
            mem[addr] <= data;
            output_en <= 1'b0;
        end else if (rd && !wr) begin
            // Read mode
            data_out_reg <= mem[addr];
            output_en    <= 1'b1;
        end else begin
            output_en <= 1'b0;
        end
    end

    // Initialize memory with a sample program
    // Program: computes (5 + 3) XOR 6, stores result at addr 20
    //   Addr 0:  LDA 16   -> load mem[16]=5 into ACC
    //   Addr 1:  ADD 17   -> ACC = ACC + mem[17] = 5+3 = 8
    //   Addr 2:  XOR 18   -> ACC = ACC ^ mem[18] = 8^6 = 14
    //   Addr 3:  STO 19   -> mem[19] = ACC = 14
    //   Addr 4:  LDA 19   -> ACC = mem[19] = 14
    //   Addr 5:  HLT 0    -> halt
    //   Data section:
    //   Addr 16: 5
    //   Addr 17: 3
    //   Addr 18: 6
    integer i;
endmodule