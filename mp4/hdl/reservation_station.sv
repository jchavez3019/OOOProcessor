module reservation_station
import rv32i_types::*;
(
    input clk, 
    input rst, 
    input load_word,
    //input tomasula_types::ctl_word control_word,
    input logic [198:0] control_word,
    input [31:0] src1,
    input [31:0] src2,
    //input tomasula_types::cdb_data cdb,
    input logic [34:0] cdb,
    input [2:0] rob_tag1,
    input [2:0] rob_tag2, 
    input rob_v1,
    input rob_v2,
    input alu_free,
    // output tomasula_types::alu_word alu_data,
    output logic [73:0] alu_data,
    output start_exe,
    output res_empty
)

logic tomasula_types::alu_res_word res_word;
enum int unsigned {
    EMPTY = 0,
    LOAD  = 1,
    PEEK  = 2,
    EXEC  = 3
} state, next_state;


always_ff @(posedge clk)
begin
    if (rst)
    begin
        res_word <= '0;
        state <= EMPTY;
    end
    // now cover EMPTY cases
    else if (state == EMTPY)
    begin
        res_word <= control_word;
        state <= next_state;
    end
    // LOAD cases
    else if (state == LOAD)
    begin
        res_word.src1_data <= src1;
        res_word.src1_valid <= rob_v1;
        res_word.src1_rob_id <= rob_tag1;
        res_word.src2_data <= src2;
        res_word.src2_valid <= rob_v2;
        res_word.src2_rob_id <= rob_tag2;
        state <= next_state;
    end
    // PEEK cases
    else if (state == PEEK)
    begin
    if (cdb.tag == res_word.src1_rob_id)
    begin
        res_word.src1_data <= cdb.data;
        res_word.src1_valid <= 1'b1;
    end
    if (cdb.tag == res_word.src2_rob_id)
    begin
        res_word.src2_data <= cdb.data;
        res_word.src2_valid <= 1'b1;
    end
    state <= next_state;
    end
    // EXEC cases -- do nothing
    // else if (state == EXEC)
    // begin
    // end
    else
    begin
        state <= next_state;
    end
end

function void set_defaults();
    res_empty = 1'b0;
    start_exec = 1'b0;
endfunction

always_comb
begin : state_actions
    /* Default output assignments */
    set_defaults();

    /* Actions for each state */
    case(state)
        EMPTY: begin
            res_empty = 1'b1;
        end
        LOAD, PEEK: ; // do nothing
        EXEC: begin
            start_exe = 1'b1;
        end
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case (state)
        EMPTY: begin
            if (load_word)
                next_state = LOAD;
            else
                next_state = EMPTY;
        end
        LOAD, PEEK: begin
            /* if the source register data is ready and the alu unit is ready, start execution on next clk cycle */
            if (res_data.src1_valid & res_data.src2_valid & alu_free) 
                next_state = EXEC;
            else
                next_state = PEEK;
        end
        EXEC: next_state = EMPTY;
    endcase
end