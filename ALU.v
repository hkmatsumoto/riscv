module ALU #(
    parameter XLEN = 32
) (
    input   [5:0] f_i,
    input   [XLEN-1:0] op1_i,
    input   [XLEN-1:0] op2_i,
    output  [XLEN-1:0] result_o
);
    assign result_o = alu(f_i, op1_i, op2_i);
    
    function [XLEN-1:0] alu;
        input [5:0]         f_i;
        input [XLEN-1:0]    op1_i;
        input [XLEN-1:0]    op2_i;
        
        begin
            case (f_i)
                10: alu = op1_i + op2_i;
                11: alu = op1_i + op2_i;
                12: alu = op1_i + op2_i;
                13: alu = op1_i + op2_i;
                14: alu = op1_i + op2_i;
                15: alu = op1_i + op2_i;
                16: alu = op1_i + op2_i;
                17: alu = op1_i + op2_i;
                18: alu = op1_i + op2_i;
                21: alu = op1_i ^ op2_i;
                22: alu = op1_i | op2_i;
                23: alu = op1_i & op2_i;
                24: alu = op1_i << op2_i;
                25: alu = op1_i >> op2_i;
                27: alu = op1_i + op2_i;
                28: alu = op1_i - op2_i;
                29: alu = op1_i << op2_i;
                default: ;
            endcase
        end
    endfunction
endmodule