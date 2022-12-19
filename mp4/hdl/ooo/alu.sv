module alu
import rv32i_types::*;
(
    // input tomasula_types::op_t op,
    // input tomasula_types::alu_word::src1_data src1_data,
    // input tomasula_types::alu_word::src2_data src2_data,
    // input tomasula_types::alu_word::funct3 funct3,
    // input tomasula_types::alu_word::funct7 funct7,
    // input tomasula_types::alu_word::load load,
    // input tomasula_types::alu_word::tag tag,
    input tomasula_types::alu_word alu_word,
//    output tomasula_types::cdb_data::data data,
//    output tomasula_types::cdb_data::tag tag_out,
//    output tomasula_types::cdb_data::request req
    output tomasula_types::cdb_data cdb_data
);

logic [31:0] a, b;
rv32i_types::alu_ops aluop;

always_comb begin : OPERATION
    a = alu_word.src1_data;
    b = alu_word.src2_data;

    // aluop = alu_add;
    // if(alu_word.op == tomasula_types::ARITH) begin
    //     if (alu_word.funct3 == rv32i_types::sr) begin 
    //             if (alu_word.funct7 != 1'b1)
    //                 aluop = rv32i_types::alu_srl;
    //             else
    //                 aluop = rv32i_types::alu_sra;
    //         end
    //         /* check funct7 only when it matters in regular add, not immediate add */
    //         else if (alu_word.funct3 == rv32i_types::add) begin
    //             if (alu_word.funct7 != 1'b1)
    //                 aluop = rv32i_types::alu_add;
    //             else
    //                 aluop = rv32i_types::alu_sub;
    //         end
    //         else
    //             aluop = rv32i_types::alu_ops'(alu_word.funct3);
    // end
    // else begin
    //     aluop = rv32i_types::alu_add;
    // end
    aluop = rv32i_types::alu_ops'(3'b000); // set to add by default
    if (alu_word.opcode == tomasula_types::s_op_imm) begin
        case (alu_word.funct3)
            add: aluop = rv32i_types::alu_add;
            sll: aluop = rv32i_types::alu_sll;
            // slt: aluop = rv32i_types::;
            // sltu:;
            axor: aluop = rv32i_types::alu_xor;
            sr: begin
                if (alu_word.funct7)
                    aluop = rv32i_types::alu_sra;
                else
                    aluop = rv32i_types::alu_srl;
            end
            aor: aluop = rv32i_types::alu_or;
            aand: aluop = rv32i_types::alu_and;
        endcase
    end
    else if (alu_word.opcode == tomasula_types::s_op_reg) begin
        case (alu_word.funct3)
            add: begin
                if (alu_word.funct7)
                    aluop = rv32i_types::alu_sub;
                else
                    aluop = rv32i_types::alu_add;
            end
            sll: aluop = rv32i_types::alu_sll;
            axor: aluop = rv32i_types::alu_xor;
            sr: begin
                if (alu_word.funct7)
                    aluop = rv32i_types::alu_sra;
                else
                    aluop = rv32i_types::alu_srl;
            end
            aor: aluop = rv32i_types::alu_or;
            aand: aluop = rv32i_types::alu_and;
        endcase
    end
    
end

always_comb begin : EXECUTION
    case (aluop)
        alu_add:  cdb_data.data = a + b;
        alu_sll:  cdb_data.data = a << b[4:0];
        alu_sra:  cdb_data.data = $signed(a) >>> b[4:0];
        alu_sub:  cdb_data.data = a - b;
        alu_xor:  cdb_data.data = a ^ b;
        alu_srl:  cdb_data.data = a >> b[4:0];
        alu_or:   cdb_data.data = a | b;
        alu_and:  cdb_data.data = a & b;
        
        default: cdb_data.data = a + b;
    endcase
    // cdb_data.req = alu_word.load;
    // cdb_data.tag = alu_word.tag;


end

endmodule : alu
