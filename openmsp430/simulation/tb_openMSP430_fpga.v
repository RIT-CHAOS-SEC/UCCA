//----------------------------------------------------------------------------
// Copyright (C) 2001 Authors
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
// License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
//----------------------------------------------------------------------------
// 
// *File Name: tb_openMSP430_fpga.v
// 
// *Module Description:
//                      openMSP430 FPGA testbench
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev$
// $LastChangedBy$
// $LastChangedDate$
//----------------------------------------------------------------------------
`include "timescale.v"
`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module  tb_openMSP430_fpga;

// VAPE: important stuff

wire         [7:0] p3_dout = dut.p3_dout;
//wire        exec   = dut.VAPE_metadata_0.exec;
wire       [15:0] pc    = dut.openMSP430_0.inst_pc;
wire  gie = dut.openMSP430_0.gie;

//
// Wire & Register definition
//------------------------------

// Clock & Reset
reg               CLK_100MHz;
reg               RESET;

// Slide Switches
reg               SW7;
reg               SW6;
reg               SW5;
reg               SW4;
reg               SW3;
reg               SW2;
reg               SW1;
reg               SW0;

// Push Button Switches
reg               BTN2;
reg               BTN1;
reg               BTN0;

// LEDs

wire              LED7;
wire              LED6;
wire              LED5;
wire              LED4;
wire              LED3;
wire              LED2;
wire              LED1;
wire              LED0;

// Four-Sigit, Seven-Segment LED Display
wire              SEG_A;
wire              SEG_B;
wire              SEG_C;
wire              SEG_D;
wire              SEG_E;
wire              SEG_F;
wire              SEG_G;
wire              SEG_DP;
wire              SEG_AN0;
wire              SEG_AN1;
wire              SEG_AN2;
wire              SEG_AN3;

// UART
reg               UART_RXD;
wire              UART_TXD;

// JB-C
wire              JB1;
wire              JC1;
wire              JC2;
wire              JC7;

// Core debug signals
//wire   [8*32-1:0] i_state;
//wire   [8*32-1:0] e_state;
//wire       [31:0] inst_cycle;
//wire   [8*32-1:0] inst_full;
//wire       [31:0] inst_number;
wire       [15:0] inst_pc;
//wire   [8*32-1:0] inst_short;

//// Testbench variables
//integer           i;
integer           error;
reg               stimulus_done;


//
// Include files
//------------------------------

// CPU & Memory registers
//`include "registers.v"

// GPIO
//wire         [7:0] p3_din = dut.p3_din;
//wire         [7:0] p3_dout = dut.p3_dout;
//wire         [7:0] p3_dout_en = dut.p3_dout_en;

//wire         [7:0] p1_din = dut.p1_din;
//wire         [7:0] p1_dout = dut.p1_dout;
//wire         [7:0] p1_dout_en = dut.p1_dout_en;

////VAPE's EXEC_FLAG
//wire         EXEC_FLAG = dut.exec_flag;

// UCCA SIGNALS
wire        ucca_reset = dut.openMSP430_0.ucca_reset;
wire        cr_integrity_reset = dut.openMSP430_0.hdmod_0.cr_integrity_reset;
wire        W_en =       dut.openMSP430_0.hdmod_0.data_wr;
wire [15:0] D_addr =     dut.openMSP430_0.hdmod_0.data_addr;
wire [15:0] SP =         dut.openMSP430_0.hdmod_0.stack_pointer;
wire        IRQ_jmp =    dut.openMSP430_0.hdmod_0.irq_jmp;
wire [15:0] OP_ret =     dut.openMSP430_0.hdmod_0.op_dest;

// UCC SPECIFIC SIGNALS

wire [1:0]  ucc1_state = dut.openMSP430_0.hdmod_0.UCCA_region_0.ucc_state;
wire        ucc1_return_integrity_reset = dut.openMSP430_0.hdmod_0.UCCA_region_0.return_integrity_reset;
wire [15:0] ucc1_expected_return = dut.openMSP430_0.hdmod_0.UCCA_region_0.return_integrity_0.return_addr;
wire        ucc1_stack_integrity_reset = dut.openMSP430_0.hdmod_0.UCCA_region_0.stack_protection_reset;
wire [15:0] ucc1_base_pointer = dut.openMSP430_0.hdmod_0.UCCA_region_0.stack_protection_0.ebp;
	
