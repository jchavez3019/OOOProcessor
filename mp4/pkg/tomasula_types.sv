package tomasula_types;

typedef enum bit[3:0] {
    BRANCH = 4'b0000,
    ARITH = 4'b0001, 
    AUIPC = 4'b0010, 
    JAL = 4'b0011, 
    JALR = 4'b0100,
    LD = 4'b0101,
    CSR = 4'b0110, 
    LUI = 4'b0111,
    // 8 to 10 is ST
    SB = 4'b1000,
    SH = 4'b1001,
    SW = 4'b1010,

    // 11 to 15 is LD
    LB = 4'b1011,
    LBU = 4'b1100,
    LH = 4'b1101,
    LHU = 4'b1110,
    LW = 4'b1111
} op_t;

typedef enum bit[3:0] {
    s_op_lui      = 4'b0000, // SHOULD NOT GET USED, turns to s_op_imm since adding u-imm with x0
    s_op_auipc    = 4'b0001, // SHOULD NOT GET USED, pc is calculated in ir and added with x0
    s_op_jal      = 4'b0010,
    s_op_jalr     = 4'b0011,
    s_op_br       = 4'b0100,
    s_op_load     = 4'b0101,
    s_op_store    = 4'b0110,
    s_op_imm      = 4'b0111,
    s_op_reg      = 4'b1000,
    s_op_csr      = 4'b1001,
    s_op_invalid  = 4'b1111
}rv32i_opcode_short;

/* remember to take out rob id's later since they are unnecessary */

// each instruction in the queue stores this info
typedef struct {
    // op_t op;  // 3 bits
    rv32i_opcode_short opcode;
    logic [4:0] src1_reg;
    logic src1_valid;
    logic [4:0] src2_reg;
    logic src2_valid;
    logic [31:0] src2_data;
    logic [2:0] funct3; 
    logic funct7;
    // logic imm;
    logic [4:0] rd;

    logic [31:0] pc;
    logic [31:0] og_pc;
    logic [31:0] og_instr;
} ctl_word; // totals 199 bits


// Reservation station values
typedef struct {
    // op_t op;
    rv32i_opcode_short opcode;
    logic [2:0] funct3;
    logic funct7; 
    // logic imm;
    logic [2:0] src1_tag; // this could be removed to save area
    logic [31:0] src1_data;
    logic src1_valid;
    logic [2:0] src2_tag;
    logic [31:0] src2_data;
    logic [4:0] src2_reg;
    logic src2_valid;
    logic [2:0] rd_tag; // rob tag where destination will be saved
    logic [31:0] pc;
} res_word; // totals 82 bits

// databus
typedef struct packed {
    // logic [2:0] tag;
    logic [31:0] data;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    // logic request;
} cdb_data; // totals 35 bits

//ALU interface
typedef struct packed {
    // op_t op;
    rv32i_opcode_short opcode;
    logic [2:0] funct3;
    logic funct7; 
    // logic imm;
    logic [31:0] src1_data;
    logic [31:0] src2_data;
    // logic [31:0] imm;
    logic [31:0] pc;
    logic [2:0] tag;
    // logic load; // make sure to set this back to 0 after you request the adder to do work
} alu_word;

endpackage : tomasula_types;
