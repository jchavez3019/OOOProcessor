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

always_comb begin : MUXES
    // a = src1_data_buf;
    // b = src2_data_buf;  
    a = alu_word.src1_data;
    b = alu_word.src2_data;

    // alu_op = alu_add;

    unique case (alu_word.op)
        tomasula_types::BRANCH :  begin 
            aluop = rv32i_types::alu_add;
        end
        tomasula_types::ARITH :   begin
            if (alu_word.funct3 == rv32i_types::sr) begin 
                if (alu_word.funct7 != 1'b1)
                    aluop = rv32i_types::alu_srl;
                else
                    aluop = rv32i_types::alu_sra;
            end
            else if (alu_word.funct3 == rv32i_types::add) begin
                if (alu_word.funct7 != 1'b1)
                    aluop = rv32i_types::alu_add;
                else
                    aluop = rv32i_types::alu_sub;
            end
            else
                aluop = alu_word.funct3;
        end
        tomasula_types::AUIPC :   begin 
            aluop = rv32i_types::alu_add;
        end
        tomasula_types::JAL :     begin 
            aluop = rv32i_types::alu_add;
        end
        tomasula_types::JALR :    begin
            aluop = rv32i_types::alu_add;
        end
        // etc.
        // default: `BAD_MUX_SEL;
    endcase
end

// always_comb begin : ASSIGNMENTS
//     if(load) begin
//         op_buf          = op;
//         src1_data_buf   = src1_data; 
//         src2_data_buf   = src2_data;
//         funct3_buf      = funct3;
//         funct7_buf      = funct7;      
//         tag_buf         = tag;           
//     end 
//     tag_out = tag
// end

always_comb
begin
    unique case (aluop)
        alu_add:  cdb.data = a + b;
        alu_sll:  cdb.data = a << b[4:0];
        alu_sra:  cdb.data = $signed(a) >>> b[4:0];
        alu_sub:  cdb.data = a - b;
        alu_xor:  cdb.data = a ^ b;
        alu_srl:  cdb.data = a >> b[4:0];
        alu_or:   cdb.data = a | b;
        alu_and:  cdb.data = a & b;
    endcase
    cdb.req = alu_word.load;
    cdb.tag = alu_word.tag;


end

endmodule : alu
