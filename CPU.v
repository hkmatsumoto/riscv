module CPU #(
    parameter XLEN = 32
) (
    input               clk_i,
    output reg [5:0]    led_o
);
    reg [XLEN-1:0] pc = 0;
    
    wire [XLEN-1:0] instruction_w;
    InstructionMemory IMemory(
        .addr_i         (pc),
        .instruction_o  (instruction_w)
    );

    wire [5:0] f_w;
    wire [$clog2(XLEN)-1:0] rs1_w;
    wire [$clog2(XLEN)-1:0] rs2_w;
    wire [$clog2(XLEN)-1:0] rd_w;
    wire [11:0]     imm_w;
    InstructionDecoder IDecoder(
        .instruction_i  (instruction_w),
        .f_o            (f_w),
        .rs1_o          (rs1_w),
        .rs2_o          (rs2_w),
        .rd_o           (rd_w),
        .imm_o          (imm_w)
    );
    
    // Is this a branch operation?
    wire branch_op_w = 6'd4 <= f_w & f_w <= 6'd9;
    // Is this a load operation?
    wire load_op_w = 6'd10 <= f_w & f_w <= 6'd14;
    // Is this a store operation?
    wire store_op_w = 6'd15 <= f_w & f_w <= 6'd17;
    // Is this an arithmetic operation?
    wire arith_op_w = 6'd27 <= f_w & f_w <= 6'd36;
    // Is this an arithmetic operation with an immediate value?
    wire arith_imm_op_w = 6'd18 <= f_w & f_w <= 6'd26;

    // Is this operation takes an immediate value? 
    wire imm_op_w = load_op_w | store_op_w | arith_imm_op_w;

    wire [XLEN-1:0] op1_w;
    wire [XLEN-1:0] op2_w;
    RegisterFile RFile(
        .clk_i  (clk_i),
        .we_i   (1'b1),
        .rs1_i  (rs1_w),
        .rs2_i  (rs2_w),
        .rd_i   (rd_w),
        .data_i (load_op_w ? memory_w : alu_w),
        .op1_o  (op1_w),
        .op2_o  (op2_w)
    );
    
    wire [XLEN-1:0] alu_w;
    ALU ALU(
        .f_i        (f_w),
        .op1_i      (op1_w),
        .op2_i      (imm_op_w ? imm_w : op2_w),
        .result_o   (alu_w)
    );
    
    wire [XLEN-1:0] memory_w;
    DataMemory DMemory(
        .clk_i  (clk_i),
        .addr_i (alu_w),
        .we_i   (store_op_w),
        .data_i (op2_w),
        .data_o (memory_w)
    );
    
    always @(posedge clk_i) begin
        if (branch_op_w) begin
            if (f_w == 6'd4 && op1_w == op2_w) pc <= pc + imm_w;
            else pc <= pc + 1;

            if (f_w == 6'd5 && op1_w != op2_w) pc <= pc + imm_w;
            else pc <= pc + 1;

            if (f_w == 6'd6 && op1_w < op2_w)  pc <= pc + imm_w;
            else pc <= pc + 1;

            if (f_w == 6'd7 && op1_w >= op2_w) pc <= pc + imm_w;
            else pc <= pc + 1;
        end
        else pc <= pc + 1;
    end
    
    // Memory-mapped I/O for LED.
    always @(posedge clk_i) begin
        if (store_op_w && alu_w == 63) led_o <= op2_w[5:0];
    end
endmodule