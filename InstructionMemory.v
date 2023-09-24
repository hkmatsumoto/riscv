module InstructionMemory #(
    parameter XLEN = 32
) (
    input   [XLEN-1:0] addr_i,
    output  [XLEN-1:0] instruction_o
);
    wire [XLEN-1:0] memory [31:0]; // Read-only memory for instructions
    
    assign instruction_o = memory[addr_i];
    
    wire [11:0]  led_w = 11'd63;
    // addi x1, x0, 60
    assign memory[0] = {12'd60, 5'd0, 3'b000, 5'd1, 7'b0010011};
    // sw x1, 63(x0) where the address 63 is mapped to LED
    assign memory[1] = {led_w[11:5], 5'd1, 5'd0, 3'b010, led_w[4:0], 7'b0100011};
endmodule