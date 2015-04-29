##Factors affecting OTU over-inflaction
###Updates
* Removing sequences with barcode errors recreases the number of OTUs in the mock community by ~10%.  This is still ~9,000 more OTUs than we expect in that community.
* Outstanding problem:  We still have too many OTUs and we don't know why.

###Ideas for moving forward
* Different OTU picking options - may improve our OTUs, but none will be straightforward in interfacing with QIIME
Options   
  * How is the uparse working?  Dr. Edgar said it corrects errors.  Can we use this tool for better OTU definitions?
  * Try the Minimum Entropy algorithm from MBL.  (Jackson will install on AMI and use it on the mock community)
  * QIIME uses usearch61.  A newer version of usearch may corrects this.  Try the latest version, has to be outside of QIIME

* Clustering OTUs by occurrence patterns will allow for discovery of prevalent and rare taxa from the same lineages, which may actually be a single "split" OTU.  (Sang-Hoon will lead this effort with his heat map analysis).
* Examining less abundant sequences for polymorphisms and errors may allow for un-splitting of de novo OTUs (Josh will work with Jackson on this)
* For "deep sequencing", does sequence error scale with community richness?  Do less rich communities propagate more sequencing errors than more rich?  Can we make an in silico model explaining error propogation by richness and sequencing effort?.  The parameters are: community richness (no. of taxa), error rate, sequencing effort, illumina error rates (1%).
