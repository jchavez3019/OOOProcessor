module reservation_station
import rv32i_types::*;
(
    input clk, 
    input rst, 
    input load_word,
    input tomasula_types::cdb_data cdb[8],
    input logic [7:0] robs_calculated,
    output tomasula_types::alu_word alu_data,
    output logic start_exe,
    output logic res_empty,
    output logic jalr_executed, // only instruction that does a jump relative to a register instead of pc
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
    alu_data.funct3 = res_word.funct3;
    alu_data.funct7 = res_word.funct7;
    alu_data.tag = res_word.rd_tag;
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

        state <= EMPTY;
    end
    else if (next_state == CHECK) begin
        /* clock data coming in from instruction register and ROB */
        res_word <= res_in;

        state <= next_state;
    end
    else if (next_state == PEEK_ONE) begin
        /* clock valid bits and source data from RegFile */
        res_word.src1_valid <= res_word.src1_valid | res_in.src1_valid;
        if (~res_word.src1_valid)
            res_word.src1_data <= res_in.src1_data;

        res_word.src2_valid <= res_word.src2_valid | res_in.src2_valid;
        if (~res_word.src2_valid)
            res_word.src2_data <= res_in.src2_data;

        state <= next_state;
    end
    else if (next_state == PEEK_REST) begin

        res_word.src1_valid <= res_word.src1_valid | robs_calculated[res_word.src1_tag];
        if (~res_word.src1_valid)
            res_word.src1_data <= cdb[res_word.src1_tag].data;

        res_word.src2_valid <= res_word.src2_valid | robs_calculated[res_word.src2_tag];
        if (~res_word.src2_valid)
            res_word.src2_data <= cdb[res_word.src2_tag].data;

        state <= next_state;
    end
    else if (next_state == EMPTY) begin
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

        state <= next_state;
    end
    else
        state <= next_state;
end

function void set_defaults();
    res_empty = 1'b0;
    start_exe = 1'b0;
    jalr_executed = 1'b0;
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
            if (res_in.src1_valid & (res_word.src2_valid | res_in.src2_valid))
                start_exe = 1'b1;

            if (start_exe & res_word.op == tomasula_types::JALR)
                jalr_executed = 1'b1;

            alu_data.src1_data = res_in.src1_data;
            if (res_word.src2_valid)
                alu_data.src2_data = res_word.src2_data;
            else
                alu_data.src2_data = res_in.src2_data;
        end
        PEEK_ONE, PEEK_REST: begin
            /* check if data is valid and execute */
            if ((res_word.src1_valid | robs_calculated[res_word.src1_tag]) & (res_word.src2_valid | robs_calculated[res_word.src2_tag]))
                start_exe = 1'b1;

            if (start_exe & res_word.op == tomasula_types::JALR)
                jalr_executed = 1'b1;

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
            if ((res_word.src1_valid | res_in.src1_valid) & (res_word.src2_valid | res_in.src2_valid))
                next_state = EMPTY;
            else
                next_state = PEEK_ONE;
        end
        PEEK_ONE, PEEK_REST: begin
            if ((res_word.src1_valid | robs_calculated[res_word.src1_tag]) & (res_word.src2_valid | robs_calculated[res_word.src2_tag]))
                next_state = EMPTY;
            else
                next_state = PEEK_REST;
        end
    endcase
end

endmodule : reservation_station
