NOTE:  pick_open_reference_otus.py BY DEFAULT removes singletons - set the min_otu_size parameter to be 1 if you want to keep them.

##Part 1.  Our collective OTU picking results (moving forward from the pandaseq merged reads with the 0.90 threshold and simple_bayseian algorithm)

###1.  Jackson:  usearch61 with open reference and the greengenes database
NOTE: *usearch61 needs to be installed separately and renamed*
```
pick_open_reference_otus.py -i LabeledFASTA/combined_seqs.fna -o usearch61_openref_OTUS/ -m usearch61 
```

There are  9,503 OTUs detected via this method, but after inspecting the rank abundance curve, the the top 6 OTUs (most abundant) are what we expect.  The majority of remaining OTUs are doubleton and singletons, but not all.
The top 6 OTUs have >5000 sequence associated with them.  

###2.  Josh:  swarm - TBD

###3.  John: uclust NO prefilter
~22,000 OTUs,
with the .90 prefilter, got ~8,250 OTUs
John’s code:

Without Filter 
>pick_open_reference_otus.py -i /macqiime/QIIME/Bioinformatics/mock.fna -r /macqiime/greengenes/gg_13_8_otus/rep_set/97_otus.fasta -o /macqiime/QIIME/Bioinformatics/ -f
With Filter 
```
pick_open_reference_otus.py -i /macqiime/QIIME/Bioinformatics/mock.fna -r /macqiime/greengenes/gg_13_8_otus/rep_set/97_otus.fasta --prefilter_percent_id 0.9 -o /macqiime/QIIME/Bioinformatics/ -f
```

###4.  Ashley:
```
pick_open_reference_otus.py -i combined_seqs.fna -m uclust --prefilter_percent_id .95 -o uclust_openref_prefilter095/ 
```
OTUS:  4691
w/ no pynast prefiler : 4691

###5.  Sang-Hoon
```
pick_otus.py -i combined_seqs.fna -m sumaclust --sumaclust_exact -o ./picked_OTUs_sumaclust_exact/ -s 0.97
```
it showed 20,789 OTUs. 

###6.  Josh:  Trie at .97 similarity - very sucky but very fast.
106,722 OTUs

##Part 2.  Understanding the mock community results
Here are Jackson’s commands from the mock-community investigation:
Make OTU Table from Biom Table
```
biom convert --to-tsv -i otu_table_mc2_w_tax.biom --table-type="OTU table" -o usearchopenotutable.txt --header-key taxonomy
```

Call R
R

Read Table into R

```
data=read.table("usearchopenotutable.txt", sep="\t", row.names=1)
```

Histogram of number of otus (y) containing number of sequences(x)
```
hist(data[,1])
```

Grab all of the OTUs assigned to a specific taxonomy. Example here is order Pseudomonadales.
```
po=data[grep("o__Pseudomonadales",data[,2]),]
```

Sum the number of sequences in po
```
sum(po[,1])
```
We explored the mock community OTUs using Jackson’s usearch61 open reference results (no prefilter).  

A few notes:
*There are 6 taxa that should be represented equally in our sample, normalized by copy of 16S rRNA genes and amount of DNA added to the sequencing reaction from each strain.  These include:  E. coli, Deinococcus thermos, Pseudomonas syringe, Flavobacterium johnsoniae, Bacillus cereus, and Burkholderia thailendensis.  
*The usearch61 clustering resulted in ~9,500 OTUs and 285,130 total sequences among them.
*The top 6 most abundant OTUs in the mock community were assigned taxonomy that match our expectations of the input strains.  These top 6 OTUs were each had abundances of > 5000 sequences.
*The top 6 strains were not equally represented in their sequences.


Results from usearch61 open reference, no prefilter
OTU/ Strain
No. sequences for most abundant OTU
Total no. sequences across all OTUs of the same Order
Bacillus cereus
64,092
74,760
Flavo
36,104
41,125
E. coli
30,737
46,525
Burk
19,057
23,088
Deino
18,285
19,640

Pseudo
14,486
19,951

Total
225,089 / 285,130 total sequences 

##Part 3.  Outstanding questions
###1.  What are the remaining ~60K sequences that are not affiliated with our 6 input taxa? 
     a.  contaminants?  Blast rep sequences of these OTUs to find out
     b.  chimeras - perform  a chimera check on the rep sets to find out
     c.  others options?
Sang-Hoon will lead efforts to address Q1.

###2.  Why aren’t all of the 6 strains used to build the mock community represented equally in their sequences? 
     a.  Primer/amplification bias?  Use RDP probe match tools on the 16S sequences of these taxa and their close relatives to find out.  John will work on 2a.
     b.  Database coverage bias?  Are some of these lineages less represented in the databases, and so there are fewer hits using the reference method, more de novo OTUs using the open reference method, and generally fewer taxonomic assignments?  Josh will work on 2b.
     c.  Are all copies of the 16S genes for each of our mock community strains within 97% similarity (such that they would fall into the same OTU?)?  To address this, first use the 16S genes from all of the strains and ask if they are within 97% identity.  Second, use the OTU map to identify all of the sequences affiliated with the OTUs to ask whether they proportionally represent all of the copies within a taxon.  Josh will work on 2c.
     d.  Some taxa have an unknown sequencing bias?  We would expect that all taxa should experience sequencing error rates evenly/randomly, but it is possible that some bias may exist.  TO address this, we could examine the performance of the clustering on an in silico community that has been “biased” in either a targeted or random way (using seqTR), and ask how that bias would manefest down stream.  Josh expressed interest in working on this, but we are going to table it for now.

###3.  How does pre-filtering influence the OTU picking?  
     a.  Preliminary from Ashley and John’s uclust explorations, it seems that profiteering reduces the number of erroneous OTUs and that higher thresholds reduce even further.  Jackson will apply usearch61 with prefilter of 0.90 to compare with the unfiltered.

###4.  Do low-richness communities accumulate more sequencing errors, therefore artificially inflating the number of OTUs? To understand the influence of low richness on sequencing and propagation of errors, we can glean insights by examining the mock community, the Cen13 thermophile culture community.  Jackson had this idea, and we still need to figure out how to implement.  Would we look for more chimeras/extraneous OTUs in the thermophile culture community?  (We could systematically test this by building a few mock communities over a gradient of richness…)

###5.  (Ashley thought of this after the fact, but it) - how does OTU picking with the whole dataset impact the OTUs  picked for the mock community?  Compare the mock-only analysis with the whole-dataset analysis, after we have the algorithms chosen.

#ROCK ON, DATA TIME!
