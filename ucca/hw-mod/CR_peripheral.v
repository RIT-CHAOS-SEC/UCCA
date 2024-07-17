
module  CR_peripheral (

// OUTPUTs
    per_dout,                         // Peripheral data output
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
);


// OUTPUTs
//=========
output      [15:0] per_dout;        // Peripheral data output
output      [15:0] ucc_min_0;                          
output      [15:0] ucc_max_0;                          
output      [15:0] ucc_min_1;                          
output      [15:0] ucc_max_1; 
output      [15:0] ucc_min_2;                          
output      [15:0] ucc_max_2; 
/*output      [15:0] ucc_min_3;                          
output      [15:0] ucc_max_3; 
/*output      [15:0] ucc_min_4;                          
output      [15:0] ucc_max_4; 
/*output      [15:0] ucc_min_5;                          
output      [15:0] ucc_max_5; 
/*output      [15:0] ucc_min_6;                          
output      [15:0] ucc_max_6; 
/*output      [15:0] ucc_min_7;                          
output      [15:0] ucc_max_7; 
/**/
                     


reg   [15:0] crmem [0:15];
reg   [15:0] ucc_0_min;
reg   [15:0] ucc_0_max;
reg   [15:0] ucc_1_min;
reg   [15:0] ucc_1_max;
reg   [15:0] ucc_2_min;
reg   [15:0] ucc_2_max;
/*reg   [15:0] ucc_3_min;
reg   [15:0] ucc_3_max;
/*reg   [15:0] ucc_4_min;
reg   [15:0] ucc_4_max;
/*reg   [15:0] ucc_5_min;
reg   [15:0] ucc_5_max;
/*reg   [15:0] ucc_6_min;
reg   [15:0] ucc_6_max;
/*reg   [15:0] ucc_7_min;
reg   [15:0] ucc_7_max;
/**/

initial begin
    $readmemh("cr.mem", crmem);
    ucc_0_min <= crmem[0];
    ucc_0_max <= crmem[1];
    ucc_1_min <= crmem[2];
    ucc_1_max <= crmem[3];
    ucc_2_min <= crmem[4];
    ucc_2_max <= crmem[5];
    /*ucc_3_min <= crmem[6];
    ucc_3_max <= crmem[7];
    /*ucc_4_min <= crmem[8];
    ucc_4_max <= crmem[9];
    /*ucc_5_min <= crmem[10];
    ucc_5_max <= crmem[11];
    /*ucc_6_min <= crmem[12];
    ucc_6_max <= crmem[13];
    /*ucc_7_min <= crmem[14];
    ucc_7_max <= crmem[15];
/**/
end
                         
wire [15:0] ucc_min_0 = ucc_0_min;
wire [15:0] ucc_max_0 = ucc_0_max;
wire [15:0] ucc_min_1 = ucc_1_min;
wire [15:0] ucc_max_1 = ucc_1_max;
wire [15:0] ucc_min_2 = ucc_2_min;
wire [15:0] ucc_max_2 = ucc_2_max;
/*wire [15:0] ucc_min_3 = ucc_3_min;
wire [15:0] ucc_max_3 = ucc_3_max;
/*wire [15:0] ucc_min_4 = ucc_4_min;
wire [15:0] ucc_max_4 = ucc_4_max;
/*wire [15:0] ucc_min_5 = ucc_5_min;
wire [15:0] ucc_max_5 = ucc_5_max;
/*wire [15:0] ucc_min_6 = ucc_6_min;
wire [15:0] ucc_max_6 = ucc_6_max;
/*wire [15:0] ucc_min_7 = ucc_7_min;
wire [15:0] ucc_max_7 = ucc_7_max;
/**/

endmodule
