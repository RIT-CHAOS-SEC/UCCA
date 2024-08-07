
module  CR_peripheral (

// OUTPUTs
    per_dout,                         // Peripheral data output
UCC_DEFS
);


// OUTPUTs
//=========
output      [15:0] per_dout;        // Peripheral data output
UCC_INST
                     


reg   [15:0] crmem ENTRIES;
UCC_REGS

initial begin
    $readmemh("cr.mem", crmem);
UCC_INIT
/**/
end
                         
UCC_WIRES

endmodule
