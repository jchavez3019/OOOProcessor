module cacheline_adaptor
import adaptor_types::*;
(
    input clk,
    input reset_n,

    // Port to LLC (Lowest Level Cache)
    input line_t line_i,
    output line_t line_o,
    input addr_t address_i,
    input logic read_i,
    input logic write_i,
    output logic resp_o,

    // Port to memory
    input burst_t burst_i,
    output burst_t burst_o,
    output addr_t address_o,
    output logic read_o,
    output logic write_o,
    input logic resp_i
);

/******************************** Declarations *******************************/
// Need memory to buffer read data
logic [line_width_p-1:0] readline;

// Need memory to buffer write data
logic [line_width_p-1:0] writeline;

// Which burst are we on
logic [2:0] read_burst_idx;
logic [2:0] write_burst_idx;

// States
enum logic [2:0] {NONE, START, BURST1, BURST2, BURST3, BURST4, DONE} read_state, next_read_state, write_state, next_write_state;

/*****************************************************************************/


/******************************** Assignments ********************************/
always_comb begin
    /* Default signals */
    resp_o = 1'b0;
    write_o = 1'b0;
    read_o = 1'b0;
    next_read_state = read_state;
    next_write_state = write_state;

    /* READ state machine */
    unique case(read_state)
        NONE: begin 
            if (read_i) begin
                next_read_state = BURST1;
            end
        end
        BURST1: begin 
            if (resp_i) begin
                next_read_state = BURST2;
            end 
        end
        BURST2: begin
            if (resp_i) begin
                next_read_state = BURST3;
            end
        end
        BURST3: begin
            if (resp_i) begin
                next_read_state = BURST4;
            end
        end
        BURST4: begin
            if (resp_i) begin
                next_read_state = DONE;
            end
        end
        DONE: begin
            next_read_state = NONE;
        end
        default : next_read_state = NONE;
    endcase
    
    /* READ signal assignment */
    case (read_state)
        NONE: begin
            read_o = 1'b0;
        end
        BURST1: begin
            read_o = 1'b1;
            address_o = address_i;
            readline[burst_width_p*0 +: burst_width_p] = burst_i;
        end
        BURST2: begin
            read_o = 1'b1;
            address_o = address_i;
            readline[burst_width_p*1 +: burst_width_p] = burst_i;
        end
        BURST3: begin
            read_o = 1'b1;
            address_o = address_i;
            readline[burst_width_p*2 +: burst_width_p] = burst_i;
        end
        BURST4: begin
            read_o = 1'b1;
            address_o = address_i;
            readline[burst_width_p*3 +: burst_width_p] = burst_i;
        end
        DONE: begin
            resp_o = 1'b1;
            line_o = readline;
        end

    endcase

    /* WRITE state machine */
    unique case(write_state)
        NONE: begin 
            if (write_i) begin
                next_write_state = START;
            end
        end
        START: begin
            next_write_state = BURST1;
        end
        BURST1: begin 
            if (resp_i) begin
                next_write_state = BURST2;
            end 
        end
        BURST2: begin
            if (resp_i) begin
                next_write_state = BURST3;
            end
        end
        BURST3: begin
            if (resp_i) begin
                next_write_state = BURST4;
            end
        end
        BURST4: begin
            if (resp_i) begin
                next_write_state = DONE;
            end
        end
        DONE: begin
            next_write_state = NONE;
        end
        default : next_write_state = NONE;
    endcase
    
    /* WRITE signal assignments */
    case (write_state)
        NONE: begin
            write_o = 1'b0;
        end
        START: begin
            writeline = line_i;
        end
        BURST1: begin
            write_o = 1'b1;
            address_o = address_i;
            burst_o = writeline[burst_width_p*0 +: burst_width_p];
        end
        BURST2: begin
            write_o = 1'b1;
            address_o = address_i;
            burst_o = writeline[burst_width_p*1 +: burst_width_p];
        end
        BURST3: begin
            write_o = 1'b1;
            address_o = address_i;
            burst_o = writeline[burst_width_p*2 +: burst_width_p];
        end
        BURST4: begin
            write_o = 1'b1;
            address_o = address_i;
            burst_o = writeline[burst_width_p*3 +: burst_width_p];
        end
        DONE: begin
            resp_o = 1'b1;
        end

    endcase


end 
/*****************************************************************************/



/************************* Non-Blocking Assignments **************************/
always_ff @(posedge clk) begin
    if (~reset_n) begin
        write_state <= NONE;
        read_state <= NONE;
    end 
    else begin
        write_state <= next_write_state;
        read_state <= next_read_state;
    end 
end 


/*****************************************************************************/

endmodule : cacheline_adaptor
