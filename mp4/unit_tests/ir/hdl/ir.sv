
module ir
import rv32i_types::*;
(
    input clk,
    input rst,
    input instr_mem_resp,
    input [31:0] in,

    output rv32i_word instr_mem_address, // ir will have to communicate with pc to get this, or maybe pc just wires directly to icache
    output instr_read,
    output tomasulo_types::ctl_word control_word,
    output ld_pc
);

logic data [31:0];

assign funct3 = data[14:12];
assign funct7 = data[31:25];
assign opcode = rv32i_opcode'(data[6:0]);
assign i_imm = {{21{data[31]}}, data[30:20]};
assign s_imm = {{21{data[31]}}, data[30:25], data[11:7]};
assign b_imm = {{20{data[31]}}, data[7], data[30:25], data[11:8], 1'b0};
assign u_imm = {data[31:12], 12'h000};
assign j_imm = {{12{data[31]}}, data[19:12], data[20], data[30:21], 1'b0};
assign rs1 = data[19:15];
assign rs2 = data[24:20];
assign rd = data[11:7];

assign control_word.src1_reg = rs1;
assign control_word.src2_reg = rs2;
assign control_word.src1_valid = 1'b0;
assign control_word.funct3 = funct3;
assign control_word.funct7 = funct7[30];
assign control_word.rd = rd;

enum int unsigned {
    RESET = 0,
    FETCH = 1,
    STALL = 2,
    FETCH = 3
} state, next_state;

always_comb
begin : immediate_logic
    control_word.imm = 32'h0000;
    control_word.src2_valid = 1'b0;
    case (opcode)
        op_lui, op_auipc: begin 
            control_word.imm = u_imm;
            control_word.src2_valid = 1'b1;
        end
        op_jal: begin
            control_word.imm = j_imm;
            control_word.src2_valid = 1'b1;
        end
        op_br: begin
            control_word.imm = b_imm;
            control_word.src2_valid = 1'b1;
        end
        op_store: begin
            control_word.imm = s_imm;
            control_word.src2_valid = 1'b1;
        end
        op_jalr, op_load, op_imm, op_csr: begin
            control_word.imm = i_imm;
            control_word.src2_valid = 1'b1;
        end
    endcase
end

//why "=" instead of "<="
always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= '0;
        state <= RESET;
    end
    else if (next_state == FETCH)
    begin
        data <= in;
        state <= next_state;
    end
    else
    begin
        data <= data;
        state <= next_state;
    end
end

function void set_defaults();
    instr_read = 1'b0;
    ld_pc = 1'b0;
endfunction

always_comb
begin : state_actions
    set_defaults();

    case (state)
        FETCH: begin
            instr_read = 1'b1;
        end
        STALL: begin
            ld_pc = 1'b1; // wrong, figure out how to load pc correctly
        end

    endcase
end

always_comb
begin : next_state_logic

end

endmodule : ir
