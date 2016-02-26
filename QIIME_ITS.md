SC 2.26.15 Analysis of ITS sequences (for He Lab)

Raw data files: 9143.1.122795.CACGTGACATG.fastq, 9143.1.122795.TAGAGCCGTTA.fastq, 9143.1.122795.TACAGATGGCT.fastq

1) Convert files from fastq to fna
```
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.CACGTGACATG.fastq -o fastqual
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.TACAGATGGCT.fastq -o fastqual
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.TAGAGCCGTTA.fastq -o fastqual
mv 9143.1.122795.CACGTGACATG.fna 9143.1.122795.CACGTGACATG.fasta
mv 9143.1.122795.TACAGATGGCT.fna 9143.1.122795.TACAGATGGCT.fasta
mv 9143.1.122795.TAGAGCCGTTA.fna 9143.1.122795.TAGAGCCGTTA.fasta
mkdir fastqual
mv *fasta fastqual
```

2) Combine fasta files and metadata into one file for analysis
```
add_qiime_labels.py -m ITS_mb_mapping_file.txt -i fastqual -c InputFastaFileName  
mv combined_seqs.fna ITS_combined_seqs.fna

```

3) Picked OTUs at 97%

```
pick_otus.py -i ITS_combined_seqs.fna -s 0.97
```

4) Picked representative sequences
```
pick_rep_set.py -i ITS_combined_seqs_otus.txt

```
5) Align sequences
```
align_seqs.py -i ITS_combined_seqs_otus_rep_set.fna
```
6) Assign taxonomy
```
assign_taxonomy.py -i ITS_combined_seqs_otus_rep_set.fna -t sh_taxonomy_qiime_ver7_97_s_31.01.2016.txt -r sh_refs_qiime_ver7_97_s_31.01.2016.fasta
```
7) Make OTU table
```
make_otu_table.py -i ITS_combined_seqs_otus_rep_set_w_taxonomy.fna -o ITS_97_otu_table.biom
```
8) Make phylogeny
```
make_phylogeny.py -i ITS_combined_seqs_otus_rep_set_w_taxonomy.fna 
```

9) Summarize biom table
```
biom summarize_table ITS_97_otu_table.biom
```

10) Rarefaction: subsample to the smallest sequencing depth 
```
single_rarefaction.py -i ITS_97_otu_table.biom -o ITS_97_otu_table_[number].biom
```

11) Summarize output from rarefied OTU table
```
biom summarize_table ITS_97_otu_table_[number].biom
```
