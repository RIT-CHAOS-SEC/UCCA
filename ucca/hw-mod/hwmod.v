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
    ucc_min_0,
    ucc_max_0,
    ucc_min_1,
    ucc_max_1,
    ucc_min_2,
    ucc_max_2,

    
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
input   [15:0] ucc_min_0;
input   [15:0] ucc_max_0;
input   [15:0] ucc_min_1;
input   [15:0] ucc_max_1;
input   [15:0] ucc_min_2;
input   [15:0] ucc_max_2;


output          reset;


// MACROS ///////////////////////////////////////////
parameter META_min = 16'h0140;
parameter META_max = 16'h0140 + 16'h002A;

parameter RESET_HANDLER = 16'h0000;
/////////////////////////////////////////////////////

// Instantiating each modules/UCCs reset wires and the master reset wire
wire cr_integrity_reset;
wire region_reset_0;
wire region_reset_1;
wire region_reset_2;

wire master_reset = cr_integrity_reset | region_reset_0 | region_reset_1 | region_reset_2;

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
UCCA_region #(
) UCCA_region_0 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_0),
    .ucc_max        (ucc_max_0),
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),

    .reset          (region_reset_0)
);

UCCA_region #(
) UCCA_region_1 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_1),
    .ucc_max        (ucc_max_1),
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),

    .reset          (region_reset_1)
);

UCCA_region #(
) UCCA_region_2 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_2),
    .ucc_max        (ucc_max_2),
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),

    .reset          (region_reset_2)
);



assign reset = master_reset; 

endmodule
