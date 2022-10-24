module iq
(
    input logic clk,
    input logic rst,
    input ctl_word control_word,
    input logic res1_valid,
    input logic res2_valid,
    input logic res3_valid,
    input logic res4_valid,
    input logic ldst_valid,
    input logic rob_full,

    output logic rob_load,
    output logic res1_load,
    output logic res2_load,
    output logic res3_load,
    output logic res4_load,
    output logic ldst_load,
    output ctl_word issued_control,
);

logic [3:0] res_snoop;
assign res_snoop = {res4_valid, res3_valid, res2_valid, res1_valid};

// if control_word.opcode == ld/st, check ldst_valid
    
fifo instruction_queue 
(
    .clk_i(clk),
    .reset_n_i(~rst),
    .data_i(control_word),
    .valid_i(enqueue),
    .ready_o(iq_full_n),
    .valid_o(iq_out_valid),
    .data_o(iq_out),
    .yumi_i(dequeue)
);

always_comb begin 
    dequeue = ((|res_snoop) && ~rob_full)? 1'b1 : 1'b0;
    enqueue = ((|res_snoop) && ~rob_full)? 1'b1 : 1'b0;
    case(res_snoop)
        4'b0001: begin
            res1_load = 1'b1;
        end
        4'b0010: begin
            res2_load = 1'b1;
        end
        4'b0100: begin
            res3_load = 1'b1;
        end
        4'b1000: begin
            res4_load = 1'b1;
        end
    endcase

    if (valid_o) begin
        issued_control = iq_out;
    end
end


endmodule : iq
