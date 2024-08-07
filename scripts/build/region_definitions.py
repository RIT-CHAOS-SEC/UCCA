import sys

APP_DIR = "../"
BUILD_DIR = "tmp-build/"
UCCS = 8
REGION_DEF_TEMPLATE = '__attribute__ ((section (".region_'


def read_ucc_definitions(lst_file):
    num_lines = len(lst_file)
    regions = []
    for i in range(1, UCCS+1):
        current_region = REGION_DEF_TEMPLATE + str(i) + '")))'
        matches = []
        for j in range(num_lines):
            if current_region in lst_file[j]:
                matches.append(j)

        if len(matches) > 0:
            region_start = region_stop = 0

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
                    region_start = lst_file[j][0:4]
                    break

            for j in range(matches[-1]+1, num_lines):
                if lst_file[j][-3:] == "ret":
                    region_stop = lst_file[j][0:4]
                    break

            regions.append((region_start, region_stop))
    return regions


def update_ucc_definitions(app_name, matches):

    with open(f"{APP_DIR}{app_name}/main_template.c", "r") as app_fp:
        app_file = app_fp.read()

    for i in range(0, len(matches)):
        app_file = app_file.replace(f'"{i+1}Sta"', f"0x{matches[i][0]}")
        app_file = app_file.replace(f'"{i+1}Sto"', f"0x{matches[i][1]}")

    for i in range(len(matches), UCCS):
        app_file = app_file.replace(f'"{i+1}Sta"', f"0xFFFF")
        app_file = app_file.replace(f'"{i+1}Sto"', f"0xFFFF")

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

    with open("temp_uccs.txt", "w") as ofp:
        ofp.write(str(len(regions)))


if __name__ == '__main__':
    main()

