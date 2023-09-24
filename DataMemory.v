module DataMemory #(
    parameter XLEN = 32
) (
    input               clk_i,
    // FIXME: Maybe log_2(1024) = 10 bits would suffice.
    input   [XLEN-1:0]  addr_i,
    input               we_i,
    input   [XLEN-1:0]  data_i,
    output  [XLEN-1:0]  data_o
);
    reg [XLEN-1:0] memory[63:0];
    
    assign data_o = memory[addr_i];

    always @(posedge clk_i) begin
        if (we_i) memory[addr_i] = data_i;
    end
endmodule