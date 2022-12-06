module arbiter
import rv32i_types::*;
import adaptor_types::*;
(
    input clk,
    input rst,

    // instruction cache
    input addr_t instr_cache_address,
    output line_t instr_pmem_to_cache,
    input line_t instr_cache_to_pmem,
    input logic instr_cache_read,
    input logic instr_cache_write,
    output logic instr_cache_resp,

    // data cache
    input addr_t data_cache_address,
    output line_t data_pmem_to_cache,
    input line_t data_cache_to_pmem,
    input logic data_cache_read,
    input logic data_cache_write,
    output logic data_cache_resp,

    // pmem
    input line_t pmem_to_cache,
    output line_t cache_to_pmem,
    output addr_t cache_address,
    output logic cache_read,
    output logic cache_write,
    input logic cache_resp
);

/**************************** DECLARATIONS ***********************************/
/*
line_t cache_to_pmem;
line_t instr_pmem_to_cache, data_pmem_to_cache;
addr_t cache_address;
logic cache_read, cache_write;
logic instr_cache_resp, data_cache_resp;
*/

enum logic [1:0] {
    NONE,
    INSTR,
    DATA,
    DONE
} state, next_state;

logic curr_req, random_sel;
/*****************************************************************************/

function void set_defaults();
    cache_to_pmem = '0;
    cache_address = 32'h00000000;
    cache_read = 1'b0;
    cache_write = 1'b0;
    instr_cache_resp = 1'b0;
    data_cache_resp = 1'b0;
endfunction

 
/*************************** STATE ASSIGNMENTS *******************************/
//FIXME: may have to hold the request information for a read in a buffer if
    //a simultaneous request occurs?
//FIXME: need to check if instr and data cache responses go high before
    //transitioning states
always_comb begin
    set_defaults();
    case (state)
    NONE: begin
    end
    INSTR: begin
        cache_to_pmem = instr_cache_to_pmem;
        cache_address = instr_cache_address;
        cache_read = instr_cache_read;
        cache_write = instr_cache_write;
        /*
        if (cache_resp) begin
            instr_pmem_to_cache = pmem_to_cache;
            instr_cache_resp = 1'b1;
        end
        */
    end
    DATA: begin
        cache_to_pmem = data_cache_to_pmem;
        cache_address = data_cache_address;
        cache_read = data_cache_read;
        cache_write = data_cache_write;
        /*
        if (cache_resp) begin
            data_pmem_to_cache = pmem_to_cache;
            data_cache_resp = 1'b1;
        end
        */
    end
    DONE: begin
        if (curr_req) begin
            instr_pmem_to_cache = pmem_to_cache;
            instr_cache_resp = 1'b1;
        end
        else begin
            data_pmem_to_cache = pmem_to_cache;
            data_cache_resp = 1'b1;
        end
    end
    endcase
end
/*****************************************************************************/

/*************************** NEXT STATE LOGIC ********************************/
always_comb begin
    next_state = state;
    case (state)
    NONE: begin
        if (random_sel) begin
            if (instr_cache_read) begin
                next_state = INSTR;
                random_sel = 1'b0;
                curr_req = 1'b1;
            end
            if (data_cache_read || data_cache_write) begin
                    next_state = DATA;
                    random_sel = 1'b1;
                    curr_req = 1'b0;
            end
        end
        else begin
            if (data_cache_read || data_cache_write) begin
                next_state = DATA;
                random_sel = 1'b1;
                curr_req = 1'b0;
            end
            if (instr_cache_read) begin
                next_state = INSTR;
                random_sel = 1'b0;
                curr_req = 1'b1;
            end
        end
    end
    INSTR: begin
        if (cache_resp) begin
            next_state = DONE;
        end
    end
    DATA: begin
        if (cache_resp) begin
            next_state = DONE;
        end

    end
    DONE: begin
        next_state = NONE;
    end
    endcase
end
/*****************************************************************************/


/************************* Non-Blocking Assignments **************************/
always_ff @(posedge clk) begin
    if (rst) begin
        state <= NONE;
    end
    else begin
        state <= next_state;
    end
end

endmodule : arbiter
