module cdb_latch 
import rv32i_types::*;
(  input tomasula_types::cdb_data control,
                    input en,
                    input rst,
                    output tomasula_types::cdb_data q
                    );

// always @ (en or rst or control.data) begin
    always @ (en or rst) begin
    if(rst) 
        q.data <= 32'h00000000;
    else begin
        if(en)
            q.data <= control.data;
    end
end

endmodule