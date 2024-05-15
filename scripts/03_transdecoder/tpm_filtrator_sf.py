import argparse
import re
import os
import pandas as pd
from Bio import SeqIO


def write_filtered_fasta(input_fasta, output_fasta, filtered_orf_names):
    with open(input_fasta, "r") as fasta_in, open(output_fasta, "w") as fasta_out:
        print(f'Writing {output_fasta}...')
        for record in SeqIO.parse(fasta_in, "fasta"):
            if record.id in filtered_orf_names:
                SeqIO.write(record, fasta_out, "fasta")


def filter_quant_sf(quant_sf_path, filtered_orf_names):
    quant_df = pd.read_csv(quant_sf_path, sep='\t')
    filtered_quant_df = quant_df[quant_df['Name'].isin(filtered_orf_names)]
    output_path = os.path.join(os.path.dirname(quant_sf_path), 'filtered_quant.sf')
    filtered_quant_df.to_csv(output_path, sep='\t', index=False)


def main(transdecoder_fasta_pep, transdecoder_fasta_cds, tpm_table_path, output_dir):
    orf_names = []
    with open(transdecoder_fasta_pep, "r") as f:
        for record in SeqIO.parse(f, "fasta"):
            orf_names.append(record.id)
    tpm_table = pd.read_csv(tpm_table_path, sep='\t')

    filtered_tpm_table = tpm_table[tpm_table['Name'].isin(orf_names)]
    filtered_tpm_table = filtered_tpm_table[(filtered_tpm_table.iloc[:, 1:] >= 1).any(axis=1)]
    filtered_orf_names = filtered_tpm_table.iloc[:, 0].tolist()


    output_tpm_name = "filtered_" + os.path.basename(tpm_table_path)
    output_tpm_path = os.path.join(output_dir, output_tpm_name)
    print(f"Writing filtered full tpm table...")
    filtered_tpm_table.to_csv(output_tpm_path, index=False, sep='\t')


    tpm_dir = os.path.join(os.path.dirname(tpm_table_path), 'salmon')

    for subdir, dirs, files in os.walk(tpm_dir):
        for file in files:
            if file == 'quant.sf':
                print(f'Formatting {subdir} quant.sf...')
                quant_sf_path = os.path.join(subdir, file)
                filter_quant_sf(quant_sf_path, filtered_orf_names)

    
    transdecoder_output = os.path.dirname(transdecoder_fasta_pep)

    output_fasta_pep = os.path.join(transdecoder_output, 
        f"filtered_{os.path.basename(transdecoder_fasta_pep)}")

    output_fasta_cds = os.path.join(transdecoder_output, 
        f"filtered_{os.path.basename(transdecoder_fasta_cds)}")

    write_filtered_fasta(transdecoder_fasta_pep, output_fasta_pep, filtered_orf_names)
    write_filtered_fasta(transdecoder_fasta_cds, output_fasta_cds, filtered_orf_names)


    print(f"Number of ORFs: {len(orf_names)}")
    print(f"Number of ORFs with significant expression level: {len(filtered_orf_names)}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Filter TPM table based on transdecoder annotation results')
    parser.add_argument('--pep', '--transdecoder_fasta_pep', type=str, required=True, help='transdecoder.fasta.pep')
    parser.add_argument('--cds', '--transdecoder_fasta_cds', type=str, required=True, help='transdecoder.fasta.cds')
    parser.add_argument('-t', '--tpm_table_path', type=str, required=True, help='TPM table')
    parser.add_argument('-o', '--output_dir', type=str, default='.', help='directory for results')

    args = parser.parse_args()

    main(args.pep, args.cds, args.tpm_table_path, args.output_dir)
