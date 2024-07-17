
module  return_integrity (
// INPUT /////////////////////////////////////////////////////////////////
    clk,    
    pc,     
    system_reset,
    outside_ucc,
    ucc_state,
    op_dest,

// OUTPUT ////////////////////////////////////////////////////////////////
    // For formal verification
    //return_address,
    
    
    reset
);

input         clk;
input  [15:0] pc;
input         system_reset;
input         outside_ucc;
input  [1:0]  ucc_state;
input  [15:0] op_dest;

output        reset;

// For formal verification
//output [15:0] return_address;


// FSM States ////////////////////////////////////////////////////////////
parameter notUCC  = 2'b00;
parameter inUCC = 2'b01;
parameter IRQ = 2'b10;
parameter RST = 2'b11;
//////////////////////////////////////////////////////////////////////////

parameter       RESET_HANDLER = 16'h0000;

reg [15:0] return_addr;
reg        return_integrity_reset;

initial
begin
        return_integrity_reset = 1'b1;
        return_addr = 16'h0000;
end

wire valid_return = pc == return_addr;

always @(posedge clk)
begin
    case (ucc_state)
        notUCC:
            if (system_reset)  // Reset if another module/UCC triggered a reset
               return_addr <= 16'h0000;
            else if (outside_ucc)
                return_addr <= op_dest;
            else
                return_addr <= return_addr;  
        
        inUCC:
            if ((outside_ucc && !valid_return) | system_reset)  // Reset if malicious return or system wide reset detected
            	return_addr <= 16'h0000;
            else if (outside_ucc)
                return_addr <= op_dest;
            else
                return_addr <= return_addr; 
                
        RST:
            if (pc == RESET_HANDLER & !system_reset) // Wait until system has finished resetting
            begin
                if(outside_ucc)
                    return_addr <= op_dest;
                else
                    return_addr <= return_addr;
            end
            else
                return_addr <= pc + 16'h0004;
	
	IRQ:
	    if (system_reset)
	    	return_addr <= 16'h0000;
	    else
	        return_addr <= return_addr;
    endcase
end

////////////// OUTPUT LOGIC //////////////////////////////////////////////
always @(posedge clk)
begin
    if ( (
        (ucc_state == inUCC && outside_ucc && !valid_return) ||
	(ucc_state == RST && pc != RESET_HANDLER)
       )
    )begin
            return_integrity_reset <= 1'b1;
    end
    else begin
            return_integrity_reset <= 1'b0;
    end
end


assign reset = return_integrity_reset;

// For formal verification
//assign return_address = return_addr;

endmodule
