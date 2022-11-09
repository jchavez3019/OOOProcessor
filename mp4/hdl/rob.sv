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

    // determines if rob entry has been computed
    // from reservation station
    input logic set_rob_valid[8],
    output logic [7:0] status_rob_valid,
    output logic [7:0] allocated_rob_entries,
    input logic [2:0] br_entry,
    input logic br_taken,
    input logic update_br,

    // to regfile
    output logic [2:0] curr_ptr,
    output logic [2:0] head_ptr,
    output logic [2:0] br_flush_ptr,
    output logic [2:0] br_ptr,
    output logic [4:0] rd_commit,
    output logic [4:0] st_src_commit,
    output logic regfile_load,
    output logic rob_full,

    // signal to select between using data from cdb or d-cache
    output ld_commit_sel,

    // determined by branch output
    output logic ld_pc,
    output logic flush_in_prog, // let other modules know that flush is in progress

    // to d-cache
    output logic data_read,
    output logic data_write
);

tomasula_types::op_t instr_arr [8];
logic [4:0] rd_arr [8];
logic valid_arr [8]; // indicates if an rob entry has its output calculated
logic _allocated_entries [8]; // indicates if an rob entry has been allocated or not
// logic [31:0] pc_addresses [8];

logic [4:0] _rd_commit, _st_src_commit;
logic flush_ip;
logic _ld_commit_sel;
logic _ld_pc;
logic _data_read, _data_write;
logic _regfile_load;
logic _rob_full;

logic [2:0] _curr_ptr, _head_ptr, _br_flush_ptr, _br_ptr;

logic branch_mispredict; // set high when branch is committing and there was a mispredict

assign flush_in_prog = flush_ip;

// assign rd_commit = _rd_commit;
assign rd_commit = rd_arr[_head_ptr];
assign st_src_commit = _st_src_commit;
assign ld_commit_sel = _ld_commit_sel;
assign ld_pc = _ld_pc;
assign data_read = _data_read;
assign data_write = _data_write;
assign regfile_load = _regfile_load;
assign rob_full = _rob_full;
assign curr_ptr = _curr_ptr;
assign head_ptr = _head_ptr;
assign br_flush_ptr = _br_flush_ptr;
assign br_ptr = _br_ptr;

