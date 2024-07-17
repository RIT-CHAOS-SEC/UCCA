module UCCA_state (
// INPUT ////////////////////////////////
    clk,
    pc,
    ucc_min,
    ucc_max,
    irq_jmp,
    system_reset,
    
// OUTPUT //////////////////////////////
    ucc_state,
    outside_ucc
);

input        clk;
input [15:0] pc;
input [15:0] ucc_min;
input [15:0] ucc_max;
input        irq_jmp;
input        system_reset;

output [1:0] ucc_state;
output       outside_ucc;

// FSM States //////////////////////////
parameter notUCC = 2'b00;
parameter inUCC = 2'b01;
parameter IRQ = 2'b10;
parameter RST = 2'b11;
///////////////////////////////////////
parameter RESET_HANDLER = 16'h0000;

reg [1:0] state;

initial 
begin
    state = RST;
end

wire in_ucc = (pc >= ucc_min) && (pc <= ucc_max);
wire outside_ucc = (pc < ucc_min) || (pc > ucc_max);

always @(posedge clk)
begin
    case (state)
        notUCC:
            if (system_reset)
                state <= RST;
            else if (outside_ucc)
                state <= notUCC;
            else if (irq_jmp)
                state <= IRQ;
            else if (in_ucc)
                state <= inUCC;
            else                  // If we get here something has gone terribly wrong
                state <= state;
                    
        inUCC:
            if (system_reset)
                state <= RST;
            else if (outside_ucc)
                state <= notUCC;
            else if (irq_jmp)
                state <= IRQ;
            else
                state <= state;
                
        IRQ:
            if (system_reset) 
                state <= RST;
            else if (in_ucc && !irq_jmp)
                state <= inUCC;
            else
                state <= state;
                     
        RST:
            if (pc == RESET_HANDLER && ! system_reset)
            begin
                if (outside_ucc)
                    state <= notUCC;
                else if (irq_jmp) 
                    state <= IRQ;
                else if (in_ucc)
                    state <= inUCC;
                else
                    state <= state;
            end
            else
                state <= state;
    endcase
end

assign ucc_state = state;

endmodule
