/* MODIFY. The cache controller. It is a state machine
that controls the behavior of the cache. */

module cache_control (

    input clk,
    input rst,
    // CPU TO CACHE
    input   logic mem_read,
    input   logic mem_write,

    // CACHE TO CPU
    output  logic mem_resp,

    // CACHE TO MEM
    output logic pmem_write,
    output logic pmem_read,

    //MEM TO CACHE
    input logic pmem_resp,

    // DATAPATH TO CONTROL
    input   logic hit,
    input   logic dirty,

    output  logic tag_load,
    output  logic lru_load,
    output  logic valid_load,
    output  logic dirty_load,

    input  logic [31:0] mem_byte_enable256,
    output  logic [31:0] data_write_en,

    output logic pmem_addr_sel

);

enum int unsigned {
    hold,
    lookup, 
    fill1,
    fill2,
    evict
} state, next_state;

/************************* Function Definitions *******************************/
function void set_defaults();
    mem_resp        = 1'b0;

    pmem_addr_sel   = 1'b0;
    pmem_write      = 1'b0;
    pmem_read       = 1'b0;

    tag_load        = 1'b0;
    lru_load        = 1'b0;
    valid_load      = 1'b0;
    dirty_load      = 1'b0;
    
    data_write_en   = 32'h00000000;
endfunction

/*****************************************************************************/

always_comb
begin : state_actions
    set_defaults();

    case (state) 
        hold : begin
            if (hit) begin
                lru_load = 1'b1;
            end
        end

        lookup : begin
            if(hit) begin
                if(mem_write) begin
                    dirty_load = 1'b1;
                    data_write_en = mem_byte_enable256;
                end
                //update lru on hit
                mem_resp = 1'b1;
            end
        end

        evict : begin
            // clear dirty 
            dirty_load = 1'b1;

            // set pmem_addr to evicted
            pmem_addr_sel = 1'b1;

            // send request to mem
            pmem_write = 1'b1;
        end

        fill1 : begin
            // fill with new line 

            data_write_en = 32'hffffffff; 

            // set pmem_addr to original request
            pmem_addr_sel = 1'b0;
            pmem_read = 1'b1;
        end

        // setting valid before pmem_resp
        // results in a premature "hit"
        fill2: begin
            tag_load = 1'b1;
            valid_load = 1'b1;
        end
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
        hold : begin
            if (mem_read || mem_write) begin
                next_state = lookup;
            end 
        end

        lookup : begin
            if (!hit && dirty) begin 
                next_state = evict;
            end

            else if (!hit && !dirty) begin
                next_state = fill1;
            end
            else if (hit) begin
                next_state = hold;
            end
        end 

        evict : begin
            if (pmem_resp) begin
                next_state = fill1;
            end
        end

        fill1 : begin
            if (pmem_resp) begin
                next_state = fill2;
            end
        end

        fill2: begin
            next_state = lookup;
        end
    endcase
end

always_ff @(posedge clk)
begin : next_state_assignment
    if (rst) begin
        state <= hold;
    end
    else begin
        state <= next_state;
    end
end
endmodule : cache_control
