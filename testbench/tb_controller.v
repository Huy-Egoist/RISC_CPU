`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:46:20 PM
// Design Name: 
// Module Name: tb_controller
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


module tb_controller();
    reg clk, rst;
    reg [2:0] opcode;
    reg is_zero;
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;

    controller uut (
        .clk(clk), .rst(rst), .opcode(opcode), .is_zero(is_zero),
        .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt), 
        .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc), .wr(wr), .data_e(data_e)
    );

    always #5 clk = ~clk;

    integer i;
    initial begin
        clk = 0; rst = 1; opcode = 3'b010; is_zero = 0; // Test ADD instruction
        #10 rst = 0;
        
        $display("[CTRL TEST] Testing ADD instruction state machine...");
        for(i=0; i<8; i = i + 1) begin
            @(posedge clk);
            #1;
            $display("State: %0d | sel=%b rd=%b ld_ir=%b halt=%b inc_pc=%b ld_ac=%b ld_pc=%b wr=%b data_e=%b",
                     uut.state, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e);
        end
        
        $display("\n[CTRL TEST] Testing HLT instruction (should halt in OP_ADDR)...");
        rst = 1; #10 rst = 0; opcode = 3'b000; // HLT
        for(i=0; i<5; i = i + 1) begin
            @(posedge clk);
            #1;
            $display("State: %0d | halt=%b", uut.state, halt);
            if(halt) begin
                $display("[CTRL TEST] Halt triggered successfully.");
                $finish;
            end
        end
    end
endmodule