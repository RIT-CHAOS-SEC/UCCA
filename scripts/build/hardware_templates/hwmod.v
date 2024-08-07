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
    
UCC_DEFS
    
    // For formal verification
    /*return_address,
    base_pointer,
    integrity_reset,
    return_reset,
    stack_reset,/**/   
    
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

UCC_INST


output          reset;

// For formal verification
/*output  [15:0]  return_address;
output  [15:0]  base_pointer;
output          integrity_reset;
output          return_reset;
output          stack_reset;/**/


// MACROS ///////////////////////////////////////////
parameter META_min = 16'h0140;
parameter META_max = 16'h0140 + 16'h002A;

parameter RESET_HANDLER = 16'h0000;

// For formal verification
/*parameter Start = 16'h0000;
parameter Stop = 16'h0001;
wire [15:0] return_address;
wire [15:0] base_pointer;
wire        ret_reset;
wire        stack_protction_reset;/**/


wire cr_integrity_reset;
UCC_RESETS
wire master_reset = cr_integrity_reset MASTER_RESET

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

UCC_REGIONS

assign reset = master_reset; 

// For formal verification
/*assign integrity_reset = cr_integrity_reset;
assign return_reset = ret_reset;
assign stack_reset = stack_protection_reset;/**/


endmodule
