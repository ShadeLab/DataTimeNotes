SC 2.26.15 Analysis of ITS sequences (for He Lab)

Raw data files: 9143.1.122795.CACGTGACATG.fastq, 9143.1.122795.TAGAGCCGTTA.fastq, 9143.1.122795.TACAGATGGCT.fastq

1. Convert files from fastq to fna
```
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.CACGTGACATG.fastq -o fastqual
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.TACAGATGGCT.fastq -o fastqual
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.TAGAGCCGTTA.fastq -o fastqual
mv 9143.1.122795.CACGTGACATG.fna 9143.1.122795.CACGTGACATG.fasta
mv 9143.1.122795.TACAGATGGCT.fna 9143.1.122795.TACAGATGGCT.fasta
mv 9143.1.122795.TAGAGCCGTTA.fna 9143.1.122795.TAGAGCCGTTA.fasta
mkdir fastqual
mv *fna fastqual
```

3. Combined fasta files and metadata into one file for analysis
```
add_qiime_labels.py -m ITS_mb_mapping_file.txt -i fastqual -c InputFastaFileName  
mv combined_seqs.fna ITS_combined_seqs.fna

```

4. Picked OTUs at 97%

```
pick_otus.py -i ITS_combined_seqs.fna -s 0.97
```

i. pick_otus.py
ii. pick_rep_set.py
iii. align_seqs.py
iv. assign_taxonomy.py
v. make_otu_table.py
vi. make_phylogeny.py
7. Summarized output from pick_open_reference_otus.py
a. Input: otu_table_mc_w_tax.biom
b. Output: summary_otu_table_mc2_w_tax.txt
c. Script: biom summarize_table
8. Rarefaction: subsampled to the smallest sequencing depth (87129)
a. Input: otu_table_mc_w_tax.biom
b. Output: otu_table_mc2_w_tax_even87129.biom
c. Script: single_rarefaction.py
9. Summarized output from pick_open_reference_otus.py
a. Input: otu_table_mc_w_tax_even87129.biom
b. Output: summary_otu_table_mc2_w_tax_even87129.txt
c. Script: biom summarize_table
