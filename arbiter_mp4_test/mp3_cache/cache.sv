/* MODIFY. Your cache design. It contains the cache
controller, cache datapath, and bus adapter. */

module cache #(
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

    /* CPU memory signals */
    input   logic [31:0]    mem_address,
    output  logic [31:0]    mem_rdata,
    input   logic [31:0]    mem_wdata,
    input   logic           mem_read,
    input   logic           mem_write,
    input   logic [3:0]     mem_byte_enable,
    output  logic           mem_resp,

    /* Physical memory signals */
    output  logic [31:0]    pmem_address,
    input   logic [255:0]   pmem_rdata,
    output  logic [255:0]   pmem_wdata,
    output  logic           pmem_read,
    output  logic           pmem_write,
    input   logic           pmem_resp
);

/******************************** Wires *************************************/

logic hit, dirty;

logic tag_load, lru_load, valid_load, dirty_load;

logic pmem_addr_sel;

logic [255:0] cache_to_bus, bus_to_cache;

logic [31:0] mem_byte_enable256, data_write_en;
/****************************************************************************/

cache_control control
(
    .*
);

cache_datapath datapath
(
    .*
);

bus_adapter bus_adapter
(
 .mem_wdata256(bus_to_cache),
 .mem_rdata256(cache_to_bus),
 .mem_wdata(mem_wdata),
 .mem_rdata(mem_rdata),
 .mem_byte_enable(mem_byte_enable),
 .mem_byte_enable256(mem_byte_enable256),
 .address(mem_address)
);

endmodule : cache
