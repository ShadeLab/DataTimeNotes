#Checking barcode precision impacts on OTU Pick
Sang-Hoon noticed that some of the barcode sequences within a sample were different. This lead us to question whether some of these "incorrect barcodes" could be heavily influencing our OTU picking. If they do, this might explain why we had so many OTUs within our Mock community of only six taxa.
 Start by doing pandaseq as before
 ````
  pandaseq -f Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -r Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -A simple_bayesian -B -g Panda_log.txt -l 253 -L 253 -o 42 -O 47 -w Mock_Merged.fasta
 ````

  This left us with 318,449 merged sequences. But, some of these sequences have incorrect barcodes. In order to remove these sequences we first used grep to get the headers of the sequences we did want.
   ````
   grep :TCCTCTGTCGAC$ Mock_Merged.fasta > Headers.txt
   ````
   This `grep` command created the file Headers.txt that contains the header of each sequence. However, in order to use this tool with the qiime script `filter_fasta.py` we had to remove all of the '>' in the file. We did this by opening up the file in TextWrangler and to a find and replace. The resulting file 'GoodHeaders.txt' can then be used with `filter_fasta.py` to grab only the merged sequences that have the correct barcode.
   ````
   filter_fasta.py -f Mock_Merged.fasta -o Mock_Merged_Filtered.fasta --sample_id_fp GoodHeaders.txt
   ````
   The resulting file Mock_Merged_Filtered.fasta contains 294,463. This means after merging paired end reads there are 23,986 sequences that have "incorrect" barcodes. This file was then used as the input for OTU picking using the qiime script `pick_open_reference_otus.py`
   ````
   pick_open_reference_otus.py -i Mock_Merged_Filtered.fasta -m usearch61 -o CorrectBarcode_usearch61_otus/
   ````
   This is a workflow script and unfortunately did not complete the assignment of taxonomy to each OTU because of an error. However, the output CorrectBarcodes_usearch61_otus/rep_set.fna contained 9,122 sequences indicating there were 9,122 OTUs clustered. Using the same OTU picking workflow on the unfiltered merged reads we get 9,955. 
