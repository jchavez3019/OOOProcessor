module rob
import rv32i_types::*;
(
    input clk, 
    input rst, 
    // snoop cdb
    input tomasula_types::cdb_data cdb,
    // from iq
    input rob_load,
    // from iq
    input op_t instr_type,
    input [4:0] rd,

    // when high, need to flush rob
    input branch_mispredict,

    // determines if rob entry has been computed
    // from reservation station
    input rob0_valid,
    input rob1_valid,
    input rob2_valid,
    input rob3_valid,
    input rob4_valid,
    input rob5_valid,
    input rob6_valid,
    input rob7_valid,

    // to regfile
    output [2:0] rob_tag,
    output regfile_allocate,
    output regfile_load,
    output rob_full
);

op_t instr_arr [8];
logic [4:0] rd_arr [8];
logic valid_arr [8];

logic [2:0] rob_curr;
logic [2:0] rob_head;

assign rob_full = (rob_head + 7) % 8 == rob_curr;

// TODO: LD/ST handling, Branch Mispredict handling

always_ff @(posedge clk) begin
    valid_arr[0] = rob0_valid;
    valid_arr[1] = rob1_valid;
    valid_arr[2] = rob2_valid;
    valid_arr[3] = rob3_valid;
    valid_arr[4] = rob4_valid;
    valid_arr[5] = rob5_valid;
    valid_arr[6] = rob6_valid;
    valid_arr[7] = rob7_valid;

    if (rst) begin
        for (int i=0; i<8; i++) begin
            instr_arr[i] <= '0;
            rd_arr[i] <= '0;
            valid_arr[i] <= 0;
            branch_arr[i] <= 0;
        end
        rob_curr <= 3'b000;
        rob_head <= 3'b000;
    end

    else begin 
        if (rob_load) begin
           // allocate ROB entry 
           instr_arr[rob_curr] <= instr_type; 
           rd_arr[rob_curr] <= rd; 
           // output to regfile
           rob_tag <= rob_curr;
           regfile_allocate <= 1'b1;
           // increment rob_curr
           rob_curr <= (rob_curr + 1) % 8;
        end

        // if the head of the rob has been computed
        if (valid_arr[rob_head]) begin
            regfile_load <= 1'b1;
            valid_arr[rob_head] <= 1'b0;
            // increment rob_head
            rob_head = (rob_head + 1) % 8;
        end

    end

end

endmodule : rob
