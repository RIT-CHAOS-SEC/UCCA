import sys

HARDWARE_TEMPLATE_DIR = "build/hardware_templates/"
UCCA_DIR = "../ucca/hw-mod/"
MSP_DIR = "../openmsp430/"


def build_cr_peripheral(num_uccs):
    """
    Builds the CR peripheral verilog file. Creates the interfaces used to access the CR region
    :param num_uccs: (int) The number of UCCs supported
    :return: None
    """
    with open(f"{HARDWARE_TEMPLATE_DIR}CR_peripheral.v", "r") as template_fp:
        template_file = template_fp.read()

    ucc_defs = ucc_inst = ucc_regs = ucc_init = ucc_wires = ""
    entries = f"[0:{(num_uccs*2)-1}]"
    for i in range(num_uccs):
        ucc_defs += f"    ucc_min_{i},\n    ucc_max_{i},\n"
        ucc_inst += f"output      [15:0] ucc_min_{i};\noutput      [15:0] ucc_max_{i};\n"
        ucc_regs += f"reg   [15:0] ucc_{i}_min;\nreg   [15:0] ucc_{i}_max;\n"
        ucc_init += f"    ucc_{i}_min <= crmem[{i*2}];\n    ucc_{i}_max <= crmem[{(2*i)+1}];\n"
        ucc_wires += f"wire [15:0] ucc_min_{i} = ucc_{i}_min;\nwire [15:0] ucc_max_{i} = ucc_{i}_max;\n"

    ucc_defs = ucc_defs[:-2]
    template_file = template_file.replace("UCC_DEFS", ucc_defs)
    template_file = template_file.replace("UCC_INST", ucc_inst)
    template_file = template_file.replace("ENTRIES", entries)
    template_file = template_file.replace("UCC_REGS", ucc_regs)
    template_file = template_file.replace("UCC_INIT", ucc_init)
    template_file = template_file.replace("UCC_WIRES", ucc_wires)

    with open(f"{UCCA_DIR}CR_peripheral.v", "w") as output_fp:
        output_fp.write(template_file)


def build_fpga(num_uccs):
    """
    Builds the openMSP430_fpga verilog file. Pass the signals from the CR peripheral to the MSP430
    :param num_uccs: (int) The number of UCCs supported
    :return: None
    """
    with open(f"{HARDWARE_TEMPLATE_DIR}openMSP430_fpga.v", "r") as template_fp:
        template_file = template_fp.read()

    ucc_wires = ucc_inputs = ucc_outputs = ""
    for i in range(num_uccs):
        ucc_wires += f"wire        [15:0] ucc_min_{i};\nwire        [15:0] ucc_max_{i};\n"
        ucc_inputs += f"    .ucc_min_{i}         (ucc_min_{i}),\n    .ucc_max_{i}         (ucc_max_{i}),\n"
        ucc_outputs += f"    .ucc_min_{i}    (ucc_min_{i}),\n    .ucc_max_{i}    (ucc_max_{i}),\n"

    ucc_inputs = ucc_inputs[:-2]
    ucc_outputs = ucc_outputs[:-2]
    template_file = template_file.replace("UCC_WIRES", ucc_wires)
    template_file = template_file.replace("UCC_INPUTS", ucc_inputs)
    template_file = template_file.replace("UCC_OUTPUTS", ucc_outputs)

    with open(f"{MSP_DIR}fpga/openMSP430_fpga.v", "w") as output_fp:
        output_fp.write(template_file)


