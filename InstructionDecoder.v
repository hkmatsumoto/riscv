module InstructionDecoder
(
    input [31:0] instruction_i,
    output reg [5:0] f_o,
    output [4:0] rs1_o,
    output [4:0] rs2_o,
    output [4:0] rd_o,
    output reg [11:0] imm_o
);
    wire [6:0] opcode = instruction_i[6:0];

    assign rd_o = instruction_i[11:7];
    wire [2:0] funct3 = instruction_i[14:12];
    wire [6:0] funct7 = instruction_i[31:25];
    
    assign rs1_o = instruction_i[19:15];
    assign rs2_o = instruction_i[24:20];
    
    wire [11:0] i_imm = instruction_i[31:20];
    wire [11:0] s_imm = {
        instruction_i[31:25],
        instruction_i[11:7]
    };
    wire [12:0] b_imm = {
        instruction_i[31],
        instruction_i[7],
        instruction_i[30:25],
        instruction_i[11:8],
        1'b0
    };
    wire [19:0] u_imm = instruction_i[31:12];
    wire [20:0] j_imm = {
        instruction_i[31],
        instruction_i[19:12],
        instruction_i[20],
        instruction_i[30:21],
        1'b0
    };
    
    wire [4:0] shamt = instruction_i[24:20];

    always @(*) begin
        case (opcode)
            7'b0110111: begin // LUI
                f_o <= 0;
                imm_o <= u_imm;
            end
            7'b0010111: begin // AUIPC
                f_o <= 1;
                imm_o <= u_imm;
            end
            7'b1101111: begin // JAL
                f_o <= 2;
                imm_o <= j_imm;
            end
            7'b1100111: begin // JALR
                f_o <= 3;
                imm_o <= i_imm;
            end
            7'b1100011: begin // B-type, Branch instructions
                imm_o <= b_imm;
                case (funct3)
                    3'b000: f_o <= 4; // BEQ
                    3'b001: f_o <= 5; // BNE
                    3'b100: f_o <= 6; // BLT
                    3'b101: f_o <= 7; // BGE
                    3'b110: f_o <= 8; // BLTU
                    3'b111: f_o <= 9; // BGEU
                    default: ;
                endcase
            end
            7'b0000011: begin // I-type, Load instructions
                imm_o <= i_imm;
                case (funct3)
                    3'b000: f_o <= 10; // LB
                    3'b001: f_o <= 11; // LH
                    3'b010: f_o <= 12; // LW
                    3'b100: f_o <= 13; // LBU
                    3'b101: f_o <= 14; // LHU
                    default: ;
                endcase
            end
            7'b0100011: begin // S-type, Store instructions
                imm_o <= s_imm;
                case (funct3)
                    3'b000: f_o <= 15; // SB
                    3'b001: f_o <= 16; // SH
                    3'b010: f_o <= 17; // SW
                    default: ;
                endcase
            end
            7'b0010011: begin // I-type
                imm_o <= i_imm;
                case (funct3)
                    3'b000: f_o <= 18; // ADDI
                    3'b010: f_o <= 19; // SLTI
                    3'b011: f_o <= 20; // SLTIU
                    3'b100: f_o <= 21; // XORI
                    3'b110: f_o <= 22; // ORI
                    3'b111: f_o <= 23; // ANDI
                    default: begin
                        imm_o <= shamt;
                        case (funct3)
                            3'b001: f_o <= 24; // SLLI
                            3'b101: begin
                                if (funct7 == 7'b0000000) f_o <= 25; // SRLI
                                else f_o <= 26; // SRAI
                            end
                            default: ;
                        endcase
                    end
                endcase
            end
            7'b0110011: begin // I-type
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000) f_o <= 27; // ADD
                        else f_o <= 28; // SUB
                    end
                    3'b001: f_o <= 29; // SLL
                    3'b010: f_o <= 30; // SLT
                    3'b011: f_o <= 31; // SLTU
                    3'b100: f_o <= 32; // XOR
                    3'b101: begin
                        if (funct7 == 7'b0000000) f_o <= 33; // SRL
                        else f_o <= 34; // SRA
                    end
                    3'b110: f_o <= 35; // OR
                    3'b111: f_o <= 36; // AND
                    default: ;
                endcase
            end
            7'b0001111: f_o <= 37; // FENCE
            7'b1110011: begin // ECALL, EBREAK
                if (instruction_i[31:20] == 12'b000000000000) f_o <= 38; // ECALL
                else f_o <= 39; // EBREAK
            end
            default: ;
        endcase
    end
endmodule
