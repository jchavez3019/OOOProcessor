module iq
import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input ctl_word control_i,
    input logic res1_busy,
    input logic res2_busy,
    input logic res3_busy,
    input logic res4_busy,
    input logic resldst_busy,
    input logic rob_full,
    input logic ldst_q_full,

    output logic [2:0] regfile_tag1, 
    output logic [2:0] regfile_tag2,
    output logic rob_load,
    output logic res1_load,
    output logic res2_load,
    output logic res3_load,
    output logic res4_load,
    output logic resldst_load,
    output alu_res_word iq_o
);

logic [3:0] res_snoop;
logic ctl_word control_o;
assign res_snoop = {res4_busy, res3_busy, res2_busy, res1_busy};

    
fifo instruction_queue 
(
    .clk_i(clk),
    .reset_n_i(~rst),
    .data_i(control_i),
    .valid_i(enqueue),
    .ready_o(issue_q_full_n),
    .valid_o(control_o_valid),
    .data_o(control_o),
    .yumi_i(dequeue)
);

always_comb begin 
    // default values 
    res1_load = 1'b0;
    res2_load = 1'b0;
    res3_load = 1'b0;
    res4_load = 1'b0;
    enqueue = 1'b0;
    dequeue = 1'b0;

    // if the issue queue isn't full, add the instruction
    enqueue = issue_q_full_n ? 1'b1: 1'b0;
    // if the fifo is holding a valid entry
    if (control_o_valid) begin 
        // for load store instructions
        if (control_o.op == STORE || control_o.op == LOAD) begin
            resldst_load = (!resldst_busy && !rob_full && !ldst_q_full)? 1'b1 : 1'b0;
            dequeue = (!resldst_busy && !rob_full && !ldst_q_full)? 1'b1 : 1'b0;
            //TODO: set up reservation word for ldst instructions
        end
        else begin
            if (!rob_full) begin
                if (!(&res_snoop)) begin
                    // dequeue the instruction
                    dequeue = 1'b1;
                    // assemble the reservation word
                    iq_o.op = control_o.op; 
                    iq_o.funct3 = control_o.funct3;
                    // set by register file
                    iq_o.src1_tag = 3'b000;
                    iq_o.src1_data = 32'h00;
                    iq_o.src1_valid = 1'b0;
                    // set by register file
                    iq_o.src2_tag = 3'b000;

                    // if not, will be populated by register file
                    iq_o.src2_data = control_o.imm;
                    iq_o.src2_valid = 1'b0;
                    iq_o.rd = control_o.rd;
                
                    // send read signals to the regfile
                    regfile_tag1 = iq_o.src1_reg;
                    regfile_tag2 = iq_o.src2_reg;

                    // find out which reservation station to route to
                    priority case(res_snoop)
                        4'bxxx0: begin
                            res1_load = 1'b1;
                        end
                        4'bxx0x: begin
                            res2_load = 1'b1;
                        end
                        4'bx0xx: begin
                            res3_load = 1'b1;
                        end
                        4'b0xxx: begin
                            res4_load = 1'b1;
                        end
                    endcase
                end

            end
        end

        // rob logic is the same as dequeue, reuse here instead of rechecking
        rob_load = dequeue? 1'b1 : 1'b0;
    end
end


endmodule : iq