wire [1:0]  ucc2_state = dut.openMSP430_0.hdmod_0.UCCA_region_1.ucc_state;
wire        ucc2_return_integrity_reset = dut.openMSP430_0.hdmod_0.UCCA_region_1.return_integrity_reset;
wire [15:0] ucc2_expected_return = dut.openMSP430_0.hdmod_0.UCCA_region_1.return_integrity_0.return_addr;
wire        ucc2_stack_integrity_reset = dut.openMSP430_0.hdmod_0.UCCA_region_1.stack_protection_reset;
wire [15:0] ucc2_base_pointer = dut.openMSP430_0.hdmod_0.UCCA_region_1.stack_protection_0.ebp;

wire [1:0]  ucc3_state = dut.openMSP430_0.hdmod_0.UCCA_region_2.ucc_state;
wire        ucc3_return_integrity_reset = dut.openMSP430_0.hdmod_0.UCCA_region_2.return_integrity_reset;
wire [15:0] ucc3_expected_return = dut.openMSP430_0.hdmod_0.UCCA_region_2.return_integrity_0.return_addr;
wire        ucc3_stack_integrity_reset = dut.openMSP430_0.hdmod_0.UCCA_region_2.stack_protection_reset;
wire [15:0] ucc3_base_pointer = dut.openMSP430_0.hdmod_0.UCCA_region_2.stack_protection_0.ebp;

// RESET SIGNAL
//wire         puc_rst = dut.puc_rst;
//wire         reset_pin_n = dut.reset_pin_n;
//wire         ucca_rst = dut.openMSP430_0.hdmod_0.reset;
//wire         rst_Xstack = dut.openMSP430_0.hdmod_0.ucca_0.X_stack_reset;
//wire         rst_AC = dut.openMSP430_0.hdmod_0.ucca_0.AC_reset;
//wire    rst_dma_AC = dut.openMSP430_0.hdmod_0.ucca_0.dma_AC_reset;
//wire    rst_dma_detect = dut.openMSP430_0.hdmod_0.ucca_0.dma_detect_reset;
//wire    rst_dma_X_stack = dut.openMSP430_0.hdmod_0.ucca_0.dma_X_stack_reset;
//wire    rst_atom = dut.openMSP430_0.hdmod_0.ucca_0.atomicity_reset;

//VAPE
//wire       v_immutability = dut.openMSP430_0.hdmod_0.vape_0.vape_immutability;
//wire       v_atomicity = dut.openMSP430_0.hdmod_0.vape_0.vape_atomicity;
//wire       v_output_protection = dut.openMSP430_0.hdmod_0.vape_0.vape_output_protection;
//wire       v_vape_boundary_protection = dut.openMSP430_0.hdmod_0.vape_0.vape_boundary_protection;
//wire      [2:0] atomicity_state = dut.openMSP430_0.hdmod_0.vape_0.VAPE_atomicity_0.pc_state;
//wire      v_is_fst = dut.openMSP430_0.hdmod_0.vape_0.VAPE_atomicity_0.is_first_rom;
//mclk
//wire              LED8;
// CPU registers
//======================

//wire       [15:0] pc    = dut.openMSP430_0.inst_pc;
//wire       [15:0] r0    = dut.openMSP430_0.execution_unit_0.register_file_0.r0;
//wire       [15:0] r1    = dut.openMSP430_0.execution_unit_0.register_file_0.r1;
//wire       [15:0] r2    = dut.openMSP430_0.execution_unit_0.register_file_0.r2;
//wire       [15:0] r3    = dut.openMSP430_0.execution_unit_0.register_file_0.r3;
//wire       [15:0] r4    = dut.openMSP430_0.execution_unit_0.register_file_0.r4;
//wire       [15:0] r5    = dut.openMSP430_0.execution_unit_0.register_file_0.r5;
//wire       [15:0] r6    = dut.openMSP430_0.execution_unit_0.register_file_0.r6;
//wire       [15:0] r7    = dut.openMSP430_0.execution_unit_0.register_file_0.r7;
//wire       [15:0] r8    = dut.openMSP430_0.execution_unit_0.register_file_0.r8;
//wire       [15:0] r9    = dut.openMSP430_0.execution_unit_0.register_file_0.r9;
//wire       [15:0] r10   = dut.openMSP430_0.execution_unit_0.register_file_0.r10;
//wire       [15:0] r11   = dut.openMSP430_0.execution_unit_0.register_file_0.r11;
//wire       [15:0] r12   = dut.openMSP430_0.execution_unit_0.register_file_0.r12;
//wire       [15:0] r13   = dut.openMSP430_0.execution_unit_0.register_file_0.r13;
//wire       [15:0] r14   = dut.openMSP430_0.execution_unit_0.register_file_0.r14;
//wire       [15:0] r15   = dut.openMSP430_0.execution_unit_0.register_file_0.r15;
//wire       [1:0] chal_wen   = dut.VAPE_metadata_0.chal_wen;
//wire       [3:0] chal_addr_reg   = dut.VAPE_metadata_0.chal_addr_reg;
//wire       chal_cen   = dut.VAPE_metadata_0.chal_cen;
//wire       [15:0] chal_dout   = dut.VAPE_metadata_0.chal_dout;
//wire       [7:0] reg_addr   = dut.VAPE_metadata_0.reg_addr;
//wire       [13:0] per_addr   = dut.VAPE_metadata_0.per_addr;
//wire       per_en   = dut.VAPE_metadata_0.per_en;
//wire       [15:0] per_dout   = dut.VAPE_metadata_0.per_dout;
//wire       [15:0] per_din   = dut.VAPE_metadata_0.per_din;
//wire       [15:0] ermin   = dut.VAPE_metadata_0.ermin;
//wire       [15:0] ermax   = dut.VAPE_metadata_0.ermax;
//wire       [15:0] ormin   = dut.VAPE_metadata_0.ormin;
//wire       [15:0] ormax   = dut.VAPE_metadata_0.ormax;
//wire       [15:0] ermin_rd   = dut.VAPE_metadata_0.ermin_rd;
//wire       [15:0] ermax_rd   = dut.VAPE_metadata_0.ermax_rd;
//wire       [15:0] ormin_rd   = dut.VAPE_metadata_0.ormin_rd;
//wire       [15:0] ormax_rd   = dut.VAPE_metadata_0.ormax_rd;
//wire       [15:0] exec_rd   = dut.VAPE_metadata_0.exec_rd;

// RAM cells
//======================

//wire       [15:0] srom_cen = dut.openMSP430_0.srom_cen;
// Verilog stimulus
//`include "stimulus.v"

//
// Initialize Program Memory
//------------------------------

////
//// Initialize ROM
////------------------------------
////integer tb_idx;
//initial
//  begin
//     // Initialize data memory
////     for (tb_idx=0; tb_idx < `DMEM_SIZE/2; tb_idx=tb_idx+1)
////        dmem_0.mem[tb_idx] = 16'h0000;

//     // Initialize program memory
//     //$readmemh("smem.mem", dut.openMSP430_0.srom_0.mem);
//     //
//     $readmemh("pmem.mem", dut.openMSP430_0.srom_0.mem);
//  end
  
  

//
// Generate Clock & Reset
//------------------------------
initial
  begin
     CLK_100MHz = 1'b0;
     forever #10 CLK_100MHz <= ~CLK_100MHz; // 100 MHz
  end

initial
  begin
     RESET         = 1'b0;
     #100 RESET    = 1'b1;
     #600 RESET    = 1'b0;
  end

//
// Global initialization
//------------------------------
initial
  begin
     error         = 0;
     stimulus_done = 1;
     SW7           = 1'b0;  // Slide Switches
     SW6           = 1'b0;
     SW5           = 1'b0;
     SW4           = 1'b0;
     SW3           = 1'b0;
     SW2           = 1'b0;
     SW1           = 1'b0;
     SW0           = 1'b0;
     BTN2          = 1'b0;  // Push Button Switches
     BTN1          = 1'b0;
     BTN0          = 1'b0;
     UART_RXD      = 1'b0;  // UART
  end

//
// openMSP430 FPGA Instance
//----------------------------------

openMSP430_fpga dut (

// Clock Sources
    .CLK_100MHz    (CLK_100MHz),
    //.CLK_SOCKET   (1'b0),

// Slide Switches
    .SW7          (SW7),
    .SW6          (SW6),
    .SW5          (SW5),
    .SW4          (SW4),
    .SW3          (SW3),
    .SW2          (SW2),
    .SW1          (SW1),
    .SW0          (SW0),

// Push Button Switches
    .BTN3         (RESET),
    .BTN2         (BTN2),
    .BTN1         (BTN1),
    .BTN0         (BTN0),
    
// RS-232 Port
    .UART_RXD     (UART_RXD),
    .UART_TXD     (UART_TXD),  

// LEDs
    .LED8         (LED8),
    .LED7         (LED7),
    .LED6         (LED6),
    .LED5         (LED5),
    .LED4         (LED4),
    .LED3         (LED3),
    .LED2         (LED2),
    .LED1         (LED1),
    .LED0         (LED0),
    
    
    // JB-C
    .JB1          (JB1),
    .JC1          (JC1),
    .JC2          (JC2),
    .JC7          (JC7),

// Four-Sigit, Seven-Segment LED Display
    .SEG_A        (SEG_A),
    .SEG_B        (SEG_B),
    .SEG_C        (SEG_C),
    .SEG_D        (SEG_D),
    .SEG_E        (SEG_E),
    .SEG_F        (SEG_F),
    .SEG_G        (SEG_G),
    .SEG_DP       (SEG_DP),
    .SEG_AN0      (SEG_AN0),
    .SEG_AN1      (SEG_AN1),
    .SEG_AN2      (SEG_AN2),
    .SEG_AN3      (SEG_AN3)
    );

   
//
// Debug utility signals
//----------------------------------------
/*
msp_debug msp_debug_0 (

// OUTPUTs
    .e_state      (e_state),       // Execution state
    .i_state      (i_state),       // Instruction fetch state
    .inst_cycle   (inst_cycle),    // Cycle number within current instruction
    .inst_full    (inst_full),     // Currently executed instruction (full version)
    .inst_number  (inst_number),   // Instruction number since last system reset
    .inst_pc      (inst_pc),       // Instruction Program counter
    .inst_short   (inst_short),    // Currently executed instruction (short version)

// INPUTs
    .mclk         (mclk),          // Main system clock
    .puc_rst      (puc_rst)        // Main system reset
);
*/
//
// Generate Waveform
//----------------------------------------
initial
  begin
   `ifdef VPD_FILE
     $vcdplusfile("tb_openMSP430_fpga.vpd");
     $vcdpluson();
   `else
     `ifdef TRN_FILE
        $recordfile ("tb_openMSP430_fpga.trn");
        $recordvars;
     `else
        $dumpfile("tb_openMSP430_fpga.vcd");
        $dumpvars(0, tb_openMSP430_fpga);
     `endif
   `endif
  end

//
// End of simulation
//----------------------------------------
/*
initial // Timeout
  begin
   `ifdef NO_TIMEOUT
   `else
     `ifdef VERY_LONG_TIMEOUT
       #500000000;
     `else     
     `ifdef LONG_TIMEOUT
       #5000000;
     `else     
       #500000;
     `endif
     `endif
       $display(" ===============================================");
       $display("|               SIMULATION FAILED               |");
       $display("|              (simulation Timeout)             |");
       $display(" ===============================================");
       $finish;
   `endif
  end
*/
initial // Normal end of test
  begin
     @(inst_pc===16'hffff)
     $display(" ===============================================");
     if (error!=0)
       begin
	  $display("|               SIMULATION FAILED               |");
	  $display("|     (some verilog stimulus checks failed)     |");
       end
     else if (~stimulus_done)
       begin
	  $display("|               SIMULATION FAILED               |");
	  $display("|     (the verilog stimulus didn't complete)    |");
       end
     else 
       begin
	  $display("|               SIMULATION PASSED               |");
       end
     $display(" ===============================================");
     $finish;
  end


//
// Tasks Definition
//------------------------------

   task tb_error;
      input [65*8:0] error_string;
      begin
	 $display("ERROR: %s %t", error_string, $time);
	 error = error+1;
      end
   endtask


endmodule
