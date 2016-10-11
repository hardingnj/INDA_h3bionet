## Aims

To investigate the variation present in African vs Asian strains of plasmodium falciparum. We will focus on the kelch13 gene. We hopeto answer the following specific questions:

a) Are samples from The Gambia more similar to Senegal or Malawi?

b) Is there more diversity in African or Asian populations?

c) Are the samples from unknown countries more similar to African or Asian populations?

## Day 1

By the end of the day we should have the metadata information loaded into an Rstudio session.

1. Download the metadata file from the pf3k website.
2. Load metadata into R
3. Create a table of how many samples we have from each country.
4. Create a new variable describing whether the sample is from Asia or Africa.

## Day 2

By the end of the day we want to have a VCF file filtered by:
a. Position
b. Variant type is SNP 
c. Quality

The first task is to install tabix and vcf lib. First please read the introduction into the two tools at:
- http://www.htslib.org/doc/tabix.html
- https://github.com/vcflib/vcflib

Both of these tools must be installed on linux. Both are written in C, and so need to be compiled. This means transforming the code wecan understand into some instructions that the computer can understand. It is very inefficient for a computer to read the code like we do. 

As a first step, get onto a linux terminal and create the following directory structure:

```
# first make sure you are in your home directory
cd

# create a directory that will contain all of your analysis data and code
mkdir h3bionet

# and change directory to the directory we have just created
cd h3bionet

# copy all of your files to this directory
# NOTE: If you prefer you can do this via the file explorer.
cp pf3k_release_5_metadata.txt .
cp comparative_genomics.R .

# now create a new "run_pipeline.sh" script 
```

You should now have a directory on a linux machine containing: 

- your metadata file
- your R analysis script
- your (empty) pipeline script
















3. Parse the vcf data, extracting positions. Use vcf-lib. YASSINE's computer.
4. Parse the vcf data, extracting genotypes
5. Read 3 and 4 into R.


