`ifndef backend_interface
`define backend_interface

interface BACKEND_ITF;

import rv32i_types::*;

/* signal declarations */
// signals from instruction queue to everywhere else
logic res1_load, res2_load, res3_load, res4_load;
// signals from res1 to iq
logic res1_empty;
// signals from res2 to iq
logic res2_empty;
// signals from res3 to iq
logic res3_empty;
// signals from res4 to iq
logic res4_empty;

modport IQ_SIG_OUT(
output res1_load, 
output res2_load,
output res3_load,
output res4_load
);

modport RES1_IN(
input res1_load, 
output res1_empty
); 

modport RES2_IN(
input res2_load, 
output res2_empty
);

modport RES3_IN(
input res3_load, 
output res3_empty
);

modport RES4_IN(
input res4_load, 
output res4_empty
);

endinterface : BACKEND_ITF

`endif