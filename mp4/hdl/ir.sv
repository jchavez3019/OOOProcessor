
module ir
import rv32i_types::*;
(
    input clk,
    input rst,
    input instr_mem_resp,
    // input iq_resp,
    input [31:0] in,
    input [31:0] pc,
    input br_pr_take,
    input executed_jalr,
    input flush_ip,

    input iq_ack,

    output rv32i_word instr_mem_address, // ir will have to communicate with pc to get this, or maybe pc just wires directly to icache
    output logic instr_read,
    output logic ld_pc,
    output logic [31:0] pc_calc,
    output logic [31:0] curr_instr,

    IQ_2_IR.IR_SIG iq_ir_itf
);

logic [31:0] data; // holds current instruction from cache

logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] i_imm, s_imm, b_imm, j_imm, u_imm;
logic [4:0] rs1, rs2, rd;
rv32i_opcode opcode;

assign curr_instr = data;

assign funct3 = data[14:12];
assign funct7 = data[31:25];
assign opcode = rv32i_opcode'(data[6:0]);
assign i_imm = {{21{data[31]}}, data[30:20]}; // 32
assign s_imm = {{21{data[31]}}, data[30:25], data[11:7]};
assign b_imm = {{20{data[31]}}, data[7], data[30:25], data[11:8], 1'b0};
assign u_imm = {data[31:12], 12'h000};
assign j_imm = {{12{data[31]}}, data[19:12], data[20], data[30:21], 1'b0};
assign rs1 = data[19:15];
assign rs2 = data[24:20];
assign rd = data[11:7];
assign instr_mem_address = pc;

/* this is an rvfi word that will get passed so that the rvfi can properly debug */
rv32i_types::rvfi_word rvfi;

assign iq_ir_itf.rvfi = rvfi;

always_comb
begin : generate_rvfi_word
    rvfi.inst = data;
    rvfi.rs1_addr = rs1;
    rvfi.rs2_addr = rs2;
    rvfi.rd_addr = rd;
    rvfi.pc_rdata = pc;
    
    // rvfi.pc_wdata = iq_ir_itf.control_word.pc;
end

enum int unsigned {
    RESET = 0,
    FETCH = 1,
    CREATE = 2,
    STALL = 3,
    STALL_JALR = 4,
    STALL_FLUSH = 5
} state, next_state;

always_comb
begin : immediate_op_logic
    iq_ir_itf.control_word.op = tomasula_types::ARITH;
    iq_ir_itf.control_word.src1_reg = rs1;
    iq_ir_itf.control_word.src1_valid = 1'b0;
    iq_ir_itf.control_word.src2_reg = rs2; // should be rs2 if no immediate is used, otherwise 0
    iq_ir_itf.control_word.pc = pc + 4;
    iq_ir_itf.control_word.og_pc = pc;
    iq_ir_itf.control_word.src2_valid = 1'b0;
    iq_ir_itf.control_word.src2_data = 32'h0000;
    iq_ir_itf.control_word.funct3 = funct3;
    iq_ir_itf.control_word.funct7 = data[30];
    iq_ir_itf.control_word.rd = rd;
    iq_ir_itf.control_word.og_instr = data;

    /* rvfi signals to be set */
    rvfi.pc_wdata = iq_ir_itf.control_word.pc;
    rvfi.imm = iq_ir_itf.control_word.src2_valid;
    case (opcode)
        op_lui: begin
            iq_ir_itf.control_word.op = tomasula_types::LUI;
            iq_ir_itf.control_word.src1_reg = 5'b00000;
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.pc = u_imm;

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end
        op_auipc: begin 
            iq_ir_itf.control_word.op = tomasula_types::AUIPC;
            iq_ir_itf.control_word.src1_reg = 5'b00000;
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.pc = pc + u_imm;

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end
        op_jal: begin
            iq_ir_itf.control_word.op = tomasula_types::JAL;
            iq_ir_itf.control_word.src1_reg = 5'b00000;
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.pc = pc + 4; 
            rvfi.pc_wdata = pc_calc;

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end
        op_br: begin
            iq_ir_itf.control_word.op = tomasula_types::BRANCH;
            // if predicted to not be taken, save target address for taking
            // the branch
            if (~br_pr_take) begin
                iq_ir_itf.control_word.pc = pc_calc;
                // 0 0 0 PREDICTION 0
                iq_ir_itf.control_word.rd = 5'b00000; 
                rvfi.pc_wdata = pc + 4;
            end begin
                iq_ir_itf.control_word.pc = pc + 4;
                iq_ir_itf.control_word.rd = 5'b00010;
                rvfi.pc_wdata = pc_calc;
            end
            rvfi.imm = 1'b0;
        end
        op_store: begin
            // for stores, src2_reg is not correlated with s_imm
            // src2_reg is the register holding data that we will write
            // src2_data used to calculate effective address
            case (funct3) 
                sw: iq_ir_itf.control_word.op = tomasula_types::SW;
                sh: iq_ir_itf.control_word.op = tomasula_types::SH;
                sb: iq_ir_itf.control_word.op = tomasula_types::SB;
            endcase
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.src2_data = s_imm;

            rvfi.imm = 1'b0;
        end
        op_imm: begin
            iq_ir_itf.control_word.op = tomasula_types::ARITH;
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            if (funct3 == 3'b000 & i_imm[31])
                iq_ir_itf.control_word.src2_data = ~i_imm + 1;
            else
                iq_ir_itf.control_word.src2_data = i_imm;

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end 
        op_csr: begin
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.src2_data = i_imm;

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end
        op_jalr: begin
            iq_ir_itf.control_word.op = tomasula_types::JALR;
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.src2_data = i_imm;
            iq_ir_itf.control_word.pc = pc + 4; 

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end
        op_load: begin
            case (funct3) 
                lw: iq_ir_itf.control_word.op = tomasula_types::LW;
                lh: iq_ir_itf.control_word.op = tomasula_types::LH;
                lhu: iq_ir_itf.control_word.op = tomasula_types::LHU;
                lb: iq_ir_itf.control_word.op = tomasula_types::LB;
                lbu: iq_ir_itf.control_word.op = tomasula_types::LBU;
            endcase
            iq_ir_itf.control_word.src2_reg = 5'b00000;
            iq_ir_itf.control_word.src2_valid = 1'b1;
            iq_ir_itf.control_word.src2_data = i_imm;

            rvfi.imm = iq_ir_itf.control_word.src2_valid;
        end
    endcase
    // rvfi.imm = iq_ir_itf.control_word.src2_valid;
    
end

always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= '0;
        state <= RESET;
    end
    else if (next_state == FETCH)
    begin
        state <= next_state;
    end
    else if (next_state == CREATE)
    begin
        data <= in;
        state <= next_state;
    end
    else
        state <= next_state;
end

function void set_defaults();
    instr_read = 1'b0;
    ld_pc = 1'b0;
    iq_ir_itf.ld_iq = 1'b0;
    pc_calc = pc + 4;
endfunction

always_comb
begin : state_actions
    set_defaults();

    case (state)
        RESET: ;
        FETCH: begin
            instr_read = 1'b1;
        end
        CREATE: begin
            // address calculation 
            if(opcode == op_jal) begin
                pc_calc = pc + j_imm;
            end
            if(opcode == op_br) begin
                pc_calc = pc + b_imm;
            end
            /*
            intuitively, we only we wouldn't care about the next instruction if the opcode is jalr but we can safely
            assume with the jalr_stall state that even though pc gets loaded with pc + 4, we will never fetch this address from i-cache,
            we will only fetch the calculated address from jalr since jalr will load pc with its calculated address eventually in order to
            leave the jalr_stall state
            */
            ld_pc = 1'b1; 
            iq_ir_itf.ld_iq = 1'b1;
        end
        STALL: begin
            iq_ir_itf.ld_iq = 1'b1;
        end
        STALL_JALR: begin
            // do nothing
        end
        STALL_FLUSH: begin
            // do nothing
        end
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
        RESET: next_state = FETCH;
        FETCH: begin
            if (instr_mem_resp)
                next_state = CREATE;
        end
        CREATE: begin
            if (flush_ip) begin
                next_state = STALL_FLUSH;
            end
            else if (iq_ack) begin
                if(opcode == op_jalr) 
                    next_state = STALL_JALR;
                else
                    next_state = FETCH;
            end
            else
                next_state = STALL;
        end
        STALL: begin
            if (iq_ack) begin
                if (flush_ip)
                    next_state = STALL_FLUSH;
                else if(opcode == op_jalr) 
                    next_state = STALL_JALR;
                else
                    next_state = FETCH;
            end
        end
        STALL_JALR: begin
            if(executed_jalr == 1) begin
                next_state = FETCH;
            end
        end
        STALL_FLUSH: begin
            if (~flush_ip)
                next_state = FETCH;
        end
    endcase
end

endmodule : ir
