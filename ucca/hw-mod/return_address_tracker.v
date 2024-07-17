module return_address_tracker(
// Inputs//////////
    clk,
    inst_so,
    e_state,
    mdb_out,
    
// Outputs /////////
    ret_addr
);

input clk;
input [7:0]   inst_so;
input [3:0]   e_state;
input [15:0]  mdb_out;

output [15:0] ret_addr;

// UCC States //////////////////////
parameter CALL_STATE = 4'hB;
parameter IRQ_STATE = 4'h1;
parameter CALL_INST = 8'h20;
parameter IRQ_INST = 8'h80;
///////////////////////////////////

reg [15:0] addr;
initial
begin 
    addr = 16'h0000;
end

always @(posedge clk)
begin 
    if ((e_state == CALL_STATE && inst_so == CALL_INST) | (e_state == IRQ_STATE && inst_so == IRQ_INST))
        addr <= mdb_out;
    else
        addr <= addr;
end

assign ret_addr = addr;
endmodule
