`timescale 1ns / 1ps

// ============================================================
// Testbench for RISC CPU
// Tests: ADD, AND, OR, LDA, STO, JMP, SKZ, HLT instructions
// ============================================================

module risc_cpu_tb;

    // ========== Testbench Signals ==========
    reg  clk;
    reg  rst;
    wire halt;
    
    // ========== Instantiate CPU ==========
    risc_cpu uut (
        .clk (clk),
        .rst (rst),
        .halt(halt)
    );
    
    // ========== Clock Generation ==========
    // 10ns clock period (100MHz)
    always #5 clk = ~clk;
    
    // ========== Test Sequence ==========
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        
        $display("========================================");
        $display("     RISC CPU Testbench Started");
        $display("========================================");
        $display("");
        
        // Release reset after 20ns
        #20 rst = 0;
        $display("[%0t] Reset released, CPU starting...", $time);
        $display("");
        
        // Wait for program to complete (halt signal)
        wait (halt == 1);
        
        $display("");
        $display("========================================");
        $display("     Simulation Complete");
        $display("========================================");
        
        #50 $finish;
    end
    
    // ========== Program Loader ==========
    // Load program into memory before CPU starts
    initial begin
        // Wait for memory to be ready
        #1;
        
        // ===== TEST PROGRAM 1: Basic Arithmetic =====
        // Calculate: (5 + 3) AND 7 = 8 AND 7 = 0? Wait, 8&7=0
        // Actually let's do: (5 + 3) = 8, store to addr 10
        // Then test AND: LDA 10 (8), AND 11 (7) -> 8&7=0
        
        // ? S?A: ??i "memory" thành "mem"
        // Address 0: LDA 5     (load value from addr 5 into AC)
        uut.u_mem.mem[0] = {27'b0, 3'b101, 5'd5};   // LDA 5
        // Address 1: ADD 6     (add value from addr 6)
        uut.u_mem.mem[1] = {27'b0, 3'b010, 5'd6};   // ADD 6
        // Address 2: STO 10    (store AC to addr 10)
        uut.u_mem.mem[2] = {27'b0, 3'b110, 5'd10};  // STO 10
        // Address 3: LDA 10    (load back from addr 10)
        uut.u_mem.mem[3] = {27'b0, 3'b101, 5'd10};  // LDA 10
        // Address 4: AND 11    (AND with value at addr 11)
        uut.u_mem.mem[4] = {27'b0, 3'b011, 5'd11};  // AND 11
        // Address 5: STO 12    (store result to addr 12)
        uut.u_mem.mem[5] = {27'b0, 3'b110, 5'd12};  // STO 12
        // Address 6: HLT
        uut.u_mem.mem[6] = {27'b0, 3'b000, 5'd0};   // HLT
        
        // Data values
        uut.u_mem.mem[5] = 32'd5;     // value at addr 5
        uut.u_mem.mem[6] = 32'd3;     // value at addr 6
        uut.u_mem.mem[11] = 32'd7;    // value for AND operation
        
        $display("[%0t] Program loaded into memory:", $time);
        $display("  [0] LDA 5  -> load %0d", uut.u_mem.mem[5]);
        $display("  [1] ADD 6  -> add %0d", uut.u_mem.mem[6]);
        $display("  [2] STO 10 -> store AC to addr 10");
        $display("  [3] LDA 10 -> load from addr 10");
        $display("  [4] AND 11 -> AND with %0d", uut.u_mem.mem[11]);
        $display("  [5] STO 12 -> store result to addr 12");
        $display("  [6] HLT");
        $display("");
    end
    
    // ========== Monitor ==========
    // Display CPU state at each clock cycle
    initial begin
        $display("========================================");
        $display(" Time\t PC  Opcode  Acc_out  ALU_out  Halt");
        $display("========================================");
        
        forever @(posedge clk) begin
            #1;  // Small delay for signals to settle
            $display(" %0t\t %0d   %b     %0d      %0d      %b",
                     $time,
                     uut.u_pc.pc_out,
                     uut.opcode,
                     uut.acc_out,
                     uut.alu_out,
                     halt);
            
            // Check if HALT is detected
            if (halt) begin
                $display("========================================");
                $display("[%0t] HALT detected! Program finished.", $time);
                $display("");
                $display("=== Final Memory Contents ===");
                // ? S?A: ??i "memory" thành "mem"
                $display("  mem[5]  = %0d (initial data)", uut.u_mem.mem[5]);
                $display("  mem[6]  = %0d (initial data)", uut.u_mem.mem[6]);
                $display("  mem[10] = %0d (5+3 result)", uut.u_mem.mem[10]);
                $display("  mem[11] = %0d (AND mask)", uut.u_mem.mem[11]);
                $display("  mem[12] = %0d (final result)", uut.u_mem.mem[12]);
                $display("");
                
                // Verify results
                $display("=== Verification ===");
                if (uut.u_mem.mem[10] == 8)
                    $display("  ? mem[10] = 8 (5+3) CORRECT");
                else
                    $display("  ? mem[10] = %0d, expected 8", uut.u_mem.mem[10]);
                
                if (uut.u_mem.mem[12] == (8 & 7))
                    $display("  ? mem[12] = %0d (5+3 & 7) CORRECT", uut.u_mem.mem[12]);
                else
                    $display("  ? mem[12] = %0d, expected %0d", 
                             uut.u_mem.mem[12], (8 & 7));
                
                $finish;
            end
        end
    end
    
endmodule