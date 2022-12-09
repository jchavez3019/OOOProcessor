module reservation_station
import rv32i_types::*;
(
    input clk, 
    input rst, 
    input load_word,
    input tomasula_types::cdb_data cdb[8],
    input logic [7:0] robs_calculated,
    input logic [7:0] allocated_rob_entries,
    output tomasula_types::alu_word alu_data,
    output logic start_exe,
    output logic res_empty,
    output logic jalr_executed, // only instruction that does a jump relative to a register instead of pc
    output logic ld_pc_to_cdb, // used for jal and jalr instructions to load pc + 4 into cdb instead of alu output
    output logic update_br, // used by branch instructions to update rd array in rob
    input tomasula_types::res_word res_in
);

tomasula_types::res_word res_word;

enum int unsigned {
    EMPTY = 0,
    CHECK = 1,
    PEEK_ONE  = 2,
    PEEK_REST = 3
} state, next_state;

always_comb
begin : assign_alu_data
    alu_data.op = res_word.op;
    /* modify funct3 so that alu does an add operation */
    if (res_word.op == tomasula_types::JALR | res_word.op == tomasula_types::JAL)
        alu_data.funct3 = 3'b000;
    else
        alu_data.funct3 = res_word.funct3;
    alu_data.funct7 = res_word.funct7;
    alu_data.tag = res_word.rd_tag;
    alu_data.pc = res_word.pc;

    // if (res_word.src2_valid) begin
    //     alu_data.src1_data = res_word.src1_data;
    //     alu_data.src2_data = res_word.src2_data;
    // end
    // else begin
    //     alu_data.src1_data = res_in.src1_data;
    //     alu_data.src2_data = res_in.src2_data;
    // end
end


always_ff @(posedge clk)
begin
    if (rst)
    begin
        res_word.op <= tomasula_types::BRANCH;
        res_word.funct3 <= 3'b000;
        res_word.funct7 <= 1'b0;
        res_word.src1_tag <= 3'b000;
        res_word.src1_data <= 32'h0000;
        res_word.src1_valid <= 1'b0;
        res_word.src2_tag <= 3'b000;
        res_word.src2_data <= 32'h0000;
        res_word.src2_valid <= 1'b0;
        res_word.rd_tag <= 3'b000;
        res_word.pc <= 32'h00000000;

        state <= EMPTY;
    end
    if (load_word)
        res_word <= res_in;
    // else if (next_state == CHECK) begin
    //     /* clock data coming in from instruction register and ROB */
    //     res_word <= res_in;

    //     state <= next_state;
    // end
    // else if (next_state == PEEK_ONE) begin
    //     /* clock valid bits and source data from RegFile */
    //     res_word.src1_valid <= res_word.src1_valid | res_in.src1_valid;
    //     if (~res_word.src1_valid)
    //         res_word.src1_data <= res_in.src1_data;

    //     res_word.src2_valid <= res_word.src2_valid | res_in.src2_valid;
    //     if (~res_word.src2_valid)
    //         res_word.src2_data <= res_in.src2_data;

    //     state <= next_state;
    // end
    // else if (next_state == PEEK_REST) begin

    //     res_word.src1_valid <= res_word.src1_valid | robs_calculated[res_word.src1_tag];
    //     if (~res_word.src1_valid)
    //         res_word.src1_data <= cdb[res_word.src1_tag].data;

    //     res_word.src2_valid <= res_word.src2_valid | robs_calculated[res_word.src2_tag];
    //     if (~res_word.src2_valid)
    //         res_word.src2_data <= cdb[res_word.src2_tag].data;

    //     state <= next_state;
    // end
    // else if (state == EMPTY) begin
    //     res_word.op <= tomasula_types::BRANCH;
    //     res_word.funct3 <= 3'b000;
    //     res_word.funct7 <= 1'b0;
    //     res_word.src1_tag <= 3'b000;
    //     res_word.src1_data <= 32'h0000;
    //     res_word.src1_valid <= 1'b0;
    //     res_word.src2_tag <= 3'b000;
    //     res_word.src2_data <= 32'h0000;
    //     res_word.src2_valid <= 1'b0;
    //     res_word.rd_tag <= 3'b000;

    //     state <= next_state;
    // end
    // else
        state <= next_state;
end

function void set_defaults();
    res_empty = 1'b0;
    start_exe = 1'b0;
    jalr_executed = 1'b0;
    ld_pc_to_cdb = 1'b0;
    update_br = 1'b0;
    alu_data.src1_data = 32'h00000000;
    alu_data.src2_data = 32'h00000000;
