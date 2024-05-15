import os
import sys
from Bio import SeqIO

def make_gene2trans_map(fasta_file):
    gene2transcript_map = {}
    for record in SeqIO.parse(fasta_file, "fasta"):
        header = record.id
        gene_id = header.split('_g')[1].split('_')[0]
        transcript_id = header
        if gene_id in gene2transcript_map:
            gene2transcript_map[gene_id].append(transcript_id)
        else:
            gene2transcript_map[gene_id] = [transcript_id]

    output_dir = os.path.dirname(fasta_file)
    output_file = os.path.join(output_dir, "gene2trans.txt")

    with open(output_file, 'w') as file:
        for gene, transcripts in gene2transcript_map.items():
            for transcript in transcripts:
                file.write(f"oli_g{gene}\t{transcript}\n")

if __name__ == "__main__":
    fasta_file = sys.argv[1]
    make_gene2trans_map(fasta_file)
