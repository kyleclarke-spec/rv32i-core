// regfile.sv
// 32 x 32-bit register file with two read ports and one write port.
// Register x 0 always reads as zero and ignores writes.

module regfile (
    input logic clk,
    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,
    input logic we,
    input logic [4:0] rd_addr,
    input logic [31:0] rd_data,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    // The 32-lockers: x0 to x31, each holding a 32-bit number.

    logic [31:0] regs [0:31];

    always_ff @(posedge clk) begin //always_ff means "this block is memory: it only chnages at clock ticks"
        if (we && rd_addr != 5'd0) begin
            regs[rd_addr] <= rd_data; //Inside always_ff always use <= never =
        end
    end

    //Read: instant (no clock). Locker 0 always reads as 0.

    assign rs1_data = rs1_addr == 5'd0 ? 32'd0 : regs[rs1_addr];
    assign rs2_data = rs2_addr == 5'd0 ? 32'd0 : regs[rs2_addr];

endmodule






