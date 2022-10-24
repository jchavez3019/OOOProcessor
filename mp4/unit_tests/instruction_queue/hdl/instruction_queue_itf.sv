`ifndef instruction_queue_itf
`define instruction_queue_itf

interface instruction_queue_itf;
import rv32i_types::*;
bit clk, reset_n, res1_valid, res2_valid, res3_valid, res4_valid, resldst_valid, rob_full, ldst_q_full, rob_load, res1_load, res2_load, res3_load, res4_load, resldst_load;
tomasula_types::ctl_word control_i, control_o;

time timestamp;

task finish();
    repeat (100) @(posedge clk);
    $finish;
endtask : finish

// Generate clk signal
always #5 clk = (clk === 1'b0);

initial timestamp = '0;
always @(posedge clk) timestamp = timestamp + time'(1);

struct {
    logic read_error [time];
} stu_errors;

function automatic void tb_report_dut_error(error_e err);
    $display("%0t: TB: Reporting %s at %0t", $time, err.name, timestamp);
    case (err)
        READ_ERROR: stu_errors.read_error[timestamp] = 1'b1;
        default: $fatal("TB reporting Unknown error");
    endcase
endfunction

endinterface : instruction_queue_itf

`endif
