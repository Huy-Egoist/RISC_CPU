`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:39:13 PM
// Design Name: 
// Module Name: tb_program_counter
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


module tb_program_counter();
    reg clk;
    reg rst;
    reg inc_pc;
    reg ld_pc;
    reg [31:0] data_in;
    wire [31:0] pc_out;

    program_counter uut (
        .clk(clk), .rst(rst), .inc_pc(inc_pc), 
        .ld_pc(ld_pc), .data_in(data_in), .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; inc_pc = 0; ld_pc = 0; data_in = 0;
        #10 rst = 0;
        
        $display("[PC TEST] Reset -> PC = %0d (Expected 0)", pc_out);
        
        inc_pc = 1;
        #20; // 2 clock cycles
        $display("[PC TEST] Inc 2 times -> PC = %0d (Expected 2)", pc_out);
        
        inc_pc = 0; ld_pc = 1; data_in = 32'd15;
        #10;
        $display("[PC TEST] Load 15 -> PC = %0d (Expected 15)", pc_out);
        
        ld_pc = 0; inc_pc = 1;
        #10;
        $display("[PC TEST] Inc after Load -> PC = %0d (Expected 16)", pc_out);
        
        $finish;
    end
endmodule