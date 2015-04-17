#Exploring different network analysis algorithms

##Basics
Important considerations for different methods of analyses that generate networks based on pairwise correlations (e.g., between every two taxa within a community):
1.  Correlation coefficient - what method is used and why, what are its assumptions
2.  Significance - p-values (significance) and q-values (false discovery); are they based on parametric or non-parametric methods
3.  Thershold of correlation - after removing non-significant correlations, how/if to determine the right "cut-off" for strength of correlations

##Methods for network generation
###1.  eLSA /FastLSA - Furhman group, Jeong-Hoon  
http://www.biomedcentral.com/1471-2164/14/S1/S3  
LSA = local similarity analysis
Coefficient(s):  Pearson's (linear) and Local Similarity (non-linear)
Significance: p-value and permuted q-values
Threshold:  user-defined
Overview:  Developed for microbial fingerprinting time series data
Pros:  
* Can calculate correlations with time-lags
* can include replicate information
* non-linear LS coefficient
* q-value for false discovery
Cons:
* computationally expensive
* normality issues?
* software doesn't seem to be maintained

###2.  MIC/MINE - Reshef and Reshef; Sang-Hoon  
http://www.exploredata.net/  
http://www.ncbi.nlm.nih.gov/pubmed/?term=MINE+reshef
Coefficient(s):  Maximal information coefficient (MIC)
Significance: p-value
Threshold:  user-defined
Overview:  Developed for any dataset, not microbial specific
Pros:  
* Can find complex, non-linear relationships
* user can sort and evalute interactions by complexity of their relationships
Cons:
* manually determine mathematical form of relationships (e.g., by plotting)
* sensitive to small sample size, >25 points needed
* manual p-value adjustment needed to accomodate different samples sizes

###3.  Molecular Ecological Networks - Deng/Zhou group; Ashley  
http://www.ncbi.nlm.nih.gov/pubmed/22646978  
http://www.biomedcentral.com/content/pdf/1471-2105-8-299.pdf  
http://www.sciencedirect.com/science/article/pii/S0375960106006530  
Coefficient(s):  
Significance: p-value
Threshold:  RMT reveals the point at which that the correlation coefficient becomes random to set threshold
Overview:  RMT developed in physics, extended to microarray and then tag-sequence data
Pros:  
* non-arbitrary threshold determination
Cons:
* web-based doesn't permit user defined parameters outside of those provided

###4.  SparCC - Friedmann group; Jackson
http://www.ncbi.nlm.nih.gov/pubmed/?term=SparCC+Friedman
Coefficient(s):  Pearson (linear)
Significance: bootstrapped p-value
Threshold:  user-defined
Overview: Created for microbial (microbiome) datasets, default log-transform data to account for issues with using relative abundance data
Pros:  
* non-parametric p
* iterative removal of strong correlations so that rare taxa are not over shadowed by prevalent taxa after log transformation
Cons:
* computationally expensive to get the p-values
* linear interaction assumed on log-transformed dasta

###5.  WGCNA - Horvath et al. BMC 2008; update in 2014, maybe new paper coming out?: Josh and John
http://www.ncbi.nlm.nih.gov/pubmed/19114008  
Coefficient(s):  Pearson, spearman, or kendall (Linear)
Significance: p-value
Threshold:  weighted option: apply threshold based on exponent from the network topology
Overview:  Developed for microarray data, extended to microbial communities.  Relies on changes in intensity (relative abundance)
Pros:  
* non-arbitrary threshold determination
* workflow for how to analyze network after it is built - emphasis is on downstream analysis rather than network generation
Cons:
* linear only
* parametric

###6.  Co-Neg - add-on to Cytoscape; Paul
http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1002606  


##Dataset formatting
1.  work to zcore the environmental data - something up with decostand function in that average of standardized variables =! 0 (?)
2.  Explore JH dataset - original = 17 samples, 1000 OTUs; omit singletons and zeros to have a final dataset of 17 samples and 433 OTUs.
3.  Update:  decostand working propperly, all formatted input files (OTUs only, and OTUs + environmental data) are here:    https://github.com/ShadeLab/NetworkAnalysisWorkflows/tree/master/FormattingInputData

##MEN:  Ashley notes
1.  Tried to access MEN, had to register for a login, after registration the login failed, but on a second try (with an existing login), it worked.
2.  Formatting:  need to add “ID” to the OTU column ID


3.  web software interface



