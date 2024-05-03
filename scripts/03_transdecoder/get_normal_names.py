import re
import argparse

def main(input_file, output_file):
    with open(input_file, "r") as inp, open(output_file, "w") as out:
        for line in inp:
            if line.startswith(">"):
                match = re.search(r"(\S+)\.p\d", line)
                if match:
                    out.write(match.group(1) + "\n")
            else:
                out.write(line)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-i', '--input', type=str, required=True, help='input.fasta')
    parser.add_argument('-o', '--output', type=str, default='.', help='output.fasta')

    args = parser.parse_args()

    main(args.input, args.output)

