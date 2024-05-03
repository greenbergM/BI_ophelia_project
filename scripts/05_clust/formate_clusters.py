import argparse
import pandas as pd

def main(input_file, output_file):
    print('Formatting Clusters_Objects.tsv...')
    df = pd.read_csv(input_file, sep="\t")
    df = df.drop(df.index[0])
    df.columns = df.columns.str.split().str[0]

    df.to_csv(output_file, sep='\t', index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Remove "Genes" and numbers from column names in a file.')

    parser.add_argument('-i', '--input', type=str, required=True, help='input file')
    parser.add_argument('-o', '--output', type=str, default='.', help='output file')

    args = parser.parse_args()

    main(args.input, args.output)

