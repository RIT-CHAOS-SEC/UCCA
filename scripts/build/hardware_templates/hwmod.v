`include "CR_integrity.v"
`include "UCCA_region.v"		

`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module hwmod (
    clk,
    pc,
    data_en,
    data_wr,
    data_addr,
    stack_pointer,
    irq_jmp,
    op_dest,

    // Declaring the UCC definition input wires
UCC_DEFS
    
    reset
);

input           clk;
input   [15:0]  pc;
input           data_en;
input           data_wr;
input   [15:0]  data_addr;
input   [15:0]  stack_pointer;
input           irq_jmp;
input   [15:0]  op_dest;

// Instantiating UCC definition input wires
UCC_INST

output          reset;


// MACROS ///////////////////////////////////////////
parameter META_min = 16'h0140;
parameter META_max = 16'h0140 + 16'h002A;

parameter RESET_HANDLER = 16'h0000;
/////////////////////////////////////////////////////

// Instantiating each modules/UCCs reset wires and the master reset wire
wire cr_integrity_reset;
UCC_RESETS
wire master_reset = cr_integrity_reset MASTER_RESET

// The CR integrity module
CR_integrity #(
) CR_integrity_0 (
    .clk       (clk),
    .data_addr (data_addr),
    .data_wr   (data_wr),
    .pc        (pc),

    .reset     (cr_integrity_reset)
);


reg [15:0] prev_pc;
wire inst_changed = (prev_pc != pc); 

always @(posedge clk)
begin
   prev_pc <= pc;
end

// Instantiating each UCC
UCC_REGIONS

assign reset = master_reset; 

endmodule
