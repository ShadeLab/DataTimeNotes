##Get on the EC2, hook up with the qiime 1.9.0 image

* Go to the QIIME resources page to find the most recent AMI: http://qiime.org/home_static/dataFiles.html
* Log onto Amazon EC2.  Click on EC2 (upper left screen)
* Click on the blue “launch instance” button
* On the left menu panel, click on “Community AMIs"
* Paste the latest QIIME AMI into the search box.
* Select the general purpose “m3.large” instance
* Click “configure details”
…. go through the configuration; do not change any other defaults except to add your key.
     
New tutorial:  transferring files to and from EC2
Install Filezilla before arrival?  as back up for file transfer

SCP from your home computer to the EC2 instance:
```
scp -i ~/KEY.pem mock_com_merged.fastq ubuntu@ec2-UNIQUE-INSTANCE-NUMBERS.compute-1.amazonaws.com:/home/ubuntu/ 
```

Once in qiime:
Step 1:
Convert fastq to fasta + qual files (do this in PANDAseq in advance)
```
convert_fastaqual_fastq.py -f pandaseq_merged/mock_com_merged.fastq -c fastq_to_fastaqual
```
Step 2: add_qiime_labels.py

make your mapping file in a text editor and UPLOAD IT WITH YOUR DATA!  Do not try to do it on the EC2!
```
add_qiime_labels.py -i fastq_to_fna/ -m map2.txt -c Description 
```
One of the columns must contain the .fna exact file name.  In the above case, it was in the Description column

OTU picking:
de novo - OTU based on seq. identity
ref based - OTU based on identity/match to an existing gold standard database
closed ref - ref based, discard any sequences that do not hit the database.  best for well-described systems and genes that have well-populated databases.
open ref:  use database first, then de novo cluster sequences that do not hit database.  best for systems that are underdescribed/genes that do no populate the databases.

Next week algorithm exploration:
pick_otus.py swarm:  Josh   
pick_otus.py sumaclust: Sang-Hoon   
pick_open_reference.py uclust w/ prefilter: Ashley   
pick_open_reference.py uclust (no prefilter): John   
pick_open_reference.py usearch61 : Jackson   


