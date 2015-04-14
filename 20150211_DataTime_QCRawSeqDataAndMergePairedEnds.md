##Examining the quality of the illumina data that are returned from the sequencing center
(PHRED scores :  Phred 40 / 60)
Q30 “quality score" :  1:1000 probability of an incorrect base
old illumina data is under a different quality scale
More info is here:
http://www.illumina.com/documents/products/technotes/technote_Q-Scores.pdf

view the gz file
```
gunzip FILENAME
head FILENAME
grep -c “@HWI” FILENAME
```
the number of sequences in the file.  This number should match the PF Reads in the SeqProduction file for the sample.  
sanity check:  you can also use
```
module load QIIME
count_seqs.py -i FILENAME 
```
This number should match the number above and the number in the excel SeqProduction file.

Make data readonly so that they can’t delete the raw sequence data

 md5.txt = “hash table” or “hash map” ; not specific to illumine data, all files downloaded (e.g., movies, music) will have one associated
hash (random string of numbers/letter) followed by names of each sample
Can make sure the files downloaded properly (not truncated, no errors)
http://en.wikipedia.org/wiki/Hash_table
```
md5sum FILENAME
```
hash should match with md5.txt

Inspect "SeqProduction" file
Raw clusters = all the dots
PF Clusters in the Sample/Pool summary should equal the PF Reads in the RED at the sum of the column in the Sample table

R1 / R2 -corresponding with the forward and reverse primers that together form the “bridge"
PF Clusters =  “pass filter” clusters ; the difference between the Raw and PF clusters are that the filter eliminates any pairs that can’t be matched throughout the entire run
R2 tails are often lower quality… is it because it is a “shorter” read (because doesn’t have barcode?)

How to interpret Q30:
From the Sample/Pool table:
“91.8% of the nucleotides are, on average, above the Q30 threshold"
From the Sample Name table:
for sample Crab-Apple
“93.1% of the nucleotides of sequences in this sample are, on average, above the Q30 threshold

##Insepcting FastQ:
each fastq is four lines
1.  name (header - includes sequencer, spot coordinates, flow cell, etc...)
2.  actual sequence data
3. spacer (starts with +)
4. Quality:  q score - alpha numeric (I is a score of 40, which is a perfect score)  see below link for interpretation of alphanumeric Q score
http://en.wikipedia.org/wiki/FASTQ_format

Can run FastQC on each sample to “Sanity Check” the sequencing center’s quality assessment

Can trim your own dataset using the FastX tool kit, recommended for 454 and not-paired-end reads
Whether or not you manually trim the data depends on the 
*Platform for sequencing (454 should be trimmed)
*Whether or not the illumina reads are paired ends.  Not paired ends may be appropriate for manual trimming
*If paired ends, how much overlap (e.g., 100/150 overall gives more flexibility for manual trimming than 50 bp overlap)
*For our data, we only have 50 bp overlap, so we chose not to manually trim.

##  Merging paired-end reads using PANDAseq
PANDAseq
```
pandaseq -f FILENAME -r FILENAME -B ignore missing barcodes/primers -F output as fastq/include qscores  -l 253 -L 253 -o 44 -t 0.9 (IMPORTANT threshold) -w mock_com_merged.fastq -g mock_com_log.txt
```
v 2.8.1
338,399 PF reads (from SeqProduction of mock community)

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 0.9 -w output.fastq
```
303146 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -F -g log.txt -l 248 -L 253 -o 47 -O 47 -t 0.9 -w output.fastq
```
303146 sequences
conclusion: minimum length does not matter
```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A pear -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 0.9 -w output.fastq
```
295261 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A pear -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 1.0 -w output.fastq
```
327,529 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A pear -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 0.95 -w output.fastq
```
212,267 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A pear -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 0.95 -w output.fastq
```
161 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 0.95 -w output.fastq
```
279,500 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 0.99 -w output.fastq
```
209,910 sequences

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -F -g log.txt -l 253 -L 253 -o 47 -O 47 -t 1.00 -w output.fastq
```
318,626 sequences
0.99 is as stringent as we can go with the -t parameter

```
pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -F -g log.txt -l 253 -L 253 -o 42 -O 47 -t 0.90 -w output.fastq
```
303,093 sequences

Run fastqc to check quality scores (based on PRHED +33
```
fastqc output.fastq
```
after looking at fastqc output for PEAR t 0.9, simple_bayesian t 0.9, 0.99, we decided that we should use the simple_bayesian.
