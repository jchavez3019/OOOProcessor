`ifndef iq
`define iq
module iq
import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    // input tomasula_types::ctl_word control_i,
    input logic res1_empty,
    input logic res2_empty,
    input logic res3_empty,
    input logic res4_empty,
    input logic resldst_empty,
    input logic rob_full,
    input logic ldst_q_full,
    input logic enqueue,

    output logic [4:0] regfile_tag1, // register one index in regfile
    output logic [4:0] regfile_tag2, // register two index in regfile
    output logic rob_load,
    output logic res1_load,
    output logic res2_load,
    output logic res3_load,
    output logic res4_load,
    output logic resldst_load,
    output tomasula_types::ctl_word control_o,
    // output logic issue_q_full_n,
    // output logic ack_o,

    IQ_2_IR.IQ_SIG iq_ir_itf
);
// logic ld_iq;
// assign ld_iq = iq_ir_interface.ld_iq;

logic [3:0] res_snoop;
logic control_o_valid, dequeue;
tomasula_types::ctl_word control_o_buf;
assign res_snoop = {res4_empty, res3_empty, res2_empty, res1_empty};

    
fifo_synch_1r1w #(.DTYPE(tomasula_types::ctl_word)) instruction_queue
(
    .clk_i(clk),
    .reset_n_i(~rst),
    // .data_i(control_i),
    .data_i(iq_ir_itf.control_word),
    .valid_i(enqueue),
    // .ready_o(issue_q_full_n),
    .ready_o(iq_ir_itf.issue_q_full_n),
    // .ack_o(ack_o),
    .ack_o(iq_ir_itf.ack_o),
    .valid_o(control_o_valid),
    .data_o(control_o_buf),
    .yumi_i(dequeue)
);

always_comb begin 
    // default values 
    res1_load = 1'b0;
    res2_load = 1'b0;
    res3_load = 1'b0;
    res4_load = 1'b0;
    dequeue = 1'b0;

    // if the fifo is holding a valid entry
    if (control_o_valid) begin 
        // for load store instructions
        if (control_o_buf.op == tomasula_types::ST || control_o_buf.op == tomasula_types::LD) begin
            resldst_load = (resldst_empty && !rob_full && !ldst_q_full)? 1'b1 : 1'b0;
            dequeue = (resldst_empty && !rob_full && !ldst_q_full)? 1'b1 : 1'b0;
            control_o = control_o_buf;
            //TODO: set up reservation word for ldst instructions
        end
        else begin
            if (!rob_full) begin
                if (res_snoop) begin
                    // dequeue the instruction
                    dequeue = 1'b1;
               
                    // send read signals to the regfile
                    regfile_tag1 = control_o_buf.src1_reg;
                    regfile_tag2 = control_o_buf.src2_reg;

                    // assign the output to the output of the queue
                    control_o = control_o_buf;

                    // find out which reservation station to route to
                    priority case(res_snoop)
                        4'bxxx1: begin
                            res1_load = 1'b1;
                        end
                        4'bxx1x: begin
                            res2_load = 1'b1;
                        end
                        4'bx1xx: begin
                            res3_load = 1'b1;
                        end
                        4'b1xxx: begin
                            res4_load = 1'b1;
                        end
                    endcase
                end

            end
        end

        // rob logic is the same as dequeue, reuse here instead of rechecking
        rob_load = dequeue;
    end
end


endmodule : iq

`endif
