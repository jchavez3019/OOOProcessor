
module ooo
import rv32i_types::*;
(
    input clk,
    input rst,
	
    input 					instr_mem_resp,
    input rv32i_word 	instr_mem_rdata,
	input 					data_mem_resp,
    input rv32i_word 	data_mem_rdata, 
    output logic 			instr_read,
	output rv32i_word 	instr_mem_address,
    output logic 			data_read,
    output logic 			data_write,
    output logic [3:0] 	data_mbe,
    output rv32i_word 	data_mem_address,
    output rv32i_word 	data_mem_wdata
);

/***************************************** Listing all signals *****************************************/
/* interface between instruction queue and instruction register */
IQ_2_IR iq_ir_itf();

/* pc signals */
logic [31:0] pc;
// logic [31:0] pc_calc; // this is the output of the ir register which does address calculation for branches

/* harness containing all module signals */
debug_itf itf();

/***************************************** Modules ***************************************************/

logic [31:0] regfile_mem_in;
/*
    case(store_funct3_t'(``RES_STATION.funct3)) \
        sw: data_mbe = 4'b1111; \
        sh: data_mbe =  4'b0011 << ``OFFSET; \
        sb: data_mbe =  4'b0001 << ``OFFSET; \
    endcase \
*/

`define mbe_calc(TYPE, OFFSET, DATA) \
        case(tomasula_types::op_t'(TYPE)) \
            tomasula_types::LW: regfile_mem_in = ``DATA; \
            tomasula_types::LH: regfile_mem_in = {{16{``DATA[16 * ((``OFFSET/2)+1) - 1]}}, ``DATA[8 * ``OFFSET+:16]}; \
            tomasula_types::LHU: regfile_mem_in = {{16{1'b0}}, ``DATA[8 * ``OFFSET+:16]}; \
            tomasula_types::LB: regfile_mem_in = {{24{``DATA[(8 * (``OFFSET+1)) - 1]}}, ``DATA[8 * ``OFFSET+:8]}; \
            tomasula_types::LBU: regfile_mem_in = {{24{1'b0}}, ``DATA[8 * ``OFFSET+:8]}; \
            default: regfile_mem_in = ``DATA; \
        endcase 

`define write_to_cdb(RES_STATION_EXEC, ALU_OUT, DATA_SEL, ALU_DATA) \
    if (``RES_STATION_EXEC) begin \
            itf.cdb_in[``ALU_OUT.tag].data[31:0] = ``DATA_SEL? ``ALU_OUT.pc : ``ALU_DATA; \
            itf.cdb_in[``ALU_OUT.tag].rs1_data[31:0] = ``ALU_OUT.src1_data[31:0]; \
            itf.cdb_in[``ALU_OUT.tag].rs2_data[31:0] = ``ALU_OUT.src2_data[31:0]; \
        end

// only request memory on a commit, where address is on cdb
//
logic [1:0] memaddr_offset; 