assign _rob_full = _head_ptr + 3'h7 == _curr_ptr;

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
            _allocated_entries[i] = 1'b0;
        end
        _curr_ptr <= 3'b000;
        _head_ptr <= 3'b000;
        _br_flush_ptr <= 3'b000;
        _br_ptr <= 3'b000;
        flush_ip <= 1'b0;
    end

    else begin 
        for (int i = 0; i < 8; i++) begin
            if (set_rob_valid[i]) begin
                valid_arr[i] <= 1'b1;
            end
        end

        /* when branch wants to update rd for a branch taken/not taken */
        if (update_br)
            rd_arr[br_entry] <= rd_arr[br_entry] | {4'b0000,br_taken};

        if (rob_load) begin
           // allocate ROB entry 
           instr_arr[_curr_ptr] <= instr_type; 
           rd_arr[_curr_ptr] <= rd; 
           _allocated_entries[_curr_ptr] <= 1'b1; // indicate an entry has been issued for the curr ptr
           // do not allocate regfile entry for st
           if (instr_type == tomasula_types::ST) begin 
               rd_arr[_curr_ptr] <= st_src;
           end
           else if (instr_type != tomasula_types::BRANCH) begin
               // output to regfile
            //    _rd_commit <= rd;
           end
           else if (instr_type == tomasula_types::BRANCH) begin
            _br_ptr <= _curr_ptr;
           end
           // increment _curr_ptr
           //TODO: beware! overflow may cause errors
           _curr_ptr <= _curr_ptr + 1'b1;
        end

        // if the head of the rob has been computed
        if (valid_arr[_head_ptr] & ~flush_in_prog & ~branch_mispredict) begin
            // if(instr_arr[_head_ptr] == tomasula_types::BRANCH) begin
            // //    _ld_pc <= 1'b1; 
            // end
            if (instr_arr[_head_ptr] == tomasula_types::LD) begin
                // _data_read <= 1'b1;
                // make sure instruction is not committed until data returned
                // from d-cache...
                if (data_mem_resp) begin
                    // _data_read <= 1'b0;
                    valid_arr[_head_ptr] <= 1'b0;
                    _allocated_entries[_head_ptr] <= 1'b0;
                    // use d-cache data
                    // _ld_commit_sel <= 1'b1;
                    // _regfile_load <= 1'b1;
                    // _rd_commit <= rd_arr[_head_ptr];
                    // update head
                    _head_ptr <= _head_ptr + 1'b1;
                end
            end
            else if (instr_arr[_head_ptr] == tomasula_types::ST & ~flush_in_prog & ~branch_mispredict) begin
                // _data_write <= 1'b1;
                // for st address
                // send regfile the register file to read from
                _st_src_commit <= rd_arr[_head_ptr];
                // once store has been processed
                if (data_mem_resp) begin
                    // _data_write <= 1'b0;
                    valid_arr[_head_ptr] <= 1'b0;
                    _allocated_entries[_head_ptr] <= 1'b0;
                    _head_ptr <= _head_ptr + 1'b1;
                end
            end
            // for all other instructions
            else if (~flush_in_prog & ~branch_mispredict) begin
                // _regfile_load <= 1'b1;
                valid_arr[_head_ptr] <= 1'b0;
                _allocated_entries[_head_ptr] <= 1'b0;

                // increment _head_ptr
                // _rd_commit <= rd_arr[_head_ptr];
                _head_ptr <= _head_ptr + 1'b1;
            end
        end
        // branch mispredict handling
        if (branch_mispredict) begin
            flush_ip <= 1'b1;
            _br_flush_ptr <= valid_arr[_head_ptr] ? _head_ptr + 1'b1 : _head_ptr; // flush ptr should start at updated head pointer 
        end 
        // this doesn't start until the cycle after a branch mispredict has been found
        if (flush_ip) begin

            /* sacrifice a few cycles to delay head pointer from moving past branch */
            _head_ptr <= _head_ptr;

            if (instr_arr[_br_flush_ptr] == tomasula_types::BRANCH) begin
                // if we reached the branch, set the valid bit. 
                // will be committed on the next cycle
                // FIXME: im dont think the valid bit needs to be set here,
                // since at this point there was a branch already calculated
                // which has the valid bit set already
                // valid_arr[br_flush_ptr] = 1'b1; // should be valid and set to 0 once branch commits (no actions when branch gets commited)
                // flush all instructions after the branch
                /* start at entry after branch and exit once i equals head pointer */
                for (int i = (_br_flush_ptr + 1) % 8; i != _head_ptr; i = (i + 1) % 8) begin
                    valid_arr[i] <= 1'b0;
                    _allocated_entries[i] <= 1'b0;
                end
                // update current pointer
                _curr_ptr = _br_flush_ptr;
                // flush now finished processing
                flush_ip <= 1'b0;

            end
            // if we haven't reached the branch yet
            else begin
                // _rd_commit <= rd_arr[br_flush_ptr];
                _br_flush_ptr <= _br_flush_ptr + 1'b1;
            end
        end
    end
end

function void set_defaults();
    _ld_pc = 1'b0;
    _data_read = 1'b0;
    _ld_commit_sel = 1'b0;
    _regfile_load = 1'b0;
    _data_write = 1'b0;
    branch_mispredict = 1'b0;
endfunction

always_comb begin

            set_defaults();

            /* start flushing as soon as it's revealed to be a mispredict */
            if((instr_arr[_br_ptr] == tomasula_types::BRANCH) & (valid_arr[_br_ptr]) & (rd_arr[_br_ptr][1] != rd_arr[_br_ptr][0])) begin
            _ld_pc = 1'b1; 
            branch_mispredict = 1'b1;
            end
            if (flush_ip) begin

            end
            /* check if rob entry at head pointer has been calculated */
            if (instr_arr[_head_ptr] == tomasula_types::LD & ~flush_in_prog) begin
                _data_read = 1'b1;
                // make sure instruction is not committed until data returned
                // from d-cache...
                if (data_mem_resp) begin
                    _data_read = 1'b0;
                    // valid_arr[_head_ptr] <= 1'b0;
                    // use d-cache data
                    _ld_commit_sel = 1'b1;
                    _regfile_load = 1'b1;
                    // _rd_commit <= rd_arr[_head_ptr];
                    // update head
                    // _head_ptr <= _head_ptr + 1'b1;
                end
            end
            else if ((instr_arr[_head_ptr] == tomasula_types::ST) & (valid_arr[_head_ptr]) & ~flush_in_prog) begin
                _data_write = 1'b1;
                // for st address
                // send regfile the register file to read from
                // _st_src_commit <= rd_arr[_head_ptr];
                // once store has been processed
                if (data_mem_resp) begin
                    _data_write = 1'b0;
                    // valid_arr[_head_ptr] <= 1'b0;
                    // _head_ptr <= _head_ptr + 1'b1;
                end
            end
            // for all other instructions except branch since branch doesn't load regfile
            else if (valid_arr[_head_ptr] & (instr_arr[_head_ptr] != tomasula_types::BRANCH) & ~flush_in_prog) begin
                _regfile_load = 1'b1;
                // valid_arr[_head_ptr] <= 1'b0;

                // increment _head_ptr
                // _rd_commit <= rd_arr[_head_ptr];
                // _head_ptr <= _head_ptr + 1'b1;
            end

end

endmodule : rob
