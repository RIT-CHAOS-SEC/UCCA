module CR_integrity (
// INPUT /////////////////////////////////////////////////////////////////
    clk,
    data_addr,
    data_wr,
    pc,

// OUTPUT ////////////////////////////////////////////////////////////////
    reset
);

input        clk;
input [15:0] data_addr;
input        data_wr;
input [15:0] pc;

output       reset;

// Region definitions in memory //////////////////////////////////////////
parameter META_BASE = 16'h0160;
parameter META_END  = 16'h0168;

// FSM States /////
parameter RUN = 1'b0;
parameter RST = 1'b1;
///////////////////

parameter RESET_HANDLER = 16'h0000;

wire in_meta_memory = (data_addr >= META_BASE && data_addr <= META_END);

reg state;
reg meta_reset;

initial
begin
    state = RST;
    meta_reset = 1'b1;
end

always @(posedge clk)
begin
    case (state) 
        RUN:
           if (in_meta_memory && data_wr)
               state <= RST;
           else
               state <= state;
        RST:
           if (pc == RESET_HANDLER)
               state <= RUN;
           else
               state <= state;
    endcase
end

// OUTPUT LOGIC //////////////////////////////////////////////////////////
always @(posedge clk)
begin
    if ( (in_meta_memory && data_wr) ||
         (state == RST && pc != RESET_HANDLER)
       )
        meta_reset <= 1'b1;
   else 
        meta_reset <= 1'b0;
end

assign reset = meta_reset;

endmodule  
