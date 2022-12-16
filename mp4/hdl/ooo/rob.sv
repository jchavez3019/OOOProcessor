module rob
import rv32i_types::*;
(
    input clk, 
    input rst, 
    // from iq
    input rob_load,
    // from iq
    input tomasula_types::op_t instr_type,
    input [4:0] rd,
    input [4:0] st_src,
    // input [31:0] instr_pc,

    // when high, need to flush rob
    // input branch_mispredict, // remove later, rob will look at cdb/rd for branch mispredict

    // from d-cache
    input data_mem_resp,

    /* from instruction queue for rvfi monitor */
    input logic [31:0] new_instr,
    input logic [31:0] new_pc,
    input logic [31:0] new_next_pc,
    input rv32i_types::rvfi_word rvfi_wrd,
    // determines if rob entry has been computed
    // from reservation station
    input logic set_rob_valid[8],
    output logic [7:0] status_rob_valid,
    output logic [7:0] allocated_rob_entries, // need to output allocated entries so that when flush_ip, res station and lsq can check if their data has been invalidated
    output logic invalidated_n[8], // note that this is negated
    input logic [2:0] br_entry,
    input logic br_taken,
    input logic update_br,

    // to regfile
    output logic [2:0] curr_ptr,
    output logic [2:0] head_ptr,
    output logic [2:0] br_flush_ptr,
    output logic [2:0] br_ptr,
    output logic [4:0] rd_commit,
    output logic regfile_load,
    output logic rob_full,
    output logic [4:0] rd_updated,

    // signal to select between using data from cdb or d-cache
    output ld_commit_sel,

    // determined by branch output
    output logic ld_pc,
    output logic flush_in_prog, // let other modules know that flush is in progress
    output logic reallocate_reg_tag
);

tomasula_types::op_t instr_arr [8];
logic [4:0] rd_arr [8];
logic valid_arr [8]; // indicates if an rob entry has its output calculated
logic _allocated_entries [8]; // indicates if an rob entry has been allocated or not

/* data arrays and wires necessary for rvfi monitor */
logic [31:0] original_instr [8];
logic [31:0] instr_pc [8];
logic [31:0] instr_next_pc [8];
logic [31:0] curr_original_instr;
logic [31:0] curr_instr_pc;
logic [31:0] curr_instr_next_pc;
rv32i_types::rvfi_word rvfi_word_arr [8];
rv32i_types::rvfi_word curr_rvfi_word;
logic rvfi_commit;
logic [2:0] prev_head_ptr; // for comparison to check if instruction has committed
logic [4:0] _rd_commit, _st_src_commit;
logic flush_ip;
logic _ld_commit_sel;
logic _ld_pc;
logic _regfile_load;
logic _rob_full;

logic [2:0] _curr_ptr, _head_ptr, _br_flush_ptr, _br_ptr;

assign curr_original_instr = original_instr[_head_ptr];
assign curr_instr_pc = instr_pc[_head_ptr];
assign curr_instr_next_pc = instr_next_pc[_head_ptr];
assign curr_rvfi_word = rvfi_word_arr[_head_ptr];

logic branch_mispredict; // set high when branch is committing and there was a mispredict

assign flush_in_prog = flush_ip;

assign rd_commit = rd_arr[_head_ptr];
assign ld_commit_sel = _ld_commit_sel;
assign ld_pc = _ld_pc;
assign regfile_load = _regfile_load;
assign rob_full = _rob_full;
assign curr_ptr = _curr_ptr;
assign head_ptr = _head_ptr;
assign br_flush_ptr = _br_flush_ptr;
assign rd_updated = rd_arr[_head_ptr];

logic [2:0] fifo_br;
logic br_enqueue, br_dequeue, br_flush_rst, actual_br_rst;
assign actual_br_rst = rst | br_flush_rst;

fifo_synch_1r1w #(.DTYPE(logic[2:0])) branch_queue
(
    .clk_i(clk),
    .reset_n_i(~actual_br_rst),
    .data_i(curr_ptr),
    .valid_i(br_enqueue),
    .ready_o(),
    .valid_o(),
    .data_o(fifo_br),
    .yumi_i(br_dequeue)
);
// assign br_ptr = _br_ptr;
assign br_ptr = fifo_br;

