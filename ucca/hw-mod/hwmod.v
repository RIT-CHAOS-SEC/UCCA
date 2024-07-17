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
    
    ucc_min_0,
    ucc_max_0,
    ucc_min_1,
    ucc_max_1,
    ucc_min_2,
    ucc_max_2,
    /*ucc_min_3,
    ucc_max_3,
    /*ucc_min_4,
    ucc_max_4,
    /*ucc_min_5,
    ucc_max_5,
    /*ucc_min_6,
    ucc_max_6,
    /*ucc_min_7,
    ucc_max_7,
    /**/
    
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

input   [15:0]  ucc_min_0;
input   [15:0]  ucc_max_0;
input   [15:0]  ucc_min_1;
input   [15:0]  ucc_max_1;
input   [15:0]  ucc_min_2;
input   [15:0]  ucc_max_2;
/*input   [15:0]  ucc_min_3;
input   [15:0]  ucc_max_3;
/*input   [15:0]  ucc_min_4;
input   [15:0]  ucc_max_4;
/*input   [15:0]  ucc_min_5;
input   [15:0]  ucc_max_5;
/*input   [15:0]  ucc_min_6;
input   [15:0]  ucc_max_6;
/*input   [15:0]  ucc_min_7;
input   [15:0]  ucc_max_7;
/**/


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
wire region_reset_0;
wire region_reset_1;
wire region_reset_2;
//wire region_reset_3;
//wire region_reset_4;
//wire region_reset_5;
//wire region_reset_6;
//wire region_reset_7;/**/
wire master_reset = cr_integrity_reset | region_reset_0 | region_reset_1 | region_reset_2;// | region_reset_3;// | region_reset_4;// | region_reset_5;// | region_reset_6;// | region_reset_7;

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

     // For formal verification
    /*.return_address (return_address),
    .base_pointer   (base_pointer),
    .return_reset   (ret_reset),
    .stack_reset    (stack_protection_reset),/**/
  
    
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

/*UCCA_region #(
) UCCA_region_3 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_3),
    .ucc_max        (ucc_max_3),  
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),
    
    .reset          (region_reset_3)
);

/*UCCA_region #(
) UCCA_region_4 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_4),
    .ucc_max        (ucc_max_4),  
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),
    
    .reset          (region_reset_4)
);

/*UCCA_region #(
) UCCA_region_5 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .inst_changed   (inst_changed),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_5),
    .ucc_max        (ucc_max_5),  
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),
    
    .reset          (region_reset_5)
);

/*UCCA_region #(
) UCCA_region_6 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_6),
    .ucc_max        (ucc_max_6),  
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),
    
    .reset          (region_reset_6)
);

/*UCCA_region #(
) UCCA_region_7 (
    .clk            (clk),
    .pc             (pc),
    .inst_changed   (inst_changed),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .ucc_min        (ucc_min_7),
    .ucc_max        (ucc_max_7),  
    .stack_pointer  (stack_pointer),
    .irq_jmp        (irq_jmp),
    .system_reset   (master_reset),
    .op_dest        (op_dest),
    
    .reset          (region_reset_7)
);
/**/

assign reset = master_reset; 

// For formal verification
/*assign integrity_reset = cr_integrity_reset;
assign return_reset = ret_reset;
assign stack_reset = stack_protection_reset;/**/


endmodule
