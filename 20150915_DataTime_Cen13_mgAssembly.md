#Cen13 Metagenome Assembly Data Time
##September 15th, 2015

Back in December of 2014, we submitted DNA extracted from a Cen13, an active vent site with a soil temperature of 57.4C, for shotgun metagenomic sequencing. We sequenced the sample on a single lane of Illumina HiSeq with 150bp Paired end reads. Below you can see some of what I've done so far in this analysis. 

###Quality Controlling and Formatting our data
The first step was to quality control and properly format our sequencing runs. We need to do this in order for the assembler we are using later (Megahit) to make full use of our paired end data. Using the khmer and fastx toolkit modules on hpcc I ran the following commands to interleave, quality control, and match our paired end data. 

###HPCC
```
module load GNU/4.8.2
module load khmer/2.0
```

#### Interleaving Reads
```
module load khmer
interleave-reads.py ../../Cen13DirectAssembly/BBMap/Cen13_mgDNA_Pooled_CTTGTA_L002_R* -o combined.fastq
```
This first step interleaves our paired end reads. This means that each forward read is immediately followed by its mate reverse read.

#### Quality Filtering
```
module load GNU/4.4.5
module load fastx
fastq_quality_filter -Q33 -q 30 -p 50 -i combined.fastq -o combined_filtered.fastq
```
Here we are actually quality filtering our data. We specify that in order to keep a read, at least 50% `-p` of its base calls must have a quality `-q` of 30 or higher. For more information on q-scores visit [this page](https://en.wikipedia.org/wiki/FASTQ_format)

#### 
```
module load GNU/4.8.2
module load khmer
extract-paired-reads.py combined_filtered.fastq
```
This step takes the quality controlled data and creates a file of interleaved paired end data and a file of single end data. After the quality filtering we lose sequences that have low quality, and are left with some "orphaned" reads(ie reads that lost a mate due to low quality). This step is important in order to be able to use paired end read data with Megahit. If megahit comes across orphaned reads while in paired end mode, it will stop and not continue.

### Assembling
Surprisingly, one of the most computationally demanding steps of the process, is one of the easiest to code. Currently, the general consensus is that Megahit is the best assembler out there for metagenomes. It is **FAST** and uses significantly less RAM than other current assemblers. For more information see the [paper](http://bioinformatics.oxfordjournals.org/cgi/pmidlookup?view=long&pmid=25609793), [Titus Brown's Blog Post](http://ivory.idyll.org/blog/2014-how-good-is-megahit.html), and [Adam River's mtRNA Assembly](http://tinyecology.com/assembling-metatranscriptomes-megahit/).  
#### Megahit Assembly
```  
module load megahit
megahit --12 combined_filtered.fastq.pe --k-list 27,37,47,57,67,77,87,97,107 -o Megahit_QC_Assembly/ -t $PBS_NUM_PPN
```

The `--12` flag tells megahit that we have paired end data in interleaved format. The `--k-list` specifies the length of the different kmers we want megahit to use for assembly. `-o` just specifies the output directory. The most confusing flag here is probably `-t` and what is written after it. `t` is for telling megahit the number of processors to use and `$PBS_NUM_PPN` says to use the number of processors specified in the job script. My full job script for this run is below. 
```
#! /bin/bash
#PBS -l walltime=07:00:00:00
#PBS -l mem=400Gb
#PBS -l nodes=1:ppn=16
#PBS -e /mnt/research/ShadeLab/WorkingSpace/Jackson/QualityFiltering
#PBS -o /mnt/research/ShadeLab/WorkingSpace/Jackson/QualityFiltering
#PBS -N Megahit_QC
#PBS -A bicep
#PBS -M my_email@gmail.com
#PBS -m abe
module load megahit
cd /mnt/research/ShadeLab/WorkingSpace/Jackson/QualityFiltering
megahit --12 combined_filtered.fastq.pe --k-list 27,37,47,57,67,77,87,97,107 -o Megahit_QC_Assembly/ -t $PBS_NUM_PPN   
```