/* 
** rob also considered full during branch mispredict and flushing process so 
** that new entries aren't allocated, preventing issues with curr ptr 
*/
assign _rob_full = (_head_ptr + 3'h7 == _curr_ptr) | branch_mispredict | flush_ip; // same as head ptr is one entry ahead of curr ptr

assign status_rob_valid[0] = valid_arr[0];
assign status_rob_valid[1] = valid_arr[1];
assign status_rob_valid[2] = valid_arr[2];
assign status_rob_valid[3] = valid_arr[3];
assign status_rob_valid[4] = valid_arr[4];
assign status_rob_valid[5] = valid_arr[5];
assign status_rob_valid[6] = valid_arr[6];
assign status_rob_valid[7] = valid_arr[7];

assign allocated_rob_entries[0] = _allocated_entries[0];
assign allocated_rob_entries[1] = _allocated_entries[1];
assign allocated_rob_entries[2] = _allocated_entries[2];
assign allocated_rob_entries[3] = _allocated_entries[3];
assign allocated_rob_entries[4] = _allocated_entries[4];
assign allocated_rob_entries[5] = _allocated_entries[5];
assign allocated_rob_entries[6] = _allocated_entries[6];
assign allocated_rob_entries[7] = _allocated_entries[7];



always_ff @(posedge clk) begin
    // _ld_pc <= 1'b0;
    // _ld_commit_sel <= 1'b0;
    // _regfile_load <= 1'b0;

    if (rst) begin
        for (int i=0; i<8; i++) begin
            instr_arr[i] <= tomasula_types::op_t'(0);
            rd_arr[i] <= '0;
            valid_arr[i] <= '0;
            _allocated_entries[i] <= 1'b0;

            /* reset rvfi arrays */
            original_instr[i] <= 32'h00000000;
            instr_pc[i] <= 32'h00000000;
            instr_next_pc[i] <= 32'h00000000;
            rvfi_word_arr[i].inst <= 32'h00000000;
            rvfi_word_arr[i].rs1_addr <= 5'b00000;
            rvfi_word_arr[i].rs2_addr <= 5'b00000;
            rvfi_word_arr[i].rd_addr <= 5'b00000;
            rvfi_word_arr[i].pc_rdata <= 32'h00000000;
            rvfi_word_arr[i].pc_wdata <= 32'h00000000;
        end
        _curr_ptr <= 3'b000;
        _head_ptr <= 3'b000;
        prev_head_ptr <= 3'b000;
        _br_flush_ptr <= 3'b000;
        _br_ptr <= 3'b000;
        flush_ip <= 1'b0;
        br_flush_rst <= 1'b0;
        // data_read <= 1'b0;
    end

    else begin
        for (int i = 0; i < 8; i++) begin
            /* reservation station informing rob that computation has been done, but can be lowered below by flush logic */
            if (set_rob_valid[i]) 
                valid_arr[i] <= 1'b1;
        end

        /* logic preventing from branches holding commit signal longer than one cycle */
        if (rvfi_commit)
            prev_head_ptr <= _head_ptr;
        else if (prev_head_ptr == _head_ptr)
            prev_head_ptr <= prev_head_ptr;
        else
            prev_head_ptr <= _head_ptr - 1;

        br_dequeue <= 1'b0;
        br_flush_rst <= 1'b0;

        /* ----- ALLOCATE -----*/
        /* when branch wants to update rd for a branch taken/not taken */
        if (update_br)
            rd_arr[br_entry] <= rd_arr[br_entry] | {4'b0000,br_taken};

        /* 
        **because of rob_full logic, if branch_mispredict happend in the previous cycle, 
        **rob_load can't be sent since instruction queue should stall thus no new allocates should be happening
        */
        if (rob_load) begin
           // stored to handle memory and branching
           instr_arr[_curr_ptr] <= instr_type; 

           // store - need to save register that holds data
           rd_arr[_curr_ptr] <= rd; 
           _allocated_entries[_curr_ptr] <= 1'b1; // indicate an entry has been issued for the curr ptr
           /* load necessary data for rvfi monitor */
           original_instr[_curr_ptr] <= new_instr;
           instr_pc[_curr_ptr] <= new_pc;
           instr_next_pc[_curr_ptr] <= new_next_pc;
           rvfi_word_arr[_curr_ptr] <= rvfi_wrd;
           // do not allocate regfile entry for st
           if (instr_type > 7 && instr_type < 11) begin 
               rd_arr[_curr_ptr] <= st_src;
           end
           // branch - hold taken/not taken (initialized to not taken)
           else if (instr_type == tomasula_types::BRANCH) begin 
            //    _br_ptr <= _curr_ptr;
           end
           // increment _curr_ptr
           //TODO: beware! overflow may cause errors
           _curr_ptr <= _curr_ptr + 1'b1;
        end


        /* indicates that branch mispredict was calculated in the previous cycle and use this cycle to prepare for flushes
        ** in the next cycle
        */
        if (branch_mispredict) begin
            flush_ip <= 1'b1;
            // _br_flush_ptr <= (valid_arr[_head_ptr] & (instr_arr[_br_flush_ptr] != tomasula_types::BRANCH)) ? _head_ptr + 1'b1 : _head_ptr; // flush ptr should start at updated head pointer 
            _br_flush_ptr <= _head_ptr; // since _head_ptr can't get updated in this state or the flush_ip state, can safely set _br_flush_ptr to head pointer
            // _br_ptr <= fifo_br;
        end 
        // this doesn't start until two cycles after branch mispredict was found since previous cycle prepares for this logic
        else if (flush_ip) begin

            /* redundant but highlighting the fact that _head_ptr will not get updated */
            _head_ptr <= _head_ptr;

            /* invalidate entries starting from branch pointer to entry right before head pointer */
            // for (int i = br_ptr; i != _head_ptr; i = (i + 1) % 8) begin
            for (logic [2:0] i = br_ptr + 1; i != _head_ptr; i = i + 1) begin
                _allocated_entries[i] <= 1'b0;
                valid_arr[i] <= 1'b0;
            end

            /* also invalidate the current branch since we are dealing with it now */
            _allocated_entries[br_ptr] <= 1'b0;
            valid_arr[br_ptr] <= 1'b0;

            /* correct tags in the register file */
            /* this should be done in combinational logic */
            // if (_br_flush_ptr != br_ptr) begin
            //     if (instr_arr[_br_flush_ptr] != tomasula_types::ST | instr_arr[_br_flush_ptr] != tomasula_types::BRANCH) begin
            //         reallocate_reg_tag = 1'b1;
            //     end

            // end

            /* check if done flushing, else update current branch flush pointer */
            if (_br_flush_ptr == br_ptr) begin
                flush_ip <= 1'b0;
                br_dequeue <= 1'b1;
                // if (instr_arr[_head_ptr] == tomasula_types::BRANCH) begin
                if (_head_ptr == br_ptr) begin
                    _curr_ptr <= br_ptr + 1;
                    _head_ptr <= _head_ptr + 1;
                    br_flush_rst <= 1'b1;
                end
                else
                    _curr_ptr <= br_ptr;
            end
            else 
                _br_flush_ptr <= _br_flush_ptr + 1'b1;

        end
        /* if not dealing with flushes, go back to committing instructions */
        else begin
            // if the head of the rob has been computed
            if (valid_arr[_head_ptr] & ~flush_in_prog & ~branch_mispredict) begin

                if (instr_arr[_head_ptr] == tomasula_types::BRANCH) begin
                    valid_arr[_head_ptr] <= 1'b0;
                    _allocated_entries[_head_ptr] <= 1'b0;
                    _head_ptr <= _head_ptr + 1'b1;
                    br_dequeue <= 1'b1;
                end
                // for all other instructions
                else begin
                    valid_arr[_head_ptr] <= 1'b0;
                    _allocated_entries[_head_ptr] <= 1'b0;
                    _head_ptr <= _head_ptr + 1'b1;
                end
            end
        end
    end
end

function void set_defaults();
    _ld_pc = 1'b0;
    _ld_commit_sel = 1'b0;
    _regfile_load = 1'b0;
    branch_mispredict = 1'b0;
    reallocate_reg_tag = 1'b0;
    rvfi_commit = 1'b0;
    br_enqueue = 1'b0;

    for (int i = 0; i < 8; i++) begin
        invalidated_n[i] = 1'b1;
    end
endfunction

always_comb begin

            set_defaults();

            /* need to output the entries that are now invalidated */
            if (flush_in_prog) begin
                // for (int i = br_ptr; i != _head_ptr; i = (i + 1) % 8) begin
                for (logic [2:0] i = br_ptr + 1; i != _head_ptr; i = i + 1) begin
                    invalidated_n[i] = 1'b0;
                end
            end

            if (instr_type == tomasula_types::BRANCH & rob_load) begin
                br_enqueue = 1'b1;
            end

            /* start flushing as soon as branch at head pointer is revealed to be a mispredict */
            if((instr_arr[fifo_br] == tomasula_types::BRANCH) & _allocated_entries[fifo_br] & (valid_arr[fifo_br]) & (rd_arr[fifo_br][1] != rd_arr[fifo_br][0]) & ~flush_ip & fifo_br == _head_ptr) begin
                _ld_pc = 1'b1; 
                branch_mispredict = 1'b1;
            end

            /* if flush is in progress, reallocate tags in register file */
            if ((_br_flush_ptr != br_ptr) & flush_ip) begin
                if (instr_arr[_br_ptr] > 7 && instr_arr[_br_ptr] < 11| instr_arr[_br_flush_ptr] != tomasula_types::BRANCH)
                    reallocate_reg_tag = 1'b1;
            end

            /* check if rob entry at head pointer has been calculated and handle all instruction types */

            if (valid_arr[_head_ptr] & _allocated_entries[_head_ptr] & ~flush_in_prog & ~branch_mispredict) begin

                if (instr_arr[_head_ptr] != tomasula_types::BRANCH & (instr_arr[_head_ptr] < 8 | instr_arr[_head_ptr] > 10)) begin
                    _regfile_load = 1'b1;
                end
                /* check that the instruction is not a store */
                if (prev_head_ptr != _head_ptr)
                    rvfi_commit = 1'b1; // ROB has committed an instruction
            end

end

endmodule : rob
