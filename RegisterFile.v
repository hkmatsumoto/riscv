module RegisterFile #(
    parameter XLEN = 32
) (
    input   clk_i,
    input   we_i,
    input   [$clog2(XLEN)-1:0] rs1_i,
    input   [$clog2(XLEN)-1:0] rs2_i,
    input   [$clog2(XLEN)-1:0] rd_i,
    input   [XLEN-1:0] data_i,
    output  [XLEN-1:0] op1_o,
    output  [XLEN-1:0] op2_o
);
    // Registers x0 ... x31
    reg [XLEN-1:0] x[31:0];
    
    // x0 (zero register) always returns 0
    assign op1_o = rs1_i == 0 ? 0 : x[rs1_i];
    assign op2_o = rs2_i == 0 ? 0 : x[rs2_i];
    
    always @(posedge clk_i) begin
        if (we_i) x[rd_i] <= data_i;
    end
endmodule