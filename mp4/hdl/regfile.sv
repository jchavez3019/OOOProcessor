
module regfile
(
    input clk,
    input rst,
    input load,
    input allocate,
    input [31:0] in,
    input [4:0] src_a, src_b, dest,
    input [2:0] tag_in,
    output logic [31:0] reg_a, reg_b,
    output logic valid_a, valid_b,
    output logic [2:0] tag_a, tag_b, tag_dest,

    // signals for memory interaction
    input [4:0]src_c,
    output data_out
);

logic [31:0] data [32];
logic [2:0] tag [32];
logic valid [32];       // 0 means waiting for ROB to fill it up, 1 means its rdy

always_ff @(posedge clk)
begin
    if (rst)
    begin
        for (int i=0; i<32; i=i+1) begin
            data[i] <= '0;
            tag[i] <= '0;
            valid[i] = 1
        end
    end
    else if (load && dest)
    begin
        data[dest] <= in;
        valid[dest] <= 1;
    end

    else if(allocate && dest )
    begin
        valid[dest] <= 0;
        tag[dest] <= tag_in;
    end 

end

always_comb
begin
    // if ((dest == src_a) &&  allocate ) begin
    //     tag_a = tag_in;
    //     tag_b = tag[src_b];
    //     tag_dest = tag[dest];

    // end
    // else if ((dest == src_b) &&  allocate ) begin
    //     tag_b = tag_in;
    //     tag_a = tag[src_a];
    //     tag_dest = tag[dest];
    // end
    // else begin
    //     tag_a = tag[src_a];
    //     tag_b = tag[src_b];
    //     tag_dest = tag[dest];
    // end


    if((dest == src_a) && load ) begin
        reg_a = in;
        reg_b = src_b ? data[src_b] : 0;
        valid_a = 1;
        valid_b = valid[src_b];
    end

    else if((dest == src_b) && load) begin
        reg_a = src_a ? data[src_a] : 0;
        reg_b = in;
        valid_a = valid [src_a];
        valid_b = 1;
        tag_a = tag[src_a];
        tag_b = tag[src_b];
    end
    else  begin
        reg_a = src_a ? data[src_a] : 0;
        reg_b = src_b ? data[src_b] : 0;
        valid_a = valid [src_a];
        valid_b = valid [src_b];
    end

    tag_a = tag[src_a];
    tag_b = tag[src_b];
    
    data_out = dara[src_c];
    
end

endmodule : regfile
