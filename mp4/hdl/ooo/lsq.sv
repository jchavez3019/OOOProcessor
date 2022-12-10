module lsq
import rv32i_types::*;
(
    input clk,
    input rst, 
    input load,
    input flush_ip,
    input tomasula_types::res_word res_in,
    input tomasula_types::cdb_data cdb[8],
    output logic finished_entry,
    output tomasula_types::alu_word finished_entry_data,
    input logic [7:0] robs_calculated,
    output logic full,

    // signals between memory
    input data_mem_resp,
    output logic data_read,
    output logic data_write,
    output rv32i_word data_mem_address,
    output rv32i_word data_mem_wdata
);
// NOTE: for now this lsq will only handle loads, but should incorporate stores soon

/* 
** reasonably entries should be half the size of rob since loads are broken 
** into auipc and load, thus only at most 4 auipc's can be in rob 
*/
logic self_rst; // cases where lsq needs to reset itself
logic [1:0] head_ptr, curr_ptr;
logic addr_rdy [4];
logic entries_allocated [4];
tomasula_types::res_word entries [4];
assign data_write = 1'b0;

enum int unsigned {
    RESET = 0,
    IDLE = 1,
    ACTIVE = 2,
    FULL = 3, 
    FLUSH = 4
} lsq_state, lsq_next_state;

always_comb begin : assign_alu_output
    finished_entry_data.op = entries[head_ptr].op;
    finished_entry_data.funct3 = entries[head_ptr].funct3;
    finished_entry_data.funct7 = entries[head_ptr].funct7;
    finished_entry_data.src1_data = entries[head_ptr].src1_data;
    finished_entry_data.src2_data = entries[head_ptr].src2_data;
    finished_entry_data.pc = entries[head_ptr].pc;
    finished_entry_data.tag = entries[head_ptr].rd_tag;
end

always_ff @(posedge clk) begin
    if (rst | self_rst) begin
        for (int i = 0; i < 4; i++) begin : initialize_arrays
            addr_rdy[i] <= 1'b0;
            entries[i].op <= tomasula_types::BRANCH;
            entries[i].funct3 <= 3'b000;
            entries[i].funct7 <= 1'b0;
            entries[i].src1_tag <= 3'b000;
            entries[i].src1_data <= 32'h0000;
            entries[i].src1_valid <= 1'b0;
            entries[i].src2_tag <= 3'b000;
            entries[i].src2_data <= 32'h0000;
            entries[i].src2_valid <= 1'b0;
            entries[i].rd_tag <= 3'b000;
            entries[i].pc <= 32'h00000000;
            entries_allocated[i] <= 1'b0;
        end
        head_ptr <= 2'b00;
        curr_ptr <= 2'b00;
        lsq_state <= RESET;
    end
    else begin
        // update curr_ptr when allocating a new entries
        if (load & (lsq_state == ACTIVE | lsq_state == IDLE)) begin
            entries[curr_ptr].op <= res_in.op;
            entries[curr_ptr].funct3 <= res_in.funct3;
            entries[curr_ptr].funct7 <= res_in.funct7;
            entries[curr_ptr].src1_tag <= res_in.src1_tag;
            entries[curr_ptr].src1_data <= robs_calculated[res_in.src1_tag] ? cdb[res_in.src1_tag].data : res_in.src1_data;
            addr_rdy[curr_ptr] <= res_in.src1_valid | robs_calculated[res_in.src1_tag];
            entries[curr_ptr].src1_valid <= res_in.src1_valid | robs_calculated[res_in.src1_tag];
            entries[curr_ptr].src2_tag <= res_in.src2_tag;
            entries[curr_ptr].src2_data <= res_in.src2_data;
            entries[curr_ptr].src2_valid <= res_in.src2_valid;
            entries[curr_ptr].rd_tag <= res_in.rd_tag;
            entries[curr_ptr].pc <= res_in.pc;
            // entries[curr_ptr] <= res_in;
            curr_ptr <= curr_ptr + 1;
            entries_allocated[curr_ptr] <= 1'b1;
        end
        // update head ptr when entries in queue has finished using memory
        if (data_mem_resp & (lsq_state == ACTIVE | lsq_state == FULL)) begin
            head_ptr <= head_ptr + 1;
            entries_allocated[head_ptr] <= 1'b0;
            addr_rdy[head_ptr] <= 1'b0;
            entries[head_ptr].src1_valid <= 1'b0;
        end

        for (int i = 0; i < 4; i++) begin
            if (~addr_rdy[i] & robs_calculated[entries[i].src1_tag] & entries_allocated[i]) begin
                    entries[i].src1_data <= cdb[entries[i].src1_tag].data;
                    addr_rdy[i] <= 1'b1;
                    entries[i].src1_valid <= 1'b1;
            end 
        end

        lsq_state <= lsq_next_state;
    end
end

function void set_defaults();
    full = 1'b0;
    finished_entry = 1'b0;
    data_mem_address = 32'h00000000;
    self_rst = 1'b0;
    data_read = 1'b0;
endfunction

always_comb begin : actions
    set_defaults();

    case (lsq_state)
        RESET: begin
            full = 1'b1;
        end
        IDLE: begin
            if (flush_ip)
                self_rst = 1'b1;
        end
        ACTIVE: begin
            /* finished getting the data for the current entries */
            if (data_mem_resp) begin
                finished_entry = 1'b1;
            end

            /* address ready for head of queue, request data from memory */
            if (addr_rdy[head_ptr]) begin
                data_read = 1'b1;
                data_mem_address = entries[head_ptr].src1_data + entries[head_ptr].src2_data;
            end

            /* flush is in progress and we are requesting data */
            if (flush_ip & ~data_read)
                self_rst = 1'b1;
        end
        FULL: begin
            full = 1'b1;

            if (data_mem_resp)
                finished_entry = 1'b1;

            if (addr_rdy[head_ptr]) begin
                data_read = 1'b1;
                data_mem_address = entries[head_ptr].src1_data + entries[head_ptr].src2_data;
            end
        end
        FLUSH: begin
            full = 1'b1;
            data_read = 1'b1;
            if (data_mem_resp)
                self_rst = 1'b1;
        end
    endcase
end

always_comb begin : next_state_logic
    lsq_next_state = lsq_state;
    
    case (lsq_state)
        RESET: begin
            if (~rst)
                lsq_next_state = IDLE;
        end
        IDLE: begin
            if (flush_ip)
                lsq_next_state = RESET;
            if (load)
                lsq_next_state = ACTIVE;
        end
        ACTIVE: begin
            if (flush_ip & data_read & ~data_mem_resp)
                lsq_next_state = FLUSH;
            else if (curr_ptr == head_ptr + 2'b11)
                lsq_next_state = FULL;
            else if (data_mem_resp & (head_ptr == curr_ptr))
                lsq_next_state = IDLE;
        end
        FULL: begin
            if (flush_ip & data_read & ~data_mem_resp)
                lsq_next_state = FLUSH;
            else if (curr_ptr != head_ptr + 2'b11)
                lsq_next_state = ACTIVE;
        end
        FLUSH: begin
            // if (data_mem_resp)
            //     lsq_next_state = RESET;
        end
    endcase
end

endmodule