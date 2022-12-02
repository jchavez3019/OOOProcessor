module branch_predictor #(
    parameter index = 10,
    parameter size = 2 ** index
)
import rv32i_types::*;
(  
    // input [31:0] pc,
    input clk,
    input rst,
    input read,
    input write,
    input logic [index-1:0] readidx,
    input logic [index-1:0] writeidx,
    input logic taken,
    // input logic correct,
    output logic pred
    );

logic [1:0] data [size-1:0] = '{default: 2'b01};
logic [1:0] temp_write;
// logic [1:0] temp_read;
    
always_comb begin

    if(write & read & (readidx == writeidx)) begin
        prediction = taken;
    end
    else if(write) begin
        if(taken)
            unique case (data[writeidx]) 
                2'b00: temp_write = 2'b01;
                2'b01: temp_write = 2'b10;
                2'b10: temp_write = 2'b11;
                2'b11: temp_write = 2'b11; 
            endcase
        else 
            unique case (data[writeidx]) 
                2'b00: temp_write = 2'b00;
                2'b01: temp_write = 2'b00;
                2'b10: temp_write = 2'b01;
                2'b11: temp_write = 2'b10; 
            endcase
    end
    else if(read)
        prediction = data[readidx][1];

end

always_ff @(posedge clk)
begin
    if(write) begin
        data[writeidx] <= temp_write;
    end
end



endmodule