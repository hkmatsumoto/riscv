`timescale 1ns/1ps

module CPU_tb;
    reg clk_i = 1'b0;
    
    always #1 begin
        clk_i <= ~clk_i;
    end
    
    initial begin
        $dumpfile("CPU.vcd");
        $dumpvars(0, CPU_tb);
    end
    
    CPU CPU(
        .clk_i  (clk_i)
    );
    
    initial begin
        #2
        #2
        #2
        #2
        $finish;
    end
endmodule