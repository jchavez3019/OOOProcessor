module alu
import rv32i_types::*;
(
    input op_t op,
    input alu_word::src1_data src1_data,
    input alu_word::src2_data src2_data,
    input alu_word::funct3 funct3,
    input alu_word::funct7 funct7,
    input alu_word::load load,
    input alu_word::tag tag,
   output cdb_data::data data,
   output cdb_data::tag tag_out,
   output cdb_data::request req
);


always_comb begin : MUXES
    a = src1_data_buf;
    b = src2_data_buf;  
    unique case (op)
        op_t::BRANCH :  begin 
            aluop = rv32i_types::alu_add;
        end
        op_t::ARITH :   begin
            if (funct3 == rv32i_types::sr) begin 
                if (funct7 != 1'b1)
                    aluop = rv32i_types::alu_srl;
                else
                    aluop = rv32i_types::alu_sra;
            end
            else if (funct3 == rv32i_types::add) begin
                if (funct7 != 1'b1)
                    aluop = rv32i_types::alu_add;
                else
                    aluop = rv32i_types::alu_sub;
            end
            else
                aluop = funct3;
        end
        op_t::AUIPC :   begin 
            aluop = rv32i_types::alu_add;
        end
        op_t::JAL :     begin 
            aluop = rv32i_types::alu_add;
        end
        op_t::JALR :    begin
            aluop = rv32i_types::alu_add;
        end
        // etc.
        default: `BAD_MUX_SEL;
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
        alu_add:  data = a + b;
        alu_sll:  data = a << b[4:0];
        alu_sra:  data = $signed(a) >>> b[4:0];
        alu_sub:  data = a - b;
        alu_xor:  data = a ^ b;
        alu_srl:  data = a >> b[4:0];
        alu_or:   data = a | b;
        alu_and:  data = a & b;
    endcase
    req = load;
    tag_out = tag;


end

endmodule : alu
