`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:47:06 PM
// Design Name: 
// Module Name: tb_risc_cpu
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


`timescale 1ns / 1ps
module tb_risc_cpu();
    reg clk, rst;
    wire halt;
    
    risc_cpu uut (.clk(clk), .rst(rst), .halt(halt));
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1;
        #1;
        uut.u_mem.mem[0] = {27'b0, 3'b101, 5'd20}; // LDA 20
        uut.u_mem.mem[1] = {27'b0, 3'b010, 5'd21}; // ADD 21
        uut.u_mem.mem[2] = {27'b0, 3'b110, 5'd22}; // STO 22
        uut.u_mem.mem[3] = {27'b0, 3'b000, 5'd0};  // HLT
        
        uut.u_mem.mem[20] = 32'd10; // Data
        uut.u_mem.mem[21] = 32'd15; // Data
        uut.u_mem.mem[22] = 32'd0;  
        
        #20 rst = 0;
        $display("========================================");
        $display(" Time   PC  Opcode  Acc_out  ALU_out");
        $display("========================================");
        
        forever @(posedge clk) begin
            #1;
            $display(" %0t    %0d   %b     %0d      %0d", 
                     $time, uut.u_pc.pc_out, uut.opcode, uut.acc_out, uut.alu_out);
            if (halt) begin
                $display("========================================");
                $display("Ket qua cuoi cung tai mem[22] = %0d (Expected 25)", uut.u_mem.mem[22]);
                if(uut.u_mem.mem[22] == 25) $display("PASS!");
                else $display("FAIL!");
                #50 $finish;
            end
        end
    end
endmodule