endfunction

always_comb
begin : state_actions
    /* Default output assignments */
    set_defaults();

    /* Actions for each state */
    case (state)
        EMPTY: begin
            res_empty = 1'b1;
        end
        CHECK: begin
            /* both source registers are valid and we can execute in this same cycle */
            // if (res_in.src1_valid & (res_word.src2_valid | res_in.src2_valid))
            //     start_exe = 1'b1;
            if (res_word.src1_valid & res_word.src2_valid)
                start_exe = 1'b1;

            /* deal with jalr special case to unstall pipeline */
            if (start_exe & res_word.op == tomasula_types::JALR) begin
                jalr_executed = 1'b1;
                ld_pc_to_cdb = 1'b1;
            end

            /* reroute output for jal like above */
            if (start_exe & res_word.op == tomasula_types::JAL) begin
                ld_pc_to_cdb = 1'b1;
            end

            /* deal with branches */
            if (start_exe & res_word.op == tomasula_types::BRANCH) begin
                ld_pc_to_cdb = 1'b1;
                update_br = 1'b1;
            end

            if (start_exe & res_word.op == tomasula_types::AUIPC) begin
                ld_pc_to_cdb = 1'b1;
            end

            if (start_exe & res_word.op == tomasula_types::LUI) begin
                ld_pc_to_cdb = 1'b1;
            end
            

            // if (res_word.src1_valid)
            //     alu_data.src1_data = res_word.src1_data;
            // else
            //     alu_data.src1_data = res_in.src1_data;
            alu_data.src1_data = res_word.src1_data;
                
            // if (res_word.src2_valid)
            //     alu_data.src2_data = res_word.src2_data;
            // else
            //     alu_data.src2_data = res_in.src2_data;
            alu_data.src2_data = res_word.src2_data;
        end
        PEEK_ONE, PEEK_REST: begin
            /* check if data is valid and execute */
            if ((res_word.src1_valid | robs_calculated[res_word.src1_tag]) & (res_word.src2_valid | robs_calculated[res_word.src2_tag]))
                start_exe = 1'b1;

            /* deal with jalr special case to unstall pipeline */
            if (start_exe & res_word.op == tomasula_types::JALR) begin
                jalr_executed = 1'b1;
                ld_pc_to_cdb = 1'b1;
            end

            /* reroute output for jal like above */
            if (start_exe & res_word.op == tomasula_types::JAL) begin
                ld_pc_to_cdb = 1'b1;
            end

            if (start_exe & res_word.op == tomasula_types::AUIPC) begin
                ld_pc_to_cdb = 1'b1;
            end

            if (start_exe & res_word.op == tomasula_types::LUI) begin
                ld_pc_to_cdb = 1'b1;
            end


            /* deal with branches */
            if (start_exe & res_word.op == tomasula_types::BRANCH) begin
                ld_pc_to_cdb = 1'b1;
                update_br = 1'b1;
            end

            if (res_word.src1_valid)
                alu_data.src1_data = res_word.src1_data;
            else
                alu_data.src1_data = cdb[res_word.src1_tag].data;
            
            if (res_word.src2_valid)
                alu_data.src2_data = res_word.src2_data;
            else    
                alu_data.src2_data = cdb[res_word.src2_tag].data;
        end
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case (state)
        EMPTY: begin
            if (load_word)
                next_state = CHECK;
        end
        CHECK: begin
            // if ((res_word.src1_valid | res_in.src1_valid) & (res_word.src2_valid | res_in.src2_valid))
            //     next_state = EMPTY;
            // else
            //     next_state = PEEK_ONE;
            if (res_word.src1_valid & res_word.src2_valid)
                next_state = EMPTY;

            /* in the case reservation station needs to get flushed */
            if (~allocated_rob_entries[res_word.rd_tag])
                next_state = EMPTY;
        end
        PEEK_ONE, PEEK_REST: begin
            if ((res_word.src1_valid | robs_calculated[res_word.src1_tag]) & (res_word.src2_valid | robs_calculated[res_word.src2_tag]))
                next_state = EMPTY;
            else
                next_state = PEEK_REST;

            /* in the case reservation station needs to get flushed */
            if (~allocated_rob_entries[res_word.rd_tag])
                next_state = EMPTY;
        end
    endcase
end

endmodule : reservation_station
