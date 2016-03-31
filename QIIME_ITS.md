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
Output: fasta format for all input files. 

2) Combine fasta files and metadata into one file for analysis
Made a very simple mapping file based on txt file from sequencing center in raw data folder (ITS_mb_mapping_file.txt). 
```
add_qiime_labels.py -m ITS_mb_mapping_file.txt -i fastqual -c InputFastaFileName  
mv combined_seqs.fna ITS_combined_seqs.fna

```
Output: ITS_combined_seqs.fna

3) Picked OTUs at 97%

```
pick_otus.py -i ITS_combined_seqs.fna -s 0.97
```
Output: ITS_combined_seqs_otus.txt

4) Picked representative sequences
```
pick_rep_set.py -i uclust_picked_otus/ITS_combined_seqs_otus.txt -f ITS_combined_seqs.fna

```
Not picking against a reference set, so used the original fasta file as a reference because QIIME required this (```-f``` flag).
Output: ITS_combined_seqs.fna_rep_set.fasta

5) Align sequences
```
align_seqs.py -i ITS_combined_seqs.fna_rep_set.fasta
```

2.27.16

6) Assign taxonomy
```
assign_taxonomy.py -i ITS_combined_seqs_otus_rep_set.fna -t sh_taxonomy_qiime_ver7_97_s_31.01.2016.txt -r sh_refs_qiime_ver7_97_s_31.01.2016.fasta
```

2.29.16
Checked output of assigning taxonomy. There was only a log file, no output file. There was an error: "burrito.util.ApplicationError: Unacceptable application exit status: 137" which some Googling suggested was due to a memory error. This makes sense as I went ahead and ran it on the HPCC without submitting it as a job so it was probably killed. Whoops. 

Submitted qsub:
```
#! /bin/bash
#PBS -l walltime=08:00:00
#PBS -l mem=250Gb
#PBS -l nodes=1:ppn=16
#PBS -e /mnt/research/ShadeLab/Cusack
#PBS -o /mnt/research/ShadeLab/Cusack
#PBS -N ITS_taxonomy
#PBS -M cusacksi@msu.edu
#PBS -m abe 
cd /mnt/research/ShadeLab
source software/loadanaconda2.sh
assign_taxonomy.py -i Cusack/ITS_combined_seqs.fna_rep_set.fasta -t Cusack/sh_taxonomy_qiime_ver7_97_s_31.01.2016.txt -r Cusack/sh_refs_qiime_ver7_97_s_31.01.2016.fasta -o Cusack/taxonomy_0229
```

3.31.16 Checking the output of the qsub I submitted last month

```
grep Unassigned ITS_combined_seqs.fna_rep_set_tax_assignments.txt | wc -l
```
Output (number of unassigned OTUs): 1120035
```
grep denovo* ITS_combined_seqs.fna_rep_set_tax_assignments.txt | wc -l
```
Output (total number of OTUs): 1369421

Percentage of unassigned OTUs: 81.8%. That's not ok. 
Maybe try clustering OTUs with the Unite db instead of denovo.

Making a much smaller file to play around with to make sure things will work before I submit a giant job.
```
head -n 200 ITS_combined_seqs.fna>100_ITS_combined_seqs.fna
```
Try to pick OTUs using usearch. Not sure if this is an HPCC issue or a QIIME 1.9.1 issue, but the version of usearch that is supported is 5.2.236; the most recent version is 8.1.1803. 
```
module load usearch/5.2.236
pick_otus.py -i 100_ITS_combined_seqs.fna -m usearch_ref -o USEARCH_REF -r ../sh_refs_qiime_ver7_97_s_31.01.2016.fasta --word_length 350 --suppress_reference_chimera_detection
```
Output:
```
ValueError: No data following filter steps, please check parameter settings for usearch_qf.
```
Checked the log file and it turns out there was actually no error. It completed. Sooooo:

```
assign_taxonomy.py -i clustered_error_corrected.fasta -t sh_taxonomy_qiime_ver7_97_s_31.01.2016.txt -r sh_refs_qiime_ver7_97_s_31.01.2016.fasta -o taxonomy_0331_2
grep Unassigned clustered_error_corrected_tax_assignments.txt | wc -l
```
89% of these OTUs are unassigned. Maybe I should try closed reference OTU picking?

```
pick_closed_reference_otus.py -i 100_ITS_combined_seqs.fna -o Closed_Ref_OTUs_0331 -r sh_refs_qiime_ver7_97_s_31.01.2016.fasta --assign_taxonomy
```
Failure: "Attempting to write an empty BIOM table to disk." qiime.util.EmptyBIOMTableError: Attempting to write an empty BIOM table to disk. QIIME doesn't support writing empty BIOM output files.
Checked the log file: "Num OTUs:0
Num new OTUs:0
Num failures:100"

The [description page for pick_closed_reference_otus.py](http://qiime.org/scripts/pick_closed_reference_otus.html) suggests that if all sequences are failing to hit the database, they may be in reverse orientation with respect to the database. To fix this, pass a parameters file containing "pick_otus:enable_rev_strand_match True"

```
pick_closed_reference_otus.py -i 100_ITS_combined_seqs.fna -p parameters_0331 -o Closed_Ref_OTUs_0331_2 -r sh_refs_qiime_ver7_97_s_31.01.2016.fasta --assign_taxonomy
```
Same error. Try giving it a taxonomy file?

```
pick_closed_reference_otus.py -i 100_ITS_combined_seqs.fna -p parameters_0331 -o Closed_Ref_OTUs_0331_2 -r sh_refs_qiime_ver7_97_s_31.01.2016.fasta --assign_taxonomy -t sh_taxonomy_qiime_ver7_97_s_31.01.2016.txt
```
Failed again. 
Added to the parameters file:
```
pick_otus:prefilter_identical_sequences False
```




To do:
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
