
module  CR_peripheral (

// OUTPUTs
    per_dout,                         // Peripheral data output

// Declaring UCC definition output wires
    ucc_min_0,
    ucc_max_0,
    ucc_min_1,
    ucc_max_1,
    ucc_min_2,
    ucc_max_2
);


// OUTPUTs
//=========
output      [15:0] per_dout;        // Peripheral data output

// Instantiating the UCC definition output wires
output      [15:0] ucc_min_0;
output      [15:0] ucc_max_0;
output      [15:0] ucc_min_1;
output      [15:0] ucc_max_1;
output      [15:0] ucc_min_2;
output      [15:0] ucc_max_2;

                     

// Creating internal CR and UCC registers to load the stored definitions
reg   [15:0] crmem [0:5];
reg   [15:0] ucc_0_min;
reg   [15:0] ucc_0_max;
reg   [15:0] ucc_1_min;
reg   [15:0] ucc_1_max;
reg   [15:0] ucc_2_min;
reg   [15:0] ucc_2_max;


// Loading the UCC definitions
initial begin
    $readmemh("cr.mem", crmem);
    ucc_0_min <= crmem[0];
    ucc_0_max <= crmem[1];
    ucc_1_min <= crmem[2];
    ucc_1_max <= crmem[3];
    ucc_2_min <= crmem[4];
    ucc_2_max <= crmem[5];

/**/
end

// Assigning the UCC definition output wires          
wire [15:0] ucc_min_0 = ucc_0_min;
wire [15:0] ucc_max_0 = ucc_0_max;
wire [15:0] ucc_min_1 = ucc_1_min;
wire [15:0] ucc_max_1 = ucc_1_max;
wire [15:0] ucc_min_2 = ucc_2_min;
wire [15:0] ucc_max_2 = ucc_2_max;


endmodule
