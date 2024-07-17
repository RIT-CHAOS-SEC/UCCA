`include "return_integrity.v"	
//`include "stack_protection.v"
`include "UCCA_state.v"

`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module UCCA_region (
// INPUT//////////////////////////////////////////////////////////////////
    clk,
    pc,
    //data_en,
    //data_wr,
    //data_addr,
    ucc_min,
    ucc_max,
    //stack_pointer,
    irq_jmp,
    //system_reset,
    op_dest,

// OUTPUT ////////////////////////////////////////////////////////////////    
    // For formal verification
    return_address,
    //base_pointer,
    return_reset,
    //stack_reset,/**/
    
    
    reset
    
);

input         clk;
input  [15:0] pc;
//input         data_en;
//input         data_wr;
//input  [15:0] data_addr;
input  [15:0] ucc_min;
input  [15:0] ucc_max;
//input  [15:0] stack_pointer;
input         irq_jmp;
//input         system_reset;
input  [15:0] op_dest;

output        reset;

// For formal verification
output [15:0]  return_address;
//output [15:0]  base_pointer;
output         return_reset;
//output         stack_reset;/**/



// MACROS ////////////////////////////////////////////////////////////////
//parameter CONF_BASE = 16'h0160;
//parameter CONF_END = 16'h016B;
//////////////////////////////////////////////////////////////////////////

parameter RESET_HANDLER = 16'h0000;
wire    return_integrity_reset;

wire [1:0] ucc_state;
wire outside_ucc;
UCCA_state #(
) UCCA_state_0 (
    .clk          (clk),
    .pc           (pc),
    .ucc_min      (ucc_min),
    .ucc_max      (ucc_max),
    .irq_jmp      (irq_jmp),
    
    //.system_reset (system_reset),
    // For Formal Verification 
    .system_reset (return_integrity_reset),
    
    .ucc_state    (ucc_state),
    .outside_ucc  (outside_ucc)
);


// For formal verification
wire [15:0] return_address;

//wire    return_integrity_reset;
return_integrity #(
) return_integrity_0 (
    .clk            (clk),
    .pc             (pc),
    
    //.system_reset (system_reset),
    // For Formal Verification 
    .system_reset  (return_integrity_reset),
   
    .outside_ucc    (outside_ucc),
    .ucc_state      (ucc_state),
    .op_dest        (op_dest),
    
    // For formal verification
    .return_address (return_address),
    
    .reset          (return_integrity_reset)
    
);/**/


// For formal verification
//wire [15:0] base_pointer;
/*
wire stack_protection_reset;
stack_protection #(
) stack_protection_0 (
    .clk           (clk),
    .data_addr     (data_addr),
    .data_wr       (data_wr),
    .pc            (pc),
    .stack_pointer (stack_pointer),
    .system_reset  (system_reset),
    .outside_ucc   (outside_ucc),
    .ucc_state     (ucc_state),
  
    // For formal verification
    .base_pointer  (base_pointer),
    
    .reset         (stack_protection_reset)
    
);/**/

// OUTPUT LOGIC //////////////////////////////////////////////////////////
assign reset = return_integrity_reset;// | stack_protection_reset;

// For formal verification
assign return_reset = return_integrity_reset;
//assign stack_reset = stack_protection_reset;/**/

endmodule
