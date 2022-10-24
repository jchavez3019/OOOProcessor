
module ir
import rv32i_types::*;
(
    input clk,
    input rst,
    input load,
    input [31:0] in,
    output tomasulo_types::ctl_word control_word
);

logic data [31:0];

assign funct3 = data[14:12];
assign funct7 = data[31:25];
assign opcode = rv32i_opcode'(data[6:0]);
assign i_imm = {{21{data[31]}}, data[30:20]};
assign s_imm = {{21{data[31]}}, data[30:25], data[11:7]};
assign b_imm = {{20{data[31]}}, data[7], data[30:25], data[11:8], 1'b0};
assign u_imm = {data[31:12], 12'h000};
assign j_imm = {{12{data[31]}}, data[19:12], data[20], data[30:21], 1'b0};
assign rs1 = data[19:15];
assign rs2 = data[24:20];
assign rd = data[11:7];

assign control_word.src1_reg = rs1;
assign control_word.src2_reg = rs2;
assign control_word.src1_valid = 1'b0;
assign control_word.src2_valid = 1'b0;
assign control_word.src1_rob_id = 3'b000;
assign control_word.src2_rob_id = 3'b000;
assign control_word.funct3 = funct3;
assign control_word.funct7 = funct7[30];
assign control_word.rd = rd;
assign control_word.i_imm = i_imm;
assign control_word.s_imm = s_imm;
assign control_word.b_imm = b_imm;
assign control_word.u_imm = u_imm;
assign control_word.j_imm = j_imm;

//why "=" instead of "<="
always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= '0;
    end
    else if (load == 1)
    begin
        data <= in;
    end
    else
    begin
        data <= data;
    end
end

endmodule : ir
