`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:39:52 PM
// Design Name: 
// Module Name: tb_addr_mux
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


module tb_addr_mux();
    reg sel;
    reg [31:0] pc_addr;
    reg [31:0] ir_addr;
    wire [31:0] addr_out;

    addr_mux uut (
        .sel(sel), .pc_addr(pc_addr), .ir_addr(ir_addr), .addr_out(addr_out)
    );

    initial begin
        pc_addr = 32'd100; ir_addr = 32'd200; sel = 1;
        #10;
        $display("[MUX TEST] Sel=1 (PC) -> Out = %0d (Expected 100)", addr_out);
        
        sel = 0;
        #10;
        $display("[MUX TEST] Sel=0 (IR) -> Out = %0d (Expected 200)", addr_out);
        
        $finish;
    end
endmodule