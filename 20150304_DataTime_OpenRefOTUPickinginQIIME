Problem:  usearch62 memory issues - maximum is 4 Gb, our datasets are >15G in itself

Solution :  parcel the dataset into individual samples QIIME’s “iterative” step, and run them.  Problem - are the OTU IDs going to be overlapping/ the same ref seq across samples in which OTUs have been individually picked?

-Josh has a work around - break up the .fna into individual samples, and for each de novo OTU, append to the greengenes reference db, and then use the revised database for the reference to sample 2, etc.

-Jackson had a suggestion to go back, using the gg_appended db, and the go from scratch calling “reference-based” OTUs - they should all hit the reference if it was working.

-After inspecting Sang-Hoon’s QIIME-iteratively run dataset (with QIIME suggested approach), it seems that the de novo OTUs are appended to the database, just as Josh suggested.  This approach is great (seems that the OTUs will overlap across samples), but not conducive to HPCC scheduling.  So, we may have to use Josh’s algorithm for HPCC.

Updates from mock community
-Jackson did a quick clustering on the tags from the Cen13 scraped pool of thermophiles, and got ~2200 OTUs, using open_ref with usearch61, no prefilter

-how to move forward - a workflow for analyzing a mock community to inform analysis

JGI/Grant proposal
Sang-Hoon will make barcharts and ordinations with 16S tag data
Ashley will make summary chemistry data charts
Jackson will make a story about Who are the Centralia Thermophiles based on 16S tags
Josh will perform summary statistics for shotgun metagenome dataset/ visualize metabolic map
John will work with Josh to search for ars or pah genes in metagenome