def build_msp(num_uccs):
    """
    Builds the openMSP430 verilog file.  Implements the MSP430 and for our purposes connects UCCA's hardware to the
    MSP430
    :param num_uccs: (int) The number of UCCs supported
    :return: Still None
    """
    with open(f"{HARDWARE_TEMPLATE_DIR}openMSP430.v", "r") as template_fp:
        template_file = template_fp.read()

    ucc_defs = ucc_insts = ucc_inputs = ""
    for i in range(num_uccs):
        ucc_defs += f"    ucc_min_{i},\n    ucc_max_{i},\n"
        ucc_insts += f"input         [15:0] ucc_min_{i};\ninput         [15:0] ucc_max_{i};\n"
        ucc_inputs += f"    .ucc_min_{i}      (ucc_min_{i}),\n    .ucc_max_{i}      (ucc_max_{i}),\n"

    ucc_defs = ucc_defs[:-2]
    template_file = template_file.replace("UCC_DEFS", ucc_defs)
    template_file = template_file.replace("UCC_INST", ucc_insts)
    template_file = template_file.replace("UCC_INPUTS", ucc_inputs)

    with open(f"{MSP_DIR}msp_core/openMSP430.v", "w") as output_fp:
        output_fp.write(template_file)


def build_hwmod(num_uccs):
    """
    Builds the hwmod verilog file. Creates the required submodules and wires for the UCCs supported
    :param num_uccs: (int) The number of UCCs supported (shocking I know)
    :return: None
    """
    with open(f"{HARDWARE_TEMPLATE_DIR}hwmod.v", "r") as template_fp:
        template_file = template_fp.read()

    ucc_defs = ucc_insts = ucc_resets = master_reset = ucc_regions = ""
    for i in range(num_uccs):
        ucc_defs += f"    ucc_min_{i},\n    ucc_max_{i},\n"
        ucc_insts += f"input   [15:0] ucc_min_{i};\ninput   [15:0] ucc_max_{i};\n"
        ucc_resets += f"wire region_reset_{i};\n"
        master_reset += f"| region_reset_{i} "
        ucc_regions += f"UCCA_region #(\n) UCCA_region_{i} (\n    .clk            (clk),\n    .pc             (pc),\n" \
                       f"    .inst_changed   (inst_changed),\n    .data_en        (data_en),\n" \
                       f"    .data_wr        (data_wr),\n    .data_addr      (data_addr),\n" \
                       f"    .ucc_min        (ucc_min_{i}),\n    .ucc_max        (ucc_max_{i}),\n" \
                       f"    .stack_pointer  (stack_pointer),\n    .irq_jmp        (irq_jmp),\n" \
                       f"    .system_reset   (master_reset),\n    .op_dest        (op_dest),\n\n" \
                       f"    .reset          (region_reset_{i})\n);\n\n"

    master_reset = master_reset[:-1] + ";"
    template_file = template_file.replace("UCC_DEFS", ucc_defs)
    template_file = template_file.replace("UCC_INST", ucc_insts)
    template_file = template_file.replace("UCC_RESETS", ucc_resets)
    template_file = template_file.replace("MASTER_RESET", master_reset)
    template_file = template_file.replace("UCC_REGIONS", ucc_regions)

    with open(f"{UCCA_DIR}hwmod.v", "w") as output_fp:
        output_fp.write(template_file)



def build_cr_integrity(num_uccs):
    """
    Updates CR_integrity module to protect the right memory range
    :param num_uccs: (int) The number of UCCs supported (shocking I know)
    :return: None
    """
    with open(f"{HARDWARE_TEMPLATE_DIR}CR_integrity.v", "r") as template_fp:
        template_file = template_fp.read()
    
    cr_end = hex(352 + (4*num_uccs))[2:]
    cr_end = cr_end.zfill(4)

    template_file = template_file.replace("CR_END", f"16'h{cr_end};")

    with open(f"{UCCA_DIR}CR_integrity.v", "w") as output_fp:
        output_fp.write(template_file)


def main():
    num_uccs = int(sys.argv[1])
    if num_uccs == -1:
        with open("temp_uccs.txt") as ifp:
            num_uccs = int(ifp.read().strip())

    build_cr_peripheral(num_uccs)
    build_fpga(num_uccs)
    build_msp(num_uccs)
    build_hwmod(num_uccs)
    build_cr_integrity(num_uccs)


if __name__ == '__main__':
    main()