##SparCC:  Jackson notes
Fairly straightforward install;
Download SparCC [here](https://bitbucket.org/yonatanf/sparcc/downloads)
Unzip the file and cd into the resulting directory. All commands must be run while in this directory.
Followed the following tutorial http://psbweb05.psb.ugent.be/conet/microbialnetworks/sparcc.php
####Make initial correlations
````
python SparCC.py JH_OTUs_nosigs_env.txt -i 10 --cor_file=JH_OTUs_nosigs_env_sparcc.txt > sparcc.log
````
####Make replicate data sets(i.e. shuffle the data across rows)
````
python MakeBootstraps.py JH_OTUs_nosigs_env.txt -n 100 -o Resamplings/boot
````
Note that you will have to make the directory Resamplings before running the above command. The programs will not automatically make that directory
####Calculate correlations for each replicate dataset
````
./SparCC_Bootstrapping.sh
````
This is a shell script I wrote to iterativley run the correlations. I will add it to the repository.
####Compute p-values
````
python PseudoPvals.py JH_OTUs_nosig_env_sparcc.txt Bootstraps/sim_cor 10 -o pvals_two_sided.txt -t 'two_sided' >> sparcc.log
````


##LSA:  Jeong-Hoon notes
Installation is a problem - RPY2 issues; must install legacy version RPY2 2.3.1
https://pypi.python.org/pypi/rpy2/2.3.1

##MIC:  Sang-Hoon notes
# every tables should be saved as a tap-delimitated format

* Preparing tables (otu and environmental factors) for MINE analysis
: run R script = “Rworkflow_dataformatting.R”
: environmental variables are standardized and all of information are collected in one final table.

   - out put = “filename”_nosigs_env.txt

* MINE operation.
1. Check JAVA version in your computer (32 or 64 bit, or installation status)
     Check with : java -jar MINE.jar

2. Down load 2 of source files from MINE webpage
   http://www.exploredata.net/Downloads/MINE-Application
  - MINE.r
- MINE.jar

3. Also download P-value table for next analysis
   http://www.exploredata.net/Downloads/P-Value-Tables
   - choose exact or similar numbers of p-value file for your sample number.

4. Run R script (MINE_RUN.r)
install.packages("rJava") # 1-time initialization step
library("rJava", lib.loc="~/R/win-library/3.1")
source("MINE.r")
MINE("yoursamplename.txt","all.pairs")

- output =  yoursamplename.txt,allpairs,cv=0.0,B=n^0.6,Status.txt,
                      yoursamplename.txt,allpairs,cv=0.0,B=n^0.6,Results.txt

* Data re-sorting for cytoscape
1. before running, the columns and rows in the final data table from MINE should be converted vise versa.
2. Run R script: “MINE_R_Function.r”

=> output: AdjP.txt, MINE_pvalue.txt, yoursamplename.txt,allpairs,cv=0.0,B=n^0.6,Results.adjp.txt
                   Yoursamplename_mine2Cyto.txt


## WGCNA: Josh's Notes

[Paper Link from 2008](http://www.biomedcentral.com/1471-2105/9/559)

[WGCNA Home Page](http://labs.genetics.ucla.edu/horvath/CoexpressionNetwork/)

[WGCNA R Tutorial](http://labs.genetics.ucla.edu/horvath/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/FemaleLiver-01-dataInput.pdf)

R code I used to install WGCNA (Thanks to Paul for list of dependencies):
```
getCRANmirrors(all = FALSE, local.only = FALSE)
options(repos=structure(c(CRAN="http://ftp.ussg.iu.edu/CRAN/")))
source("http://bioconductor.org/biocLite.R")
biocLite("bioDist")
biocLite("impute”)
biocLite("preprocessCore")
install.packages("WGCNA")
```

##Co-net:  Paul
GUi interface, weight metrics that you want to use in Cityscape, lots of options
install java, install cytoscape, and then add the plug-in Co-Net “cytoscape app"

The bottom line:  CoNet uses an “ensemble approach”, where it calculates multiple metrics (Pearson’s, Spearman, Kendall) and models pairwise OTU abundances using generalized boosted linear models (GBLMs) with the multiple metrics as parameters. Their paper (attached) says that each by itself the regular metrics, like pearson’s, spearman and kendall, detect spurious correlations in compositional datasets. Log-ratio based metrics, including sparcc(), can work well with compositional data, but they make parametric statistics difficult, and usually resort to bootstrapping to calculate significance of detected correlations. Using GBLMs with multiple regular metrics minimizes compositional artifacts and allows for parametric statistics for significance calculations.

Platform: Full-on GUI through Cytoscape, although kind of busy and overwhelming. Point-and-click menus, check boxes, boxes for values, sliding scales. No fewer than 100 buttons.

Installation notes:
1. Install Java (from java site) version 7 or greater
2. Install Cytoscape (http://www.cytoscape.org/download.php)
3. Open Cytoscape, go to app manager and install CoNet

Input data formatting notes
Correlations are computed for rows. Rows must be OTUs and columns are samples. Matrix must have a value in the upper left cell (I use “OTU”).
