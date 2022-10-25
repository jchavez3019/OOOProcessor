
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

	To physical memory
    output logic pmem_read,
    output logic pmem_write,
    output rv32i_word pmem_address,
    output [63:0] pmem_wdata
	*/

);


    ir IR (
        *, 
        .load(),
        .in(instr_mem_rdata),
        .control_word()
    );

    reservation_station res(
        *,
        .load_word(),
        .control_word(),
        .src1(),
        .src2(),
        .cdb(),
        .rob_tag1(),
        .rob_tag2(),
        .rob_v1(),
        .rob_v2(),
        .alu_free(),
        .alu_data(),
        .start_exe(),
        .res_empty()
    );

always_comb begin :

end

endmodule : mp4