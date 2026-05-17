`timescale 1ns / 1ps
// ============================================================
// ALU - Arithmetic Logic Unit
// 3-bit opcode, 32-bit inputs, 32-bit output, 1-bit is_zero
// is_zero: asynchronous, checks if inA == 0
// ============================================================
module alu (
    input  [2:0]  opcode,
    input  [31:0] inA,       // Accumulator value
    input  [31:0] inB,       // Memory value
    output reg [31:0] out,
    output        is_zero
);

    // Opcode definitions
    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    // is_zero: asynchronous
    assign is_zero = (inA == 32'b0);

    always @(*) begin
        case (opcode)
            HLT: out = inA;
            SKZ: out = inA;
            ADD: out = inA + inB;
            AND: out = inA & inB;
            XOR: out = inA ^ inB;
            LDA: out = inB;
            STO: out = inA;
            JMP: out = inA;
            default: out = inA;
        endcase
    end

endmodule