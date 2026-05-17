`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 05:45:52 PM
// Design Name: 
// Module Name: tb_memory
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


module tb_memory();
    reg clk;
    reg [31:0] addr;
    reg rd, wr;
    wire [31:0] data; // Cổng inout của bộ nhớ

    // TẠO MỘT THANH GHİ GIẢ ĐỂ ĐẨY DỮ LIỆU LÊN BUS KHI GHI
    reg [31:0] fake_cpu_data_out; 

    memory #(.MEM_DEPTH(32)) uut (
        .clk(clk), .addr(addr), .rd(rd), .wr(wr), .data(data)
    );

    // Nếu đang GHI (wr=1) -> fake_cpu đẩy dữ liệu lên bus.
    // Nếu đang ĐỌC (wr=0) -> fake_cpu nhả bus ra (để Z), cho phép memory tự xuất dữ liệu.
    assign data = (wr) ? fake_cpu_data_out : 32'bz;

    always #5 clk = ~clk;

    initial begin
        clk = 0; addr = 0; rd = 0; wr = 0; fake_cpu_data_out = 0;
        #10;
        
        // ===== Test WRITE =====
        addr = 32'd5; 
        wr = 1; 
        fake_cpu_data_out = 32'd123; // Đưa số 123 lên bus
        #10; // Chờ 1 clock để bộ nhớ lưu vào
        $display("[MEM TEST] Wrote 123 to address 5");
        
        // ===== Test IDLE =====
        wr = 0; // Tắt cờ ghi -> Fake CPU nhả bus
        #10;
        $display("[MEM TEST] Bus idle (Z state check): Data = %b", data);
        
        // ===== Test READ =====
        addr = 32'd5; // Trỏ lại về địa chỉ 5
        rd = 1;       // Bật cờ đọc
        #10; 
        #1;  
        $display("[MEM TEST] Read from address 5 -> Data = %0d (Expected 123)", data);
        
        if (data == 123)
            $display("[MEM TEST] PASS!");
        else
            $display("[MEM TEST] FAIL!");
            
        rd = 0;
        $finish;
    end
endmodule