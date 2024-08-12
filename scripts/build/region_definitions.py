import sys

APP_DIR = "../"
BUILD_DIR = "tmp-build/"
UCCS = 8  # Default number of regions to check for
REGION_DEF_TEMPLATE = '__attribute__ ((section (".region_'


def read_ucc_definitions(lst_file):
    """
    Parsed the generated lst file to extract the UCC defenitions.
    :param lst_file: (list(string)) The contents of the lst file
    :return: regions (list(((string, string))) - A list of discovered
               UCC definitions
    """
    num_lines = len(lst_file)
    regions = []
    for i in range(1, UCCS+1):
        current_region = REGION_DEF_TEMPLATE + str(i) + '")))'
        matches = []
        for j in range(num_lines):  # find functions in the current UCC
            if current_region in lst_file[j]:
                matches.append(j)

        if len(matches) > 0:  # If current UCC exists
            region_start = region_stop = 0

            # Find the first non comment line of the first match
            in_comment = 0
            for j in range(matches[0]+1, num_lines):
                if in_comment:
                    if lst_file[j][-2:] == "*/":
                        in_comment = 0
                    continue
                elif lst_file[j] == "":
                    continue
                elif lst_file[j][0:2] == "/*":
                    in_comment = 1
                    continue
                elif lst_file[j][0:2] == "//":
                    continue
                else:
                    region_start = lst_file[j][0:4]  # extract memory address
                    break

            # Find the instruction of the last entry
            for j in range(matches[-1]+1, num_lines):
                if lst_file[j][-3:] == "ret":  # should always be a ret
                    region_stop = lst_file[j][0:4]  # extract memory address
                    break

            regions.append((region_start, region_stop))
    return regions


def update_ucc_definitions(app_name, matches):
    """
    Updates the specified apps template file (assuming it has one) with
      the discovered UCCs
    :param app_name: (string) the app being analyzed
    :param matches: (list((string, string))) the list of UCC definitions
    :return: None
    """

    with open(f"{APP_DIR}{app_name}/main_template.c", "r") as app_fp:
        app_file = app_fp.read()

    for i in range(0, len(matches)):
        app_file = app_file.replace(f'"{i+1}Sta"', f"0x{matches[i][0]}")
        app_file = app_file.replace(f'"{i+1}Sto"', f"0x{matches[i][1]}")

    for i in range(len(matches), UCCS):  # Void unused UCCs
        app_file = app_file.replace(f'"{i+1}Sta"', f"0xFFFF")
        app_file = app_file.replace(f'"{i+1}Sto"', f"0xFFFF")

    app_file = app_file.replace("CR_SIZE", str(4*len(matches)))
    with open(f"{APP_DIR}{app_name}/main.c", "w") as app_fp:
        app_fp.write(app_file)


def main():
    app_name = sys.argv[1]

    lst_file = []
    with open(f"{BUILD_DIR}{app_name}/ucca.lst") as lst_fp:
        for line in lst_fp.readlines():
            lst_file.append(line.strip())

    regions = read_ucc_definitions(lst_file)
    update_ucc_definitions(app_name, regions)

    # output the number of regions for the hardware script later
    with open("temp_uccs.txt", "w") as ofp:
        ofp.write(str(len(regions)))


if __name__ == '__main__':
    main()

