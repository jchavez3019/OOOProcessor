
module mp4
import rv32i_types::*;
(
    input clk,
    input rst,
	
	//Remove after CP1
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

	
	// For CP2
    /*
    input pmem_resp,
    input [63:0] pmem_rdata,

	//To physical memory
    output logic pmem_read,
    output logic pmem_write,
    output rv32i_word pmem_address,
    output [63:0] pmem_wdata
    */
);

/***************************************** Listing all signals *****************************************/
/* interface between instruction queue and instruction register */
IQ_2_IR iq_ir_itf();

/* pc signals */
logic ld_pc;
logic [31:0] pc;
logic [31:0] pc_calc; // this is the output of the ir register which does address calculation for branches

/* harness containing all module signals */
debug_itf itf();

/***************************************** Modules ***************************************************/

logic [31:0] regfile_mem_in;

`define mbe_calc(RES_STATION, OFFSET, DATA) \
    if (``RES_STATION.op == tomasula_types::ST) begin \
        if (``RES_STATION.tag == itf.head_ptr) begin \
            case(store_funct3_t'(``RES_STATION.funct3)) \
                sw: data_mbe = 4'b1111; \
                sh: data_mbe =  4'b0011 << ``OFFSET; \
                sb: data_mbe =  4'b0001 << ``OFFSET; \
            endcase \
        end \
    end \
    else if (``RES_STATION.op == tomasula_types::LD) begin \
        if (``RES_STATION.tag == itf.head_ptr) begin \
            case(load_funct3_t'(``RES_STATION.funct3)) \
                lw: regfile_mem_in = ``DATA; \
                lh: regfile_mem_in = {{16{``DATA[16 * ((``OFFSET/2)+1) - 1]}}, ``DATA[8 * ``OFFSET+:16]}; \
                lhu: regfile_mem_in = {{16{0}}, ``DATA[8 * ``OFFSET+:16]}; \
                lb: regfile_mem_in = {{24{``DATA[(8 * (``OFFSET+1)) - 1]}}, ``DATA[8 * ``OFFSET+:8]}; \
                lbu: regfile_mem_in = {{24{'0}}, ``DATA[8 * ``OFFSET+:8]}; \
                default: regfile_mem_in = ``DATA; \
            endcase \
        end \
    end

// only request memory on a commit, where address is on cdb
//
logic [1:0] memaddr_offset; 

always_comb begin : data_mem_req
    //data_mem_address = 32'h98;
    data_mem_address = {itf.cdb_out[itf.head_ptr].data[31:2], 2'b00};
    memaddr_offset = itf.cdb_out[itf.head_ptr].data[1:0];
    //memaddr_offset = 2'b0;

    // default byte enable value
    data_mbe = 4'b0000;
    `mbe_calc(itf.res1_alu_out, memaddr_offset, data_mem_rdata);
    `mbe_calc(itf.res2_alu_out, memaddr_offset, data_mem_rdata);
    `mbe_calc(itf.res3_alu_out, memaddr_offset, data_mem_rdata);
    `mbe_calc(itf.res4_alu_out, memaddr_offset, data_mem_rdata);
end


ir ir (
    .*,
    .clk(clk),
    .rst(rst),
    .instr_mem_resp(instr_mem_resp),
    .executing_jalr(1'b0),
    // .in(itf.in),
    .in(instr_mem_rdata),
    .pc(pc),
    .instr_mem_address(instr_mem_address),
    .instr_read(instr_read),
    .ld_pc(ld_pc),
    .pc_calc(pc_calc)
);

logic [31:0] pc_in;
always_comb begin : pc_mux
    if (ld_pc)
        pc_in = pc_calc;
    //if (itf.ld_br)    // idk what this is but im not gonna touch it \
    //    pc_in = itf.cdb_out[itf.head_ptr].data[31:0];
    
    // else 
    //     pc_in = pc + 4;
end

pc_register PC (
        .clk (clk),
        .rst (rst),
        .load(ld_pc | itf.ld_br),
        .in(pc_in),
        .out(pc)
);

iq iq (
    .*,
    .clk (clk),
    .rst (rst),
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
    .control_o(itf.control_o)
    // ,.iq_ir_itf(iq_ir_itf.IR_SIG)
    // .issue_q_full_n(itf.issue_q_full_n),
    // .ack_o(itf.ack_o)
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
end

rob rob (
     .*,
     .clk (clk),
     .rst (rst),
     .rob_load (itf.rob_load),
     .instr_type (itf.control_o.op),
     .rd (itf.control_o.rd),
     .st_src (itf.control_o.src1_reg),
     .branch_mispredict (1'b0),
     .data_mem_resp (data_mem_resp),
     .status_rob_valid (itf.status_rob_valid),
     .set_rob_valid (itf.set_rob_valid),
     .curr_ptr (itf.curr_ptr), 
     .head_ptr (itf.head_ptr), 
     .br_ptr (itf.br_ptr), 
     .rd_commit (itf.rd_commit),
     .st_src_commit (itf.st_src_commit),
     .regfile_load (itf.regfile_load),
     .rob_full (itf.rob_full),
     .ld_commit_sel (itf.ld_commit_sel),
     .ld_br (itf.ld_br),
     .data_read (data_read),
     .data_write (data_write)
 );

 /*rob
    //////////////////////////////////////////////////////
    // rob_tag | instr_type | rob_valid | rd | valid    //                                    //
    //                                                  //
    //                                                  //
    //                                                  //
    //////////////////////////////////////////////////////
 */


logic [31:0] regfile_in; 
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
    .allocate (itf.regfile_allocate), 
    .reg_allocate (itf.control_o.rd), // gets register to allocate from control word of instruction queue
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
    .data_out (data_mem_wdata)
);
tomasula_types::res_word res_word;
logic [31:0] src2_data;
logic src2_v;

logic taken;
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
    .alu_data(itf.res1_alu_out),
    .start_exe(itf.res1_exec),
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
    .alu_data(itf.res2_alu_out),
    .start_exe(itf.res2_exec),
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
    .alu_data(itf.res3_alu_out),
    .start_exe(itf.res3_exec),
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
    .alu_data(itf.res4_alu_out),
    .start_exe(itf.res4_exec),
    .res_empty(itf.res4_empty),
    .res_in(res_word)
);

alu alu4(
    .alu_word(itf.res4_alu_out),
    .cdb_data(itf.alu4_calculation)
);

reservation_station resbr(      // for branches
    .clk (clk),
    .rst(rst),
    .load_word(itf.resbr_load),
    .cdb(itf.cdb_out),
    .robs_calculated(itf.status_rob_valid),
    .alu_data(itf.resbr_alu_out),
    .start_exe(itf.resbr_exec),
    .res_empty(itf.resbr_empty),
    .res_in(res_word)
);

branch_alu CMP(
    .op(itf.resbr_alu_out.funct3),
    .first(itf.resbr_alu_out.src1_data),
    .second(itf.resbr_alu_out.src2_data),
    .answer(taken)
);

logic [7:0] cdb_enable;
always_comb begin : cdb_enable_logic
    // set default values to 0
    for (int i = 0; i < 8; i++) begin
        itf.cdb_in[i].data[31:0] = 32'h00000000;
    end
    itf.cdb_in[itf.res1_alu_out.tag].data[31:0] = itf.alu1_calculation.data[31:0];
    itf.cdb_in[itf.res2_alu_out.tag].data[31:0] = itf.alu2_calculation.data[31:0];
    itf.cdb_in[itf.res3_alu_out.tag].data[31:0] = itf.alu3_calculation.data[31:0];
    itf.cdb_in[itf.res4_alu_out.tag].data[31:0] = itf.alu4_calculation.data[31:0];

    // Data propogation for branch computation. All 1's if taken otherwise 0
    itf.cdb_in[itf.resbr_alu_out.tag].data[31:0] = {32{taken}};
    
    cdb_enable[7:0] = 8'h00 | (itf.res1_exec << itf.res1_alu_out.tag) | (itf.res2_exec << itf.res2_alu_out.tag) | (itf.res3_exec << itf.res3_alu_out.tag) | (itf.res4_exec << itf.res4_alu_out.tag) | (itf.resbr_exec << itf.resbr_alu_out.tag);
end

cdb cdb(
    .ctl(itf.cdb_in),
    .enable(cdb_enable),
    .rst(rst),
    .out(itf.cdb_out[0:7])
); 




endmodule : mp4
