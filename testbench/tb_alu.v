`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:45:19 PM
// Design Name: 
// Module Name: tb_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_alu();
    reg [2:0] opcode;
    reg [31:0] inA, inB;
    wire [31:0] out;
    wire is_zero;

    alu uut (
        .opcode(opcode), .inA(inA), .inB(inB), 
        .out(out), .is_zero(is_zero)
    );

    initial begin
        inA = 32'd8; inB = 32'd3;
        
        // Test ADD
        opcode = 3'b010;
        #10;
        $display("[ALU TEST] ADD 8+3 -> Out = %0d (Expected 11)", out);
        
        // Test AND
        opcode = 3'b011;
        #10;
        $display("[ALU TEST] AND 8&3 -> Out = %0d (Expected 0)", out);
        
        // Test XOR
        opcode = 3'b100;
        #10;
        $display("[ALU TEST] XOR 8^3 -> Out = %0d (Expected 11)", out);
        
        // Test LDA
        opcode = 3'b101;
        #10;
        $display("[ALU TEST] LDA inB -> Out = %0d (Expected 3)", out);
        
        // Test is_zero (Asynchronous)
        inA = 32'd0; opcode = 3'b001; // SKZ
        #10;
        $display("[ALU TEST] is_zero check -> %0b (Expected 1)", is_zero);
        
        $finish;
    end
endmodule