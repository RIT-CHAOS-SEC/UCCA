module stack_protection (
// INPUT /////////////////////////////////////////////////////////////////
    clk,
    data_addr,
    data_wr,
    pc,
    //prev_pc,
    inst_changed,
    stack_pointer,
    system_reset,
    outside_ucc,
    ucc_state,

// OUTPUT ////////////////////////////////////////////////////////////////
   // For formal verification
    //base_pointer,  
    
    reset
);

input          clk;
input  [15:0]  data_addr;
input          data_wr;
input  [15:0]  pc;
//input  [15:0]  prev_pc;
input          inst_changed;
input  [15:0]  stack_pointer;
input          system_reset;
input          outside_ucc;
input  [1:0]   ucc_state;

output         reset;

// For formal verification
//output [15:0]  base_pointer;


// FSM States ////////////////////////////////////////////////////////////
parameter notUCC =  2'b00;
parameter inUCC  =  2'b01;
parameter RST    =  2'b11;
parameter IRQ    = 2'b10;
//////////////////////////////////////////////////////////////////////////
parameter RESET_HANDLER = 16'h0000;

reg [15:0] ebp;
//reg [15:0] prev_pc;
reg        invalid_write;

wire valid_stack_write = (data_addr < ebp);
//wire inst_change = (prev_pc != pc); 

initial
begin
    ebp = 16'h0000;
    //prev_pc = 16'h0000;
    invalid_write = 1'b1;
end

always @(posedge clk)
begin

    case (ucc_state)
        notUCC:
        if (outside_ucc && inst_changed)//prev_pc != pc)
            ebp <= stack_pointer;
        else
            ebp <= ebp;
        
        inUCC:
            if (outside_ucc)
                ebp <= stack_pointer;
            else
                ebp <= ebp;
        RST:
            if (pc == RESET_HANDLER && !data_wr && !system_reset) 
            begin
                if (outside_ucc && inst_changed)//prev_pc != pc) 
                    ebp <= stack_pointer;
                else
                    ebp <= ebp;
            end
            else
                ebp <= ebp;	    
    endcase
    //prev_pc <= pc;
end

// OUTPUT LOGIC //////////////////////////////////////////////////////////
always @(posedge clk)
begin
    if ( (!(ucc_state == RST) && !outside_ucc && data_wr && !valid_stack_write) || 
         (ucc_state == inUCC && outside_ucc && stack_pointer != ebp) ||
         (ucc_state == RST && (pc != RESET_HANDLER | data_wr))
       )
           invalid_write <= 1'b1;
    else
           invalid_write <= 1'b0;
end

assign reset = invalid_write;

// For formal verification 
//assign base_pointer = ebp;

endmodule