always_comb begin : data_mem_req
    data_mem_address = {itf.cdb_out[itf.head_ptr].data[31:2], 2'b00};
    memaddr_offset = itf.cdb_out[itf.head_ptr].data[1:0];
    
    // default byte enable value
    //wmask = 4'b0000;
    //`mbe_calc(itf.commit_type, memaddr_offset, data_mem_rdata);
    case(itf.commit_type) 
        tomasula_types::LW: regfile_mem_in = data_mem_rdata; 
        tomasula_types::LH: regfile_mem_in = {{16{data_mem_rdata[16 * ((memaddr_offset/2)+1) - 1]}}, data_mem_rdata[8 * memaddr_offset+:16]};
        tomasula_types::LHU: regfile_mem_in = {{16{1'b0}}, data_mem_rdata[8 * memaddr_offset+:16]}; 
        tomasula_types::LB: regfile_mem_in = {{24{data_mem_rdata[(8 * (memaddr_offset+1)) - 1]}}, data_mem_rdata[8 * memaddr_offset+:8]}; 
        tomasula_types::LBU: regfile_mem_in = {{24{1'b0}}, data_mem_rdata[8 * memaddr_offset+:8]}; 
        default: regfile_mem_in = data_mem_rdata; 
    endcase 


    /*
    `mbe_calc(itf.res2_alu_out, memaddr_offset, data_mem_rdata);
    `mbe_calc(itf.res3_alu_out, memaddr_offset, data_mem_rdata);
    `mbe_calc(itf.res4_alu_out, memaddr_offset, data_mem_rdata);
    */

end

/*
always_ff @(posedge clk) begin
    if (rst) begin 
        _data_mbe <= 4'b0000;
    end
    else begin
        if (regfile_allocate) begin
        end
        else begin
        end
    end
end
*/

fifo_synch_1r1w #(logic[31:0]) rvfi_instr_queue (
    .clk_i(clk),
    .reset_n_i(~rst),
    .data_i(itf.ir_instr),
    .valid_i(itf.iq_ir_ack),
    .ready_o(),
    .valid_o(),
    .data_o(),
    .yumi_i(itf.regfile_load)
);


ir ir (
    .*,
    .clk(clk),
    .rst(rst),
    .instr_mem_resp(instr_mem_resp),
    .in(instr_mem_rdata),
    .executed_jalr(itf.res1_jalr_executed | itf.res2_jalr_executed | itf.res3_jalr_executed | itf.res4_jalr_executed | itf.rob_ld_pc), // included rob_ld_pc to get out of jalr wait state
    .br_pr_take (1'b1),
    .flush_ip(itf.flush_in_prog),
    .pc(pc),
    .instr_mem_address(instr_mem_address),
    .instr_read(instr_read),
    .ld_pc(itf.ir_ld_pc),
    .pc_calc(itf.pc_calc),
    .iq_ack(itf.iq_ir_ack),
    .curr_instr(itf.ir_instr)


);

/* NOTE:  update rob logic for loading branches since it is necessary for branch mispredicts */
always_comb begin : pc_mux        
    if (itf.rob_ld_pc) // only happens for a branch mispredict
        itf.pc_in[31:0] = itf.cdb_out[itf.br_ptr].data[31:0];// - 4; // always works but fix later
    /* cases where jalr was calculated and we can finally unstall the pipeline */
    else if (itf.res1_jalr_executed)
        // itf.pc_in = itf.cdb_out[itf.res1_alu_out.pc].data[31:0];
        itf.pc_in[31:0] = itf.alu1_calculation.data[31:0];
    else if (itf.res2_jalr_executed)
        // itf.pc_in = itf.cdb_out[itf.res2_alu_out.pc].data[31:0];
        itf.pc_in[31:0] = itf.alu2_calculation.data[31:0];
    else if (itf.res3_jalr_executed)
        // itf.pc_in = itf.cdb_out[itf.res3_alu_out.pc].data[31:0];
        itf.pc_in[31:0] = itf.alu3_calculation.data[31:0];
    else if (itf.res4_jalr_executed)
        // itf.pc_in = itf.cdb_out[itf.res4_alu_out.pc].data[31:0];
        itf.pc_in[31:0] = itf.alu4_calculation.data[31:0];
    /* default */
    else
        itf.pc_in[31:0] = itf.pc_calc[31:0];
end

pc_register PC (
        .clk (clk),
        .rst (rst),
        .load(itf.ir_ld_pc | itf.rob_ld_pc | itf.res1_jalr_executed | itf.res2_jalr_executed | itf.res3_jalr_executed | itf.res4_jalr_executed),
        // .load(ld_pc),
        .in(itf.pc_in),
        // .in(itf.pc_calc),
        .out(pc)
    );

iq iq (
    .*,
    .clk (clk),
    .rst (rst | itf.flush_in_prog),
    // .control_i (itf.control_i),
    .res1_empty(itf.res1_empty),
    .res2_empty(itf.res2_empty),
    .res3_empty(itf.res3_empty),
    .res4_empty(itf.res4_empty),
    .rob_full(itf.rob_full),
    .resbr_empty(itf.resbr_empty),
    .resbr_load(itf.resbr_load),
    .rob_load(itf.rob_load),
    .regfile_allocate(itf.regfile_allocate),
    .res1_load(itf.res1_load),
    .res2_load(itf.res2_load),
    .res3_load(itf.res3_load),
    .res4_load(itf.res4_load),
    .control_o(itf.control_o),
    .ack_o(itf.iq_ir_ack),
    .original_instr(itf.original_instr),
    .instr_pc(itf.original_instr_pc),
    .instr_next_pc(itf.original_instr_next_pc),
    .rvfi_word(itf.rvfi_word)
);

always_comb begin : set_rob_valids
    for (int i = 0; i < 8; i++) begin
        itf.set_rob_valid[i] = 1'b0;
    end
    if (itf.res1_exec) begin
        itf.set_rob_valid[itf.res1_alu_out.tag] = 1'b1;
    end
    if (itf.res2_exec) begin
        itf.set_rob_valid[itf.res2_alu_out.tag] = 1'b1;
    end
    if (itf.res3_exec) begin
        itf.set_rob_valid[itf.res3_alu_out.tag] = 1'b1;
    end
    if (itf.res4_exec) begin
        itf.set_rob_valid[itf.res4_alu_out.tag] = 1'b1;
    end
    if (itf.resbr_exec) begin
        itf.set_rob_valid[itf.resbr_alu_out.tag] = 1'b1;
    end
end

rob rob (
     .*,
     .clk (clk),
     .rst (rst),
     .rob_load (itf.rob_load),
     .instr_type (itf.control_o.op),
     .rd (itf.control_o.rd),
     .st_src (itf.control_o.src2_reg),
    //  .branch_mispredict (1'b0),
     .data_mem_resp (data_mem_resp),
     .memaddr_offset (memaddr_offset),
     .status_rob_valid (itf.status_rob_valid),
     .set_rob_valid (itf.set_rob_valid),
     .allocated_rob_entries (itf.allocated_rob_entries),
     .br_entry(itf.resbr_alu_out.tag),
     .br_taken(itf.taken),
     .update_br(itf.resbr_update_br),
     .curr_ptr (itf.curr_ptr), 
     .head_ptr (itf.head_ptr), 
     .br_ptr (itf.br_ptr), 
     .br_flush_ptr(itf.br_flush_ptr),
     .flush_in_prog(itf.flush_in_prog),
     .reallocate_reg_tag(itf.rob_reallocate_reg_tags),
     .rd_commit (itf.rd_commit),
     .st_src_commit (itf.st_src_commit),
     .regfile_load (itf.regfile_load),
     .rob_full (itf.rob_full),
     .ld_commit_sel (itf.ld_commit_sel),
     .ld_pc (itf.rob_ld_pc),
     .data_read (data_read),
     .data_write (data_write),
     .wmask (data_mbe),
     .commit_type (itf.commit_type),
     .new_instr(itf.original_instr),
     .new_pc(itf.original_instr_pc),
     .new_next_pc(itf.original_instr_next_pc),
     .rvfi_word(itf.rvfi_word)
 );


logic [31:0] regfile_in, ld_data;
assign ld_data = 32'h600d600d;
always_comb begin 
    if (itf.ld_commit_sel) 
        regfile_in = regfile_mem_in;
    else 
        regfile_in = itf.cdb_out[itf.head_ptr].data[31:0];
end

regfile regfile (
    .*,
    .clk (clk),
    .rst (rst),
    .load (itf.regfile_load),
    .allocate (itf.rob_reallocate_reg_tags | itf.regfile_allocate), // rob_load from instruction queue, more appropiate to call it allocate
    .reg_allocate (itf.rob_reallocate_reg_tags ? itf.br_flush_ptr : itf.control_o.rd), // gets register to allocate from control word of instruction queue
    .in (regfile_in),
    // from iq - sources to read
    .src_a (itf.control_o.src1_reg),
    .src_b (itf.control_o.src2_reg),
    // from iq - dest to write to
    .dest (itf.rd_commit), 
    .tag_in (itf.curr_ptr),
    .reg_a (itf.reg_src1_data),
    .reg_b (itf.reg_src2_data),
    .valid_a (itf.src1_valid),
    .valid_b (itf.src2_valid),
    .tag_a (itf.tag_a),
    .tag_b (itf.tag_b),
    .src_c (itf.st_src_commit),
    .data_out (itf.regfile_data_out)
);

assign data_mem_wdata = itf.regfile_data_out << (memaddr_offset * 8);

tomasula_types::res_word res_word;
logic [31:0] src2_data;
logic src2_v;

assign src2_v = itf.src2_valid | itf.control_o.src2_valid;
assign src2_data = itf.control_o.src2_valid ? itf.control_o.src2_data : itf.reg_src2_data;

always_comb begin : assign_res_word
    res_word.op = itf.control_o.op;
    res_word.funct3 = itf.control_o.funct3;
    res_word.funct7 = itf.control_o.funct7;
    res_word.src1_tag = itf.tag_a;
    res_word.src1_data = itf.reg_src1_data;
    res_word.src1_valid = itf.src1_valid;
    res_word.src2_tag = itf.tag_b;
    res_word.src2_data = src2_data;
    res_word.src2_valid = src2_v;
    res_word.rd_tag = itf.curr_ptr;
    res_word.pc = itf.control_o.pc;
end

reservation_station res1(
    .clk (clk),
    .rst(rst),
    .load_word(itf.res1_load),
    .cdb(itf.cdb_out),
    .robs_calculated(itf.status_rob_valid),
    .allocated_rob_entries(itf.allocated_rob_entries),
    .alu_data(itf.res1_alu_out),
    .start_exe(itf.res1_exec),
    .jalr_executed(itf.res1_jalr_executed),
    .ld_pc_to_cdb(itf.res1_pc_to_cdb),
    .update_br(itf.res1_update_br),
    .res_empty(itf.res1_empty),
    .res_in(res_word)
);

alu alu1(
    .alu_word(itf.res1_alu_out),
    .cdb_data(itf.alu1_calculation)
);

reservation_station res2(
    .clk (clk),
    .rst(rst),
    .load_word(itf.res2_load),
    .cdb(itf.cdb_out),
    .robs_calculated(itf.status_rob_valid),
    .allocated_rob_entries(itf.allocated_rob_entries),
    .alu_data(itf.res2_alu_out),
    .start_exe(itf.res2_exec),
    .jalr_executed(itf.res2_jalr_executed),
    .ld_pc_to_cdb(itf.res2_pc_to_cdb),
    .update_br(itf.res2_update_br),
    .res_empty(itf.res2_empty),
    .res_in(res_word)
);

alu alu2(
    .alu_word(itf.res2_alu_out),
    .cdb_data(itf.alu2_calculation)
);

reservation_station res3(
    .clk (clk),
    .rst(rst),
    .load_word(itf.res3_load),
    .cdb(itf.cdb_out),
    .robs_calculated(itf.status_rob_valid),
    .allocated_rob_entries(itf.allocated_rob_entries),
    .alu_data(itf.res3_alu_out),
    .start_exe(itf.res3_exec),
    .jalr_executed(itf.res3_jalr_executed),
    .ld_pc_to_cdb(itf.res3_pc_to_cdb),
    .update_br(itf.res3_update_br),
    .res_empty(itf.res3_empty),
    .res_in(res_word)
);

alu alu3(
    .alu_word(itf.res3_alu_out),
    .cdb_data(itf.alu3_calculation)
);

reservation_station res4(
    .clk (clk),
    .rst(rst),
    .load_word(itf.res4_load),
    .cdb(itf.cdb_out),
    .robs_calculated(itf.status_rob_valid),
    .allocated_rob_entries(itf.allocated_rob_entries),
    .alu_data(itf.res4_alu_out),
    .start_exe(itf.res4_exec),
    .jalr_executed(itf.res4_jalr_executed),
    .ld_pc_to_cdb(itf.res4_pc_to_cdb),
    .update_br(itf.res4_update_br),
    .res_empty(itf.res4_empty),
    .res_in(res_word)
);

alu alu4(
    .alu_word(itf.res4_alu_out),
    .cdb_data(itf.alu4_calculation)
);

reservation_station res_br(      // for branches
    .clk (clk),
    .rst(rst),
    .load_word(itf.resbr_load),
    .cdb(itf.cdb_out),
    .robs_calculated(itf.status_rob_valid),
    .allocated_rob_entries(itf.allocated_rob_entries),
    .alu_data(itf.resbr_alu_out),
    .start_exe(itf.resbr_exec),
    .jalr_executed(itf.resbr_jalr_executed),
    .ld_pc_to_cdb(itf.resbr_pc_to_cdb),
    .update_br(itf.resbr_update_br),
    .res_empty(itf.resbr_empty),
    .res_in(res_word)
);

branch_alu CMP(
    .op(branch_funct3_t'(itf.resbr_alu_out.funct3)), // typecast func3 to rv32i type to suppress warning
    .first(itf.resbr_alu_out.src1_data),
    .second(itf.resbr_alu_out.src2_data),
    .answer(itf.taken)
);

logic [7:0] cdb_enable;
always_comb begin : cdb_enable_logic
    // set default values to 0
    for (int i = 0; i < 8; i++) begin
        itf.cdb_in[i].data[31:0] = 32'h00000000;
    end
    /* load cdb with alu outputs or pc in jal/jalr special cases */
    `write_to_cdb(itf.res1_exec, itf.res1_alu_out, itf.res1_pc_to_cdb, itf.alu1_calculation.data[31:0]);
    `write_to_cdb(itf.res2_exec, itf.res2_alu_out, itf.res2_pc_to_cdb, itf.alu2_calculation.data[31:0]);
    `write_to_cdb(itf.res3_exec, itf.res3_alu_out, itf.res3_pc_to_cdb, itf.alu3_calculation.data[31:0]);
    `write_to_cdb(itf.res4_exec, itf.res4_alu_out, itf.res4_pc_to_cdb, itf.alu4_calculation.data[31:0]);

    // Data propogation for branch computation. All 1's if taken otherwise 0
    `write_to_cdb(itf.resbr_exec, itf.resbr_alu_out, itf.resbr_update_br, 32'h00000000);
    
    cdb_enable[7:0] = 8'h00 | (itf.res1_exec << itf.res1_alu_out.tag) | (itf.res2_exec << itf.res2_alu_out.tag) | (itf.res3_exec << itf.res3_alu_out.tag) | (itf.res4_exec << itf.res4_alu_out.tag) | (itf.resbr_exec << itf.resbr_alu_out.tag);
end

cdb cdb(
    .ctl(itf.cdb_in),
    .enable(cdb_enable),
    .rst(rst),
    .out(itf.cdb_out[0:7])
); 




endmodule : ooo
