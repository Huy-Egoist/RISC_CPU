`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:44:21 PM
// Design Name: 
// Module Name: tb_register
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


module tb_register();
    reg clk;
    reg rst;
    reg load;
    reg [31:0] data_in;
    wire [31:0] data_out;

    register uut (
        .clk(clk), .rst(rst), .load(load), 
        .data_in(data_in), .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; load = 0; data_in = 32'd50;
        #10 rst = 0;
        $display("[REG TEST] Reset -> Out = %0d (Expected 0)", data_out);
        
        #10;
        $display("[REG TEST] No Load -> Out = %0d (Expected 0)", data_out);
        
        load = 1;
        #10;
        $display("[REG TEST] Load 50 -> Out = %0d (Expected 50)", data_out);
        
        load = 0; data_in = 32'd99;
        #10;
        $display("[REG TEST] Hold -> Out = %0d (Expected 50)", data_out);
        
        $finish;
    end
endmodule