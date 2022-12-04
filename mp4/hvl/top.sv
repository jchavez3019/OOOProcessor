module mp4_tb;
`timescale 1ns/10ps

/********************* Do not touch for proper compilation *******************/
// Instantiate Interfaces
tb_itf itf();
rvfi_itf rvfi(itf.clk, itf.rst);

// Instantiate Testbench
source_tb tb(
    .magic_mem_itf(itf),
    .mem_itf(itf),
    .sm_itf(itf),
    .tb_itf(itf),
    .rvfi(rvfi)
);

// Dump signals
initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, mp4_tb, "+all");
end
/****************************** End do not touch *****************************/


/************************ Signals necessary for monitor **********************/
// This section not required until CP2

// assign rvfi.commit = dut.rob.regfile_load; // Set high when a valid instruction is modifying regfile or PC
assign rvfi.commit = dut.rob.rvfi_commit;
assign rvfi.halt = 0; //   
initial rvfi.order = 0;
always @(posedge itf.clk iff rvfi.commit) rvfi.order <= rvfi.order + 1; // Modify for OoO


assign rvfi.load_regfile = dut.rob.regfile_load;

//Instruction and trap:
// assign rvfi.inst = dut.ir.data;
// assign rvfi.inst = dut.rvfi_instr_queue.data_o;
// assign rvfi.inst = dut.rob.curr_original_instr;
assign rvfi.inst = dut.rob.curr_rvfi_word.inst;
assign rvfi.trap = 1'b0;




// registers and pc for architectural state tracking
// assign rvfi.rs1_addr =  dut.regfile.src_a;
// assign rvfi.rs2_addr =  dut.regfile.src_b;
// assign rvfi.rs1_rdata = dut.regfile.reg_a;
// assign rvfi.rs2_rdata = dut.regfile.reg_b;
// assign rvfi.rd_addr =   dut.regfile.dest;
assign rvfi.rd_wdata =  dut.regfile.in;
// assign rvfi.pc_rdata = dut.rob.curr_instr_pc;
// assign rvfi.pc_wdata = dut.rob.curr_instr_next_pc;

assign rvfi.rs1_addr =  dut.rob.curr_rvfi_word.rs1_addr;
assign rvfi.rs2_addr =  dut.rob.curr_rvfi_word.rs2_addr;
assign rvfi.rs1_rdata = 32'h00000000;
assign rvfi.rs2_rdata = 32'h00000000;
assign rvfi.rd_addr =   dut.rob.curr_rvfi_word.rd_addr;
assign rvfi.pc_rdata = dut.rob.curr_instr_pc;
// assign rvfi.pc_wdata = dut.rob.curr_instr_next_pc;

always_comb
begin : pc_next
    if (dut.rob.curr_rvfi_word.inst[6:0] == 7'b1100011)
        rvfi.pc_wdata = dut.rob.curr_rvfi_word.pc_wdata;
    else begin
        if (dut.itf.rob_ld_pc) // only happens for a branch mispredict
            rvfi.pc_wdata = dut.itf.cdb_out[dut.itf.br_ptr].data[31:0] - 4; // always works but fix later
        /* cases where jalr was calculated and we can finally unstall the pipeline */
        else if (dut.itf.res1_jalr_executed)
            // itf.pc_in = itf.cdb_out[itf.res1_alu_out.pc].data[31:0];
            rvfi.pc_wdata = dut.itf.alu1_calculation.data[31:0];
        else if (dut.itf.res2_jalr_executed)
            // itf.pc_in = itf.cdb_out[itf.res2_alu_out.pc].data[31:0];
            rvfi.pc_wdata = dut.itf.alu2_calculation.data[31:0];
        else if (dut.itf.res3_jalr_executed)
            // itf.pc_in = itf.cdb_out[itf.res3_alu_out.pc].data[31:0];
            rvfi.pc_wdata = dut.itf.alu3_calculation.data[31:0];
        else if (dut.itf.res4_jalr_executed)
            // itf.pc_in = itf.cdb_out[itf.res4_alu_out.pc].data[31:0];
            rvfi.pc_wdata = dut.itf.alu4_calculation.data[31:0];
        else
            rvfi.pc_wdata = dut.rob.curr_instr_next_pc;
    end

end


/*
Instruction and trap:
    rvfi.inst
    rvfi.trap

Regfile:
    rvfi.rs1_addr
    rvfi.rs2_add
    rvfi.rs1_rdata
    rvfi.rs2_rdata
    rvfi.load_regfile
    rvfi.rd_addr
    rvfi.rd_wdata

PC:
    rvfi.pc_rdata
    rvfi.pc_wdata

Memory:
    rvfi.mem_addr
    rvfi.mem_rmask
    rvfi.mem_wmask
    rvfi.mem_rdata
    rvfi.mem_wdata

Please refer to rvfi_itf.sv for more information.
*/

/**************************** End RVFIMON signals ****************************/

/********************* Assign Shadow Memory Signals Here *********************/
// This section not required until CP2
/*
The following signals need to be set:
icache signals:
    itf.inst_read
    itf.inst_addr
    itf.inst_resp
    itf.inst_rdata

dcache signals:
    itf.data_read
    itf.data_write
    itf.data_mbe
    itf.data_addr
    itf.data_wdata
    itf.data_resp
    itf.data_rdata

Please refer to tb_itf.sv for more information.
*/

/*********************** End Shadow Memory Assignments ***********************/

// Set this to the proper value
assign itf.registers = '{default: '0};

/*********************** Instantiate your design here ************************/
/*
The following signals need to be connected to your top level for CP2:
Burst Memory Ports:
    itf.mem_read
    itf.mem_write
    itf.mem_wdata
    itf.mem_rdata
    itf.mem_addr
    itf.mem_resp

Please refer to tb_itf.sv for more information.
*/

mp4 dut(
    .clk(itf.clk),
    .rst(itf.rst),
    
     // Remove after CP1
    .instr_mem_resp(itf.inst_resp),
    .instr_mem_rdata(itf.inst_rdata),
	.data_mem_resp(itf.data_resp),
    .data_mem_rdata(itf.data_rdata),
    .instr_read(itf.inst_read),
	.instr_mem_address(itf.inst_addr),
    .data_read(itf.data_read),
    .data_write(itf.data_write),
    .data_mbe(itf.data_mbe),
    .data_mem_address(itf.data_addr),
    .data_mem_wdata(itf.data_wdata)


    /* Use for CP2 onwards
    .pmem_read(itf.mem_read),
    .pmem_write(itf.mem_write),
    .pmem_wdata(itf.mem_wdata),
    .pmem_rdata(itf.mem_rdata),
    .pmem_address(itf.mem_addr),
    .pmem_resp(itf.mem_resp)
    */
);
/***************************** End Instantiation *****************************/

endmodule
