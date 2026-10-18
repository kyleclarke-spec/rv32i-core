// The Arithmetic Logic Unit (ALU) performs every calculation the
// the CPU does: add, subtract, compare, shift, and the bitwise
// operations. There is no clock, so result immediately becomes
// the new answer. This makes it combinational logic

// Operations w/op codes:
// ADD(0), SUB(1), SLL(2), SLT(3), SLTU(4), XOR(5), SRL(6),
// SRA(7), OR(8), AND(9)

// Three inputs and one output: a and b: two 32-bit numbers
// op: a 4-bit code saying which operation to doc(ADD = 0, etc.)
// result: the 32-bit answer

module alu
    import rv32i_pkg::*; // Lets you use alu_op_t and ALU_ADD from the package
(
    input logic [31:0] a,
    input logic [31:0] b,
    input alu_op_t op, // Which operation to perfrom

    output logic[31:0] result
);

    always_comb begin
        case (op)
            ALU_ADD: result = a + b;
            ALU_SUB: result = a - b;
            ALU_SLL: result = a << b[4:0];
            ALU_SLT: result = {31'b0, $signed(a) < $signed(b)}; // SV treats logic values as unsigned by default
            ALU_SLTU: result = {31'b0, a < b};
            ALU_XOR: result = a ^ b;
            ALU_SRL: result = a >> b[4:0];
            ALU_SRA: result = $signed(a) >>> b[4:0];
            ALU_OR: result = a | b;
            ALU_AND: result = a & b;
            default: result = 32'b0; // Covers any op value you didn't list
        endcase
    end

endmodule
