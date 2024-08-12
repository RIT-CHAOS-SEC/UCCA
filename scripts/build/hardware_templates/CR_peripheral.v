
module  CR_peripheral (

// OUTPUTs
    per_dout,                         // Peripheral data output

// Declaring UCC definition output wires
UCC_DEFS
);


// OUTPUTs
//=========
output      [15:0] per_dout;        // Peripheral data output

// Instantiating the UCC definition output wires
UCC_INST
                     

// Creating internal CR and UCC registers to load the stored definitions
reg   [15:0] crmem ENTRIES;
UCC_REGS

// Loading the UCC definitions
initial begin
    $readmemh("cr.mem", crmem);
UCC_INIT
/**/
end

// Assigning the UCC definition output wires          
UCC_WIRES

endmodule
