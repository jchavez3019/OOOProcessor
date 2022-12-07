/* MODIFY. The cache datapath. It contains the data,
valid, dirty, tag, and LRU arrays, comparators, muxes,
logic gates and other supporting logic. */

module cache_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
    input clk,
    input rst,

    // CPU TO CACHE 
    input   logic [31:0] mem_address,
    input   logic [255:0] bus_to_cache,

    // CACHE TO CPU 
    output  logic [255:0] cache_to_bus,

    // FROM MEM TO CACHE 
    input   logic [255:0] pmem_rdata,

    // FROM CACHE TO MEM
    output   logic [255:0] pmem_wdata,

    // FROM CACHE TO MEM
    output  logic [31:0] pmem_address,

    // DATAPATH TO CONTROL
    output logic hit,
    output logic dirty,

    input  logic tag_load,
    input  logic lru_load,
    input  logic valid_load,
    input  logic dirty_load,

    input  logic [31:0] data_write_en,
    input  logic pmem_addr_sel

);

/***************************** Address Hash *******************************/
logic [s_tag-1:0]       tag;
logic [s_index-1:0]     index;
logic [s_offset-1:0]    offset;
assign {tag, index, offset} = mem_address;

/**************************************************************************/

/******************************** Wires ***********************************/
// array input/outputs
logic [23:0] tag0_in;
logic [23:0] tag1_in;
logic [23:0] tag0_out;
logic [23:0] tag1_out;

logic lru;

logic valid0_in;
logic valid1_in;
logic valid0_out;
logic valid1_out;

logic dirty0_in;
logic dirty1_in;
logic dirty0_out;
logic dirty1_out;

logic [255:0] data0_in;
logic [255:0] data1_in;
logic [255:0] data0_out;
logic [255:0] data1_out;


// wires for combinational logic
logic tag0_comp;
logic tag1_comp;

logic tag0_comp_valid;
logic tag1_comp_valid;

logic way_sel;

logic [23:0] pmem_tag;

logic [31:0] data0_write_en;
logic [31:0] data1_write_en;
/**************************************************************************/

/******************************** Arrays **********************************/
array #(.width(24)) tag_way0 (
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(tag_load&(~lru)),
    .rindex(index),
    .windex(index),
    .datain(tag),
    .dataout(tag0_out) 
);

array #(.width(24)) tag_way1 (
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(tag_load&lru),
    .rindex(index),
    .windex(index),
    .datain(tag),
    .dataout(tag1_out) 
);

array lru_way(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(lru_load),
    .rindex(index),
    .windex(index),
    .datain(~(way_sel)),
    .dataout(lru) 
);

array valid_way0(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(valid_load&(~lru)),
    .rindex(index),
    .windex(index),
    .datain(1'b1),
    .dataout(valid0_out) 
);

array valid_way1(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(valid_load&lru),
    .rindex(index),
    .windex(index),
    .datain(1'b1),
    .dataout(valid1_out) 
);

array dirty_way0(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(dirty_load&(~lru)),
    .rindex(index),
    .windex(index),
    .datain(dirty0_in),
    .dataout(dirty0_out) 
);

array dirty_way1(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(dirty_load&lru),
    .rindex(index),
    .windex(index),
    .datain(dirty1_in),
    .dataout(dirty1_out) 
);

data_array data_way0(
    .clk(clk),
    .read(1'b1),
    .write_en(data0_write_en),
    .rindex(index),
    .windex(index),
    .datain(data0_in),
    .dataout(data0_out) 
);

data_array data_way1(
    .clk(clk),
    .read(1'b1),
    .write_en(data1_write_en),
    .rindex(index),
    .windex(index),
    .datain(data1_in),
    .dataout(data1_out) 
);

/*****************************************************************************/

/************************** Combinational Logic  *****************************/
// TAG
always_comb begin : TAG_COMP
    // tag comparison
    tag0_comp = (tag == tag0_out)? 1'b1: 1'b0;
    tag1_comp = (tag == tag1_out)? 1'b1: 1'b0;

    // is it valid?
    tag0_comp_valid = tag0_comp & valid0_out;
    tag1_comp_valid = tag1_comp & valid1_out;

    // hit?
    hit = tag0_comp_valid | tag1_comp_valid;
end

// WAY SELECT
always_comb begin : WAY_SELECT
    case(hit) 
        1'b0 : begin
            way_sel = lru;
        end
        1'b1 : begin 
            if (tag0_comp_valid) begin
                way_sel = 1'b0;
            end
            else if (tag1_comp_valid) begin
                way_sel = 1'b1;
            end
        end
    endcase
    case(pmem_addr_sel) 
        1'b0: pmem_address = mem_address;
        1'b1: pmem_address = {pmem_tag, index, 5'b00000};
    endcase
end

// reading from arrays
always_comb begin : ARRAY_READ
    case(way_sel)
        1'b0 : begin 
            pmem_tag = tag0_out;
            pmem_wdata = data0_out;
            dirty = dirty0_out;
            cache_to_bus = data0_out;
        end
        1'b1 : begin
            pmem_tag = tag1_out;
            pmem_wdata = data1_out;
            dirty = dirty1_out;
            cache_to_bus = data1_out;
        end
    endcase
end

// writing to arrays
always_comb begin : ARRAY_WRITE
    data0_write_en = 32'h00000000;
    data1_write_en = 32'h00000000;
    case(way_sel) 
        1'b0 : begin 
            data0_write_en = data_write_en;
            //data0_in = pmem_rdata;
            data0_in = hit? bus_to_cache : pmem_rdata;
            dirty0_in = hit? 1'b1: 1'b0;
        end
        1'b1 : begin
            data1_write_en = data_write_en;
            //data1_in = pmem_rdata;
            data1_in = hit? bus_to_cache : pmem_rdata;
            dirty1_in = hit? 1'b1: 1'b0;
        end
    endcase
end
/*****************************************************************************/
endmodule : cache_datapath
