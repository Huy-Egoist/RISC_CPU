`timescale 1ns / 1ps
// ============================================================
// Controller (FSM)
// 8 states, cycles continuously: 
//   INST_ADDR -> INST_FETCH -> INST_LOAD -> IDLE ->
//   OP_ADDR   -> OP_FETCH   -> ALU_OP   -> STORE -> (back)
//
// Synchronous clk (posedge), synchronous rst active-high
// Outputs: sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
// ============================================================
module controller (
    input       clk,
    input       rst,
    input [2:0] opcode,
    input       is_zero,

    output reg  sel,
    output reg  rd,
    output reg  ld_ir,
    output reg  halt,
    output reg  inc_pc,
    output reg  ld_ac,
    output reg  ld_pc,
    output reg  wr,
    output reg  data_e
);

    // State encoding
    localparam INST_ADDR  = 3'd0;
    localparam INST_FETCH = 3'd1;
    localparam INST_LOAD  = 3'd2;
    localparam IDLE       = 3'd3;
    localparam OP_ADDR    = 3'd4;
    localparam OP_FETCH   = 3'd5;
    localparam ALU_OP     = 3'd6;
    localparam STORE      = 3'd7;

    // Opcode definitions
    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    reg [2:0] state, next_state;

    // ALUOP: opcodes that need memory operand (rd=1 in OP_FETCH/ALU_OP/STORE)
    wire aluop = (opcode == ADD) || (opcode == AND) ||
                 (opcode == XOR) || (opcode == LDA);

    // State register
    always @(posedge clk) begin
        if (rst)
            state <= INST_ADDR;
        else if (!halt)
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            INST_ADDR:  next_state = INST_FETCH;
            INST_FETCH: next_state = INST_LOAD;
            INST_LOAD:  next_state = IDLE;
            IDLE:       next_state = OP_ADDR;
            OP_ADDR:    next_state = OP_FETCH;
            OP_FETCH:   next_state = ALU_OP;
            ALU_OP:     next_state = STORE;
            STORE:      next_state = INST_ADDR;
            default:    next_state = INST_ADDR;
        endcase
    end

    // Output logic (Moore + Mealy on opcode/is_zero)
    always @(*) begin
        // Defaults
        sel    = 1'b0;
        rd     = 1'b0;
        ld_ir  = 1'b0;
        halt   = 1'b0;
        inc_pc = 1'b0;
        ld_ac  = 1'b0;
        ld_pc  = 1'b0;
        wr     = 1'b0;
        data_e = 1'b0;

        case (state)
            INST_ADDR: begin
                sel    = 1'b1;
            end

            INST_FETCH: begin
                sel    = 1'b1;
                rd     = 1'b1;
            end

            INST_LOAD: begin
                sel    = 1'b1;
                rd     = 1'b1;
                ld_ir  = 1'b1;
            end

            IDLE: begin
                sel    = 1'b1;
                rd     = 1'b1;
                ld_ir  = 1'b1;
                // inc_pc: always unless SKZ and is_zero (skip next)
                // For IDLE state: increment PC normally
                // SKZ skip logic: if SKZ and is_zero -> inc again (skip) handled at inc_pc
                inc_pc = 1'b1;
            end

            OP_ADDR: begin
                // sel=0: use IR address (operand address)
                halt   = (opcode == HLT) ? 1'b1 : 1'b0;
                // SKZ: if is_zero, skip next instruction (extra inc_pc)
                inc_pc = (opcode == SKZ) && is_zero ? 1'b1 : 1'b0;
            end

            OP_FETCH: begin
                rd     = aluop ? 1'b1 : 1'b0;
            end

            ALU_OP: begin
                rd     = aluop ? 1'b1 : 1'b0;
                ld_pc  = (opcode == JMP) ? 1'b1 : 1'b0;
                data_e = (opcode == STO) ? 1'b1 : 1'b0;
            end

            STORE: begin
                rd     = aluop ? 1'b1 : 1'b0;
                ld_ac  = aluop ? 1'b1 : 1'b0;
                ld_pc  = (opcode == JMP) ? 1'b1 : 1'b0;
                wr     = (opcode == STO) ? 1'b1 : 1'b0;
                data_e = (opcode == STO) ? 1'b1 : 1'b0;
            end

            default: begin end
        endcase
    end

endmodule