SC 2.26.15 Analysis of ITS sequences (for He Lab)

Raw data files: 9143.1.122795.CACGTGACATG.fastq, 9143.1.122795.TAGAGCCGTTA.fastq, 9143.1.122795.TACAGATGGCT.fastq

1. Convert files from fastq to fna
```
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.CACGTGACATG.fastq -o fastqual
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.TACAGATGGCT.fastq -o fastqual
convert_fastaqual_fastq.py -c fastq_to_fastaqual -f 9143.1.122795.TAGAGCCGTTA.fastq -o fastqual
```
