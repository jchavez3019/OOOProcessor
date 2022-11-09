`define BAD_MUX_SEL $display("Illegal mux select")

module branch_alu
import rv32i_types::*;
(
    //compare
    input [2:0] op,
    input [31:0] first,
    input [31:0] second,
    output logic answer

    // address calculation
    // input [31:0] a, b,
    // output [31:0] address  
);



always_comb begin
    unique case (branch_funct3_t'(op))
        rv32i_types::bge: answer = ($signed(first) >= $signed(second));
        rv32i_types::bltu: answer = (first < second);
        rv32i_types::bgeu: answer = (first >= second);
        rv32i_types::beq: answer = (first==second);
        rv32i_types::bne: answer = (first!=second);
        rv32i_types::blt: answer = ($signed(first) < $signed(second));
        default: `BAD_MUX_SEL;
    endcase

    // address = a + b;
end

endmodule
