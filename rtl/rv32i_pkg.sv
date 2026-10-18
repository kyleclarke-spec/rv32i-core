// rv32i_pkg.sv
// Shared definitions for the RV32I core: opcodes and control encodings.
package rv32i_pkg;

    // ALU operations. The ALU performs exactly one of these each cycle.
    typedef enum logic [3:0] {
        ALU_ADD = 4'd0,
        ALU_SUB = 4'd1,
        ALU_SLL = 4'd2,
        ALU_SLT = 4'd3,
        ALU_SLTU = 4'd4,
        ALU_XOR = 4'd5,
        ALU_SRL = 4'd6,
        ALU_SRA = 4'd7,
        ALU_OR = 4'd8,
        ALU_AND = 4'd9
    } alu_op_t;

    // Which immediate format an instruction uses.
    typedef enum logic [2:0] {
        IMM_I = 3'd0,
        IMM_S = 3'd1,
        IMM_B = 3'd2,
        IMM_U = 3'd3,
        IMM_J = 3'd4
    } imm_type_t;

    // Where the ALU's first operand comes from.
    typedef enum logic [1:0] {
        A_RS1 = 2'd0,
        A_PC = 2'd1,
        A_ZERO = 2'd2
    } alu_a_sel_t;

    // What gets written back to the destination register.
     typedef enum logic [1:0] {
        WB_ALU = 2'd0,
        WB_MEM = 2'd1,
        WB_PC4 = 2'd2
    } wb_sel_t;

    // The 7-bit opcodes of every RV32I instruction group.
    localparam logic [6:0] OP_LUI    = 7'b0110111;
    localparam logic [6:0] OP_AUIPC  = 7'b0010111;
    localparam logic [6:0] OP_JAL    = 7'b1101111;
    localparam logic [6:0] OP_JALR   = 7'b1100111;
    localparam logic [6:0] OP_BRANCH = 7'b1100011;
    localparam logic [6:0] OP_LOAD   = 7'b0000011;
    localparam logic [6:0] OP_STORE  = 7'b0100011;
    localparam logic [6:0] OP_IMM    = 7'b0010011;
    localparam logic [6:0] OP_REG    = 7'b0110011;
    localparam logic [6:0] OP_FENCE  = 7'b0001111;
    localparam logic [6:0] OP_SYSTEM = 7'b1110011;

endpackage